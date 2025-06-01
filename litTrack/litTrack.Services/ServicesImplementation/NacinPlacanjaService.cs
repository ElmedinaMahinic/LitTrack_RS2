using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.ServicesImplementation
{
    public class NacinPlacanjaService : BaseServiceAsync<Model.DTOs.NacinPlacanjaDTO, NacinPlacanjaSearchObject, Database.NacinPlacanja>, INacinPlacanjaService
    {
        public NacinPlacanjaService(_210078Context context, IMapper mapper)
        : base(context, mapper)
        {
        }

        public override IQueryable<NacinPlacanja> AddFilter(NacinPlacanjaSearchObject searchObject, IQueryable<Database.NacinPlacanja> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.Naziv))
            {
                var nazivLower = searchObject.Naziv.ToLower();
                query = query.Where(x => x.Naziv.ToLower().Contains(nazivLower));
            }

            return query;
        }
    }
}
