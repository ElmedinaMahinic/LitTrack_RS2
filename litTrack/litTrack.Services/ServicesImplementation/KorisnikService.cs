﻿using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Helpers;
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
        private readonly IActiveUserServiceAsync _activeUserService;

        public KorisnikService(_210078Context context, IMapper mapper,
            IUlogaValidator ulogaValidator, IKorisnikValidator korisnikValidator,
            ILogger<KorisnikService> logger, IPasswordService passwordService,
            IActiveUserServiceAsync activeUserService
         )
            : base(context, mapper)
        {
            _ulogaValidator = ulogaValidator;
            _korisnikValidator = korisnikValidator;
            _logger = logger;
            _passwordService= passwordService;
            _activeUserService= activeUserService;
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
            {
                var korisnickoImeLower = searchObject.KorisnickoIme.ToLower();
                query = query.Where(x => x.KorisnickoIme.ToLower().Contains(korisnickoImeLower));
            }


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

        public override async Task<PagedResult<KorisnikDTO>> GetPagedAsync(KorisnikSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.Korisniks
                .Include(k => k.KorisnikUlogas)
                    .ThenInclude(ku => ku.Uloga)
                .Where(k => !k.IsDeleted);

            query = AddFilter(search, query);

            var count = await query.CountAsync(cancellationToken);

            if (!string.IsNullOrEmpty(search?.OrderBy) &&
                !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if (search?.Page.HasValue == true && search.PageSize.HasValue)
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync(cancellationToken);

            var result = Mapper.Map<List<KorisnikDTO>>(list);

            for (int i = 0; i < result.Count; i++)
            {
                var korisnik = list[i];

                result[i].Uloge = korisnik.KorisnikUlogas
                    .Where(ku => !ku.IsDeleted && ku.Uloga != null && !ku.Uloga.IsDeleted)
                    .Select(ku => ku.Uloga.Naziv)
                    .Distinct()
                    .ToList();
            }

            return new PagedResult<KorisnikDTO>
            {
                ResultList = result,
                Count = count
            };
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

            var loggedUserId = await _activeUserService.GetActiveUserIdAsync(cancellationToken);
            var loggedUserRole = await _activeUserService.GetActiveUserRoleAsync(cancellationToken);

            if (loggedUserRole != "Admin" && loggedUserId != entity.KorisnikId)
            {
                throw new UserException("Nemate pravo da uređujete tuđi profil.");
            }


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

            if (request.JeAktivan == null)
            {
                entity.JeAktivan = true;
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

        public async Task<KorisnikDTO> GetInfoAsync(CancellationToken cancellationToken = default)
        {
            var userId = await _activeUserService.GetActiveUserIdAsync(cancellationToken)
                ?? throw new UserException("Korisnik nije prijavljen.");

            var user = await Context.Korisniks
                .Where(x => x.KorisnikId == userId)
                .FirstOrDefaultAsync(cancellationToken)
                ?? throw new UserException("Korisnik nije pronađen.");

            return Mapper.Map<KorisnikDTO>(user);
        }


        public async Task AktivirajAsync(int korisnikId, CancellationToken cancellationToken = default)
        {
            if (korisnikId <= 0)
                throw new UserException("Neispravan ID korisnika.");

            var korisnik = await Context.Korisniks
                .FirstOrDefaultAsync(x => x.KorisnikId == korisnikId && !x.IsDeleted, cancellationToken);

            if (korisnik == null)
                throw new UserException("Korisnik nije pronađen.");

            if (korisnik.JeAktivan == true)
                throw new UserException("Korisnik je već aktivan.");

            korisnik.JeAktivan = true;

            await Context.SaveChangesAsync(cancellationToken);
        }

        public async Task DeaktivirajAsync(int korisnikId, CancellationToken cancellationToken = default)
        {
            if (korisnikId <= 0)
                throw new UserException("Neispravan ID korisnika.");

            var korisnik = await Context.Korisniks
                .FirstOrDefaultAsync(x => x.KorisnikId == korisnikId && !x.IsDeleted, cancellationToken);

            if (korisnik == null)
                throw new UserException("Korisnik nije pronađen.");

            if (korisnik.JeAktivan == false)
                throw new UserException("Korisnik je već deaktiviran.");

            korisnik.JeAktivan = false;

            await Context.SaveChangesAsync(cancellationToken);
        }

    }
}
