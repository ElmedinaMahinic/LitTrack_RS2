using litTrack.Model.Exceptions;
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
    public class OcjenaService : BaseCRUDServiceAsync<Model.DTOs.OcjenaDTO, OcjenaSearchObject, Database.Ocjena, OcjenaInsertRequest, OcjenaUpdateRequest>, IOcjenaService
    {
        
        public OcjenaService(_210078Context context, IMapper mapper)
            : base(context, mapper)
        {
        
        }

        public override IQueryable<Database.Ocjena> AddFilter(OcjenaSearchObject searchObject, IQueryable<Database.Ocjena> query)
        {
            query = base.AddFilter(searchObject, query);



            if (searchObject.VrijednostGTE != null)
            {
                query = query.Where(x => x.Vrijednost >= searchObject.VrijednostGTE);
            }

            if (searchObject.VrijednostLTE != null)
            {
                query = query.Where(x => x.Vrijednost <= searchObject.VrijednostLTE);
            }


            if (searchObject.DatumOcjenjivanjaGTE != null)
            {
                query = query.Where(x => x.DatumOcjenjivanja >= searchObject.DatumOcjenjivanjaGTE);
            }

            if (searchObject.DatumOcjenjivanjaLTE != null)
            {
                query = query.Where(x => x.DatumOcjenjivanja <= searchObject.DatumOcjenjivanjaLTE);
            }


            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }


            if (searchObject.KnjigaId != null)
            {
                query = query.Where(x => x.KnjigaId == searchObject.KnjigaId);
            }

            return query;
        }

        public override async Task BeforeInsertAsync(OcjenaInsertRequest request, Database.Ocjena entity, CancellationToken cancellationToken = default)
        {
            var postojiOcjena = await Context.Ocjenas
                .AnyAsync(x => x.KorisnikId == request.KorisnikId && x.KnjigaId == request.KnjigaId && !x.IsDeleted, cancellationToken);

            if (postojiOcjena)
            {
                throw new UserException("Već ste ocijenili ovu knjigu.");
            }

            var jeProcitana = await Context.MojaLista
                .AnyAsync(x => x.KorisnikId == request.KorisnikId && x.KnjigaId == request.KnjigaId && x.JeProcitana == true && !x.IsDeleted, cancellationToken);

            if (!jeProcitana)
            {
                throw new UserException("Možete ocijeniti samo knjige koje ste pročitali.");
            }

            entity.IsDeleted = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }


        public async Task<double> GetProsjekOcjenaAsync(int knjigaId, CancellationToken cancellationToken = default)
        {
            var ocjene = await Context.Ocjenas
                .Where(x => x.KnjigaId == knjigaId)
                .ToListAsync(cancellationToken);

            if (ocjene.Count == 0)
            {
                return 0;
            }

            return ocjene.Average(x => x.Vrijednost);
        }

    }
}
