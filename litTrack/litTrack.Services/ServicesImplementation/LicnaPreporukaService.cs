using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Auth;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.Validators.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.ServicesImplementation
{
    public class LicnaPreporukaService : BaseCRUDServiceAsync<Model.DTOs.LicnaPreporukaDTO, LicnaPreporukaSearchObject, Database.LicnaPreporuka, LicnaPreporukaInsertRequest, LicnaPreporukaUpdateRequest>, ILicnaPreporukaService
    {
        private readonly ILicnaPreporukaValidator _licnaPreporukaValidator;
        private readonly IKnjigaValidator _knjigaValidator;
        private readonly IActiveUserServiceAsync _activeUserService;
        public LicnaPreporukaService(_210078Context context, IMapper mapper,
            ILicnaPreporukaValidator licnaPreporukaValidator, IKnjigaValidator knjigaValidator,
            IActiveUserServiceAsync activeUserService
         )
            : base(context, mapper)
        {
            _licnaPreporukaValidator= licnaPreporukaValidator;
            _knjigaValidator = knjigaValidator;
            _activeUserService= activeUserService;
        }

        public override IQueryable<LicnaPreporuka> AddFilter(LicnaPreporukaSearchObject searchObject, IQueryable<LicnaPreporuka> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.KorisnikPosiljalacId != null)
            {
                query = query.Where(x => x.KorisnikPosiljalacId == searchObject.KorisnikPosiljalacId);
            }

            if (searchObject.KorisnikPrimalacId != null)
            {
                query = query.Where(x => x.KorisnikPrimalacId == searchObject.KorisnikPrimalacId);
            }

            if (searchObject.DatumPreporuke != null)
            {
                query = query.Where(x => x.DatumPreporuke.Date == searchObject.DatumPreporuke.Value.Date);
            }

            if (searchObject.DatumPreporukeGTE != null)
            {
                query = query.Where(x => x.DatumPreporuke >= searchObject.DatumPreporukeGTE);
            }

            if (searchObject.DatumPreporukeLTE != null)
            {
                query = query.Where(x => x.DatumPreporuke <= searchObject.DatumPreporukeLTE);
            }

            if (searchObject.JePogledana != null)
            {
                query = query.Where(x => x.JePogledana == searchObject.JePogledana);
            }


            return query;
        }

        public override async Task<PagedResult<LicnaPreporukaDTO>> GetPagedAsync(LicnaPreporukaSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.LicnaPreporukas
                .Include(x => x.LicnaPreporukaKnjigas)
                    .ThenInclude(pk => pk.Knjiga)
                .Where(x => !x.IsDeleted);

            query = AddFilter(search, query);

            int count = await query.CountAsync(cancellationToken);

            if (!string.IsNullOrEmpty(search?.OrderBy) && !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query
                    .Skip((search.Page.Value - 1) * search.PageSize.Value)
                    .Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync(cancellationToken);
            var result = Mapper.Map<List<LicnaPreporukaDTO>>(list);

            var korisnikIds = list
              .SelectMany(p => new[] { p.KorisnikPosiljalacId, p.KorisnikPrimalacId }).Distinct().ToList();

            var korisnici = await Context.Korisniks
                .Where(k => korisnikIds.Contains(k.KorisnikId))
                .Select(k => new { k.KorisnikId, k.KorisnickoIme })
                .ToDictionaryAsync(k => k.KorisnikId,
                                   k => k.KorisnickoIme,
                                   cancellationToken);

            
            for (int i = 0; i < result.Count; i++)
            {
                var p = list[i];
                var dto = result[i];

                dto.Knjige = p.LicnaPreporukaKnjigas
                    .Where(x => x.Knjiga != null && !x.IsDeleted).Select(x => x.Knjiga.Naziv).ToList();

                if (korisnici.TryGetValue(p.KorisnikPosiljalacId, out var posIme))
                    dto.PosiljalacKorisnickoIme = posIme;

                if (korisnici.TryGetValue(p.KorisnikPrimalacId, out var priIme))
                    dto.PrimalacKorisnickoIme = priIme;
            }

            return new PagedResult<LicnaPreporukaDTO>
            {
                ResultList = result,
                Count = count
            };
        }

        public override async Task<LicnaPreporukaDTO> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var preporuka = await Context.LicnaPreporukas
                .Include(p => p.LicnaPreporukaKnjigas)
                    .ThenInclude(lpk => lpk.Knjiga)
                .FirstOrDefaultAsync(p => p.LicnaPreporukaId == id && !p.IsDeleted, cancellationToken);

            if (preporuka == null)
                throw new UserException("Uneseni ID ne postoji.");

            
            var korisnikIds = new[] { preporuka.KorisnikPosiljalacId, preporuka.KorisnikPrimalacId }
                .Distinct()
                .ToArray();

            var korisnici = await Context.Korisniks
                .Where(k => korisnikIds.Contains(k.KorisnikId))
                .Select(k => new { k.KorisnikId, k.KorisnickoIme })
                .ToDictionaryAsync(k => k.KorisnikId, k => k.KorisnickoIme, cancellationToken);

            var dto = Mapper.Map<LicnaPreporukaDTO>(preporuka);

            dto.Knjige = preporuka.LicnaPreporukaKnjigas
                .Where(x => x.Knjiga != null && !x.IsDeleted)
                .Select(x => x.Knjiga.Naziv)
                .ToList();

            if (korisnici.TryGetValue(preporuka.KorisnikPosiljalacId, out var posIme))
                dto.PosiljalacKorisnickoIme = posIme;

            if (korisnici.TryGetValue(preporuka.KorisnikPrimalacId, out var priIme))
                dto.PrimalacKorisnickoIme = priIme;

            return dto;
        }



        public override async Task BeforeInsertAsync(LicnaPreporukaInsertRequest request, LicnaPreporuka entity, CancellationToken cancellationToken = default)
        {
            
            await _licnaPreporukaValidator.ValidateInsertAsync(request, cancellationToken);

            
            _knjigaValidator.ValidateNoDuplicates(request.Knjige);

            foreach (var knjigaId in request.Knjige)
                await _knjigaValidator.ValidateEntityExistsAsync(knjigaId, cancellationToken);

            foreach (var knjigaId in request.Knjige)
            {
                bool jeProcitao = await Context.MojaLista.AnyAsync(
                    x => x.KorisnikId == request.KorisnikPosiljalacId &&
                         x.KnjigaId == knjigaId &&
                         x.JeProcitana == true &&
                         !x.IsDeleted,
                    cancellationToken);

                if (!jeProcitao)
                    throw new UserException("Ne možete preporučiti knjigu koju niste pročitali.");
            }


            entity.IsDeleted = false;
            entity.JePogledana = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task AfterInsertAsync(LicnaPreporukaInsertRequest request, LicnaPreporuka entity, CancellationToken cancellationToken = default)
        {
            if (request?.Knjige != null && request.Knjige.Count > 0)
            {
                foreach (var knjigaId in request.Knjige)
                {
                    Context.LicnaPreporukaKnjigas.Add(new LicnaPreporukaKnjiga
                    {
                        LicnaPreporukaId = entity.LicnaPreporukaId,
                        KnjigaId = knjigaId,
                        IsDeleted = false
                    });
                }
            }

            await Context.SaveChangesAsync(cancellationToken);
        }



        public async Task OznaciKaoPogledanuAsync(int licnaPreporukaId, CancellationToken cancellationToken = default)
        {
            var preporuka = await Context.LicnaPreporukas
                .FirstOrDefaultAsync(p => p.LicnaPreporukaId == licnaPreporukaId &&
                                          !p.IsDeleted,
                                     cancellationToken);

            if (preporuka == null)
                throw new UserException("Lična preporuka nije pronađena.");

            var currentUserId = await _activeUserService.GetActiveUserIdAsync(cancellationToken);
            if (currentUserId == null || preporuka.KorisnikPrimalacId != currentUserId)
                throw new UserException("Pristup zabranjen.");

            if (!preporuka.JePogledana)
            {
                preporuka.JePogledana = true;
                await Context.SaveChangesAsync(cancellationToken);
            }
        }

    }
}
