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
    public class PreporukaService : BaseCRUDServiceAsync<Model.DTOs.PreporukaDTO, PreporukaSearchObject, Database.Preporuka, PreporukaInsertRequest, PreporukaUpdateRequest>, IPreporukaService
    {
        private readonly IKorisnikValidator _korisnikValidator;
        private readonly IKnjigaValidator _knjigaValidator;
        public PreporukaService(_210078Context context, IMapper mapper, IKorisnikValidator korisnikValidator,
            IKnjigaValidator knjigaValidator)
            : base(context, mapper)
        {
            _korisnikValidator = korisnikValidator;
            _knjigaValidator = knjigaValidator;
        }

        public override IQueryable<Database.Preporuka> AddFilter(PreporukaSearchObject searchObject, IQueryable<Database.Preporuka> query)
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

            if (searchObject.DatumPreporukeGTE != null)
            {
                query = query.Where(x => x.DatumPreporuke >= searchObject.DatumPreporukeGTE);
            }

            if (searchObject.DatumPreporukeLTE != null)
            {
                query = query.Where(x => x.DatumPreporuke <= searchObject.DatumPreporukeLTE);
            }

            return query;
        }

        public override async Task<PagedResult<PreporukaDTO>> GetPagedAsync(PreporukaSearchObject search, CancellationToken cancellationToken = default)
        {
            
            var query = Context.Preporukas
                .Include(p => p.Knjiga)
                    .ThenInclude(k => k.Autor)
                .Where(p => !p.IsDeleted);

            
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

            
            var result = Mapper.Map<List<PreporukaDTO>>(list);

            
            for (int i = 0; i < result.Count; i++)
            {
                var knjiga = list[i].Knjiga;
                if (knjiga is null) continue;

                result[i].NazivKnjige = knjiga.Naziv;
                result[i].Cijena = knjiga.Cijena;
                result[i].Slika = knjiga.Slika;
                result[i].AutorNaziv = $"{knjiga.Autor.Ime} {knjiga.Autor.Prezime}";
            }

            
            return new PagedResult<PreporukaDTO>
            {
                ResultList = result,
                Count = count
            };
        }


        public override async Task BeforeInsertAsync(PreporukaInsertRequest request, Database.Preporuka entity, CancellationToken cancellationToken = default)
        {
            var postojiPreporuka = await Context.Preporukas
                .AnyAsync(x => x.KorisnikId == request.KorisnikId && x.KnjigaId == request.KnjigaId && !x.IsDeleted, cancellationToken);

            if (postojiPreporuka)
            {
                throw new UserException("Već ste preporučili ovu knjigu.");
            }

            var jeProcitana = await Context.MojaLista
                .AnyAsync(x => x.KorisnikId == request.KorisnikId && x.KnjigaId == request.KnjigaId && x.JeProcitana == true && !x.IsDeleted, cancellationToken);

            if (!jeProcitana)
            {
                throw new UserException("Možete preporučiti samo knjige koje ste pročitali.");
            }

            await _korisnikValidator.ValidateEntityExistsAsync(request.KorisnikId, cancellationToken);
            await _knjigaValidator.ValidateEntityExistsAsync(request.KnjigaId, cancellationToken);

            entity.IsDeleted = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }


        public async Task<int> GetBrojPreporukaAsync(int knjigaId, CancellationToken cancellationToken = default)
        {
            return await Context.Preporukas
                .Where(p => p.KnjigaId == knjigaId && !p.IsDeleted)
                .CountAsync(cancellationToken);
        }

    }
}
