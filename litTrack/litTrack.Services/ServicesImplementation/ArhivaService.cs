using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
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
    public class ArhivaService : BaseCRUDServiceAsync<Model.DTOs.ArhivaDTO, ArhivaSearchObject, Database.Arhiva, ArhivaInsertRequest, ArhivaUpdateRequest>, IArhivaService
    {
        private readonly IKorisnikValidator _korisnikValidator;
        private readonly IKnjigaValidator _knjigaValidator;
        public ArhivaService(_210078Context context, IMapper mapper, IKorisnikValidator korisnikValidator,
            IKnjigaValidator knjigaValidator)
            : base(context, mapper)
        {
            _korisnikValidator = korisnikValidator;
            _knjigaValidator = knjigaValidator;
        }

        public override IQueryable<Database.Arhiva> AddFilter(ArhivaSearchObject searchObject, IQueryable<Database.Arhiva> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.KnjigaId != null)
            {
                query = query.Where(x => x.KnjigaId == searchObject.KnjigaId);
            }

            if (searchObject.DatumDodavanjaGTE != null)
            {
                query = query.Where(x => x.DatumDodavanja >= searchObject.DatumDodavanjaGTE);
            }

            if (searchObject.DatumDodavanjaLTE != null)
            {
                query = query.Where(x => x.DatumDodavanja <= searchObject.DatumDodavanjaLTE);
            }

            return query;
        }

        public override async Task<PagedResult<ArhivaDTO>> GetPagedAsync(ArhivaSearchObject search,CancellationToken cancellationToken = default)
        {
           
            var query = Context.Arhivas
                .Include(a => a.Knjiga)
                    .ThenInclude(k => k.Autor)
                .Where(a => !a.IsDeleted);   

            
            query = AddFilter(search, query);

            
            int count = await query.CountAsync(cancellationToken);

            
            if (!string.IsNullOrEmpty(search?.OrderBy) &&
                !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }


            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            
            var list = await query.ToListAsync(cancellationToken);

            var result = new List<ArhivaDTO>();
            result = Mapper.Map(list, result);

            for (int i = 0; i < result.Count; i++)
            {
                var knjiga = list[i].Knjiga;
                if (knjiga is null) continue;

                result[i].NazivKnjige = knjiga.Naziv;
                result[i].Cijena = knjiga.Cijena;
                result[i].Slika = knjiga.Slika;
                result[i].AutorNaziv = $"{knjiga.Autor.Ime} {knjiga.Autor.Prezime}";
            }

            
            return new PagedResult<ArhivaDTO>
            {
                ResultList = result,
                Count = count
            };
        }

        public override async Task BeforeInsertAsync(ArhivaInsertRequest request, Database.Arhiva entity, CancellationToken cancellationToken = default)
        {
            
            var postojiZapis = await Context.Arhivas
                .AnyAsync(x => x.KorisnikId == request.KorisnikId && x.KnjigaId == request.KnjigaId && !x.IsDeleted, cancellationToken);

            if (postojiZapis)
            {
                throw new UserException("Ova knjiga je već arhivirana.");
            }

            await _korisnikValidator.ValidateEntityExistsAsync(request.KorisnikId, cancellationToken);

            await _knjigaValidator.ValidateEntityExistsAsync(request.KnjigaId, cancellationToken);

            entity.IsDeleted = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }



        public async Task<int> GetBrojArhiviranjaAsync(int knjigaId, CancellationToken cancellationToken = default)
        {
            return await Context.Arhivas
                .Where(a => a.KnjigaId == knjigaId && !a.IsDeleted)
                .CountAsync(cancellationToken);
        }

        public async Task<string> GetNajdrazaKnjigaNazivAsync(CancellationToken cancellationToken = default)
        {
            var najdraza = await Context.Arhivas
                .Where(a => !a.IsDeleted)
                .GroupBy(a => a.KnjigaId)
                .Select(g => new
                {
                    KnjigaId = g.Key,
                    BrojArhiviranja = g.Count()
                })
                .OrderByDescending(g => g.BrojArhiviranja)
                .FirstOrDefaultAsync(cancellationToken);

            if (najdraza == null)
                return "Nema podataka";

            var knjiga = await Context.Knjigas
                .Where(k => k.KnjigaId == najdraza.KnjigaId && !k.IsDeleted)
                .Select(k => k.Naziv)
                .FirstOrDefaultAsync(cancellationToken);

            if (knjiga == null)
                return "Nema podataka";

            return knjiga;
        }

        public async Task<PagedResult<KnjigaFavoritDTO>> GetKnjigeFavoritiAsync(KnjigaFavoritSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.Arhivas
                .Where(a => !a.IsDeleted)
                .GroupBy(a => a.KnjigaId)
                .Select(g => new
                {
                    KnjigaId = g.Key,
                    BrojArhiviranja = g.Count()
                })
                .Join(Context.Knjigas.Include(k => k.Autor),
                    arhiva => arhiva.KnjigaId,
                    knjiga => knjiga.KnjigaId,
                    (arhiva, knjiga) => new KnjigaFavoritDTO
                    {
                        KnjigaId = knjiga.KnjigaId,
                        NazivKnjige = knjiga.Naziv,
                        AutorNaziv = knjiga.Autor.Ime + " " + knjiga.Autor.Prezime,
                        Slika = knjiga.Slika,
                        BrojArhiviranja = arhiva.BrojArhiviranja
                    });

            query = search.SortDirection?.ToLower() == "asc"
                ? query.OrderBy(x => x.BrojArhiviranja)
                : query.OrderByDescending(x => x.BrojArhiviranja);

            int count = await query.CountAsync(cancellationToken);

            if (search.Page.HasValue && search.PageSize.HasValue)
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var resultList = await query.ToListAsync(cancellationToken);

            return new PagedResult<KnjigaFavoritDTO>
            {
                Count = count,
                ResultList = resultList
            };
        }

    }
}
