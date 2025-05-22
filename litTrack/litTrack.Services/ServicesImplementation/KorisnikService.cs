using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Auth;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.Validators.Implementation;
using litTrack.Services.Validators.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.ServicesImplementation
{
    public class KorisnikService : BaseCRUDServiceAsync<Model.DTOs.KorisnikDTO, KorisnikSearchObject, Database.Korisnik, KorisnikInsertRequest, KorisnikUpdateRequest>, IKorisnikService
    {
        private readonly IUlogaValidator _ulogaValidator;
        private readonly IKorisnikValidator _korisnikValidator;
        private readonly ILogger<KorisnikService> _logger;
        private readonly IPasswordService _passwordService;

        public KorisnikService(_210078Context context, IMapper mapper,
            IUlogaValidator ulogaValidator, IKorisnikValidator korisnikValidator,
            ILogger<KorisnikService> logger, IPasswordService passwordService
         )
            : base(context, mapper)
        {
            _ulogaValidator = ulogaValidator;
            _korisnikValidator = korisnikValidator;
            _logger = logger;
            _passwordService= passwordService;
        }

        public override IQueryable<Korisnik> AddFilter(KorisnikSearchObject searchObject, IQueryable<Korisnik> query)
        {
            query = base.AddFilter(searchObject, query);

           
            if (!string.IsNullOrWhiteSpace(searchObject.ImePrezime))
            {
                var imePrezime = searchObject.ImePrezime.ToLower();

                query = query.Where(k =>
                    (k.Ime + " " + k.Prezime).ToLower().Contains(imePrezime) ||
                    k.Ime.ToLower().Contains(imePrezime) ||
                    k.Prezime.ToLower().Contains(imePrezime));
            }

            
            if (!string.IsNullOrWhiteSpace(searchObject.Email))
                query = query.Where(k => k.Email.ToLower().Contains(searchObject.Email.ToLower()));

            if (!string.IsNullOrWhiteSpace(searchObject.KorisnickoIme))
                query = query.Where(k =>
                    k.KorisnickoIme.Equals(searchObject.KorisnickoIme,
                                           StringComparison.OrdinalIgnoreCase));

            if (!string.IsNullOrWhiteSpace(searchObject.Telefon))
                query = query.Where(k => k.Telefon != null &&
                                         k.Telefon.ToLower().Contains(searchObject.Telefon.ToLower()));

            
            if (searchObject.JeAktivan.HasValue)
                query = query.Where(k => k.JeAktivan == searchObject.JeAktivan);

            
            if (searchObject.UlogaId.HasValue)
            {
                query = query.Where(k => k.KorisnikUlogas.Any(ku => ku.UlogaId == searchObject.UlogaId))
                             .Include(k => k.KorisnikUlogas)
                             .ThenInclude(ku => ku.Uloga);
            }

            return query;
        }

        public override async Task<KorisnikDTO> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var korisnik = await Context.Korisniks
                .Include(k => k.KorisnikUlogas)
                    .ThenInclude(ku => ku.Uloga)
                .FirstOrDefaultAsync(k => k.KorisnikId == id && !k.IsDeleted, cancellationToken);

            if (korisnik == null)
                throw new UserException("Uneseni ID ne postoji.");

            var dto = Mapper.Map<KorisnikDTO>(korisnik);

            dto.Uloge = korisnik.KorisnikUlogas
                .Where(ku => !ku.IsDeleted && !ku.Uloga.IsDeleted)
                .Select(ku => ku.Uloga.Naziv)
                .Distinct()
                .ToList();

            return dto;
        }


        public override async Task BeforeInsertAsync(KorisnikInsertRequest request, Korisnik entity, CancellationToken cancellationToken = default)
        {
            await _korisnikValidator.ValidateInsertAsync(request, cancellationToken);

            _ulogaValidator.ValidateNoDuplicates(request.Uloge);         
            foreach (int ulogaId in request.Uloge)                       
                await _ulogaValidator.ValidateEntityExistsAsync(ulogaId, cancellationToken);

            entity.LozinkaSalt = _passwordService.GenerateSalt();
            entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);


            entity.DatumRegistracije = DateTime.Now;
            entity.JeAktivan = true;
            entity.IsDeleted = false;

            _logger.LogInformation("Dodavanje korisnika sa korisničkim imenom: {KorisnickoIme}", entity.KorisnickoIme);


            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }


        public override async Task AfterInsertAsync(KorisnikInsertRequest request, Database.Korisnik entity, CancellationToken cancellationToken = default)
        {
            if (request.Uloge?.Any() == true)
            {
                var korisnikUloge = request.Uloge.Select(ulogaId => new Database.KorisnikUloga
                {
                    KorisnikId = entity.KorisnikId,
                    UlogaId = ulogaId,
                    IsDeleted= false
                }).ToList();


                Context.KorisnikUlogas.AddRange(korisnikUloge);
                await Context.SaveChangesAsync(cancellationToken);
            }

            await base.AfterInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(KorisnikUpdateRequest request, Korisnik entity, CancellationToken cancellationToken = default)
        {

            await base.BeforeUpdateAsync(request, entity, cancellationToken);

            await _korisnikValidator.ValidateUpdateAsync(entity.KorisnikId, request, cancellationToken);

            bool zeliPromijenitiLozinku =
                !string.IsNullOrWhiteSpace(request.StaraLozinka) ||
                !string.IsNullOrWhiteSpace(request.Lozinka) ||
                !string.IsNullOrWhiteSpace(request.LozinkaPotvrda);

            if (zeliPromijenitiLozinku)
            {
                if (string.IsNullOrWhiteSpace(request.StaraLozinka))
                    throw new UserException("Morate unijeti staru lozinku.");

                if (string.IsNullOrWhiteSpace(request.Lozinka) || string.IsNullOrWhiteSpace(request.LozinkaPotvrda))
                    throw new UserException("Morate unijeti novu lozinku i njenu potvrdu.");

                if (request.Lozinka != request.LozinkaPotvrda)
                    throw new UserException("Nova lozinka i potvrda lozinke se ne podudaraju.");

                var stariHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.StaraLozinka);
                if (stariHash != entity.LozinkaHash)
                    throw new UserException("Unesena stara lozinka nije tačna.");


                entity.LozinkaSalt = _passwordService.GenerateSalt();
                entity.LozinkaHash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);

                _logger.LogInformation("Korisnik {Username} je uspješno promijenio lozinku.", entity.KorisnickoIme);

            }
        }

        public async Task<KorisnikDTO> LoginAsync(KorisnikLoginRequest request, CancellationToken cancellationToken = default)
        {
            var entity = await Context.Korisniks
              .Include(k => k.KorisnikUlogas)
              .ThenInclude(ku => ku.Uloga)
               .FirstOrDefaultAsync(k => k.KorisnickoIme == request.KorisnickoIme,
            cancellationToken);

            if (entity == null)
            {
                _logger.LogWarning("Pokušaj prijave s nepostojećim korisničkim imenom: {Username}",
                                   request.KorisnickoIme);
                throw new UserException("Neispravno korisničko ime ili lozinka.");
            }

            var hash = _passwordService.GenerateHash(entity.LozinkaSalt, request.Lozinka);

            if (hash != entity.LozinkaHash)
            {
                _logger.LogWarning("Neuspješna prijava za korisnika {Username} – pogrešna lozinka.",
                                   request.KorisnickoIme);
                throw new UserException("Neispravno korisničko ime ili lozinka.");
            }

            _logger.LogInformation("Uspješna prijava za korisnika {Username}", request.KorisnickoIme);

            var dto = Mapper.Map<KorisnikDTO>(entity);

            dto.Uloge = entity.KorisnikUlogas
                .Where(ku => !ku.IsDeleted && !ku.Uloga.IsDeleted)
                .Select(ku => ku.Uloga.Naziv)
                .Distinct()
                .ToList();

            return dto;
        }

    }
}
