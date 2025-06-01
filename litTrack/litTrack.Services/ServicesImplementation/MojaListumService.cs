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
    public class MojaListumService : BaseCRUDServiceAsync<Model.DTOs.MojaListumDTO, MojaListumSearchObject, Database.MojaListum, MojaListumInsertRequest, MojaListumUpdateRequest>, IMojaListumService
    {
        private readonly IKorisnikValidator _korisnikValidator;
        private readonly IKnjigaValidator _knjigaValidator;
        public MojaListumService(_210078Context context, IMapper mapper, IKorisnikValidator korisnikValidator,
            IKnjigaValidator knjigaValidator)
            : base(context, mapper)
        {
            _korisnikValidator = korisnikValidator;
            _knjigaValidator = knjigaValidator;
        }

        public override IQueryable<Database.MojaListum> AddFilter(MojaListumSearchObject searchObject, IQueryable<Database.MojaListum> query)
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

            if (searchObject.JeProcitana != null)
            {
                query = query.Where(x => x.JeProcitana == searchObject.JeProcitana);
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

        public override async Task<PagedResult<MojaListumDTO>> GetPagedAsync(MojaListumSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.MojaLista
                .Include(m => m.Knjiga)
                    .ThenInclude(k => k.Autor)
                .Where(m => !m.IsDeleted);

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

            var result = Mapper.Map<List<MojaListumDTO>>(list);

            for (int i = 0; i < result.Count; i++)
            {
                var knjiga = list[i].Knjiga;
                if (knjiga == null) continue;

                result[i].NazivKnjige = knjiga.Naziv;
                result[i].Cijena = knjiga.Cijena;
                result[i].Slika = knjiga.Slika;
                result[i].AutorNaziv = $"{knjiga.Autor.Ime} {knjiga.Autor.Prezime}";
            }

            return new PagedResult<MojaListumDTO>
            {
                ResultList = result,
                Count = count
            };
        }


        public override async Task BeforeInsertAsync(MojaListumInsertRequest request, Database.MojaListum entity, CancellationToken cancellationToken = default)
        {
            
            var postoji = await Context.MojaLista
                .AnyAsync(x => x.KorisnikId == request.KorisnikId
                            && x.KnjigaId == request.KnjigaId
                            && !x.IsDeleted,
                          cancellationToken);

            if (postoji)
                throw new UserException("Ova knjiga je već dodana u listu.");

            
            await _korisnikValidator.ValidateEntityExistsAsync(request.KorisnikId, cancellationToken);
            await _knjigaValidator.ValidateEntityExistsAsync(request.KnjigaId, cancellationToken);

            
            entity.IsDeleted = false;
            entity.JeProcitana = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }


        public async Task OznaciKaoProcitanuAsync(int mojaListaId, CancellationToken cancellationToken = default)
        {
            var entity = await Context.MojaLista
                .FirstOrDefaultAsync(x => x.MojaListaId == mojaListaId && !x.IsDeleted, cancellationToken);

            if (entity == null)
                throw new UserException("Zapis nije pronađen.");

            if (entity.JeProcitana)
                throw new UserException("Knjiga je već označena kao pročitana.");

            entity.JeProcitana = true;
            await Context.SaveChangesAsync(cancellationToken);
        }
    }
}
