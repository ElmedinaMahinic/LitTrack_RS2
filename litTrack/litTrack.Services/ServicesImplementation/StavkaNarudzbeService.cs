using litTrack.Model.DTOs;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.NarudzbaStateMachine;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.ServicesImplementation
{
    public class StavkaNarudzbeService : BaseCRUDServiceAsync<StavkaNarudzbeDTO, StavkaNarudzbeSearchObject, StavkaNarudzbe, StavkaNarudzbeInsertRequest, StavkaNarudzbeUpdateRequest>, IStavkaNarudzbeService
    {
        public StavkaNarudzbeService(_210078Context context, IMapper mapper)
            : base(context, mapper)
        {
        }

        public override IQueryable<StavkaNarudzbe> AddFilter(StavkaNarudzbeSearchObject searchObject, IQueryable<StavkaNarudzbe> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.CijenaGTE != null)
                query = query.Where(x => x.Cijena >= searchObject.CijenaGTE);

            if (searchObject.CijenaLTE != null)
                query = query.Where(x => x.Cijena <= searchObject.CijenaLTE);

            if (searchObject.NarudzbaId != null)
                query = query.Where(x => x.NarudzbaId == searchObject.NarudzbaId);

            if (searchObject.KnjigaId != null)
                query = query.Where(x => x.KnjigaId == searchObject.KnjigaId);

            return query;
        }

        public override async Task<PagedResult<StavkaNarudzbeDTO>> GetPagedAsync(StavkaNarudzbeSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.StavkaNarudzbes.Include(s => s.Knjiga).Where(s => !s.IsDeleted);

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

            var result = new List<StavkaNarudzbeDTO>();
            result = Mapper.Map(list, result);

            for (int i = 0; i < result.Count; i++)
            {
                var knjiga = list[i].Knjiga;
                if (knjiga is null) continue;

                result[i].NazivKnjige = knjiga.Naziv;
                result[i].Slika = knjiga.Slika;
            }

            return new PagedResult<StavkaNarudzbeDTO>
            {
                ResultList = result,
                Count = count
            };
        }

    }
}
