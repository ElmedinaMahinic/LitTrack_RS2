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
    public class ZanrService : BaseCRUDServiceAsync<Model.DTOs.ZanrDTO, ZanrSearchObject, Database.Zanr, ZanrInsertRequest, ZanrUpdateRequest>, IZanrService
    {
        private readonly IZanrValidator _validator;
        public ZanrService(_210078Context context, IMapper mapper, IZanrValidator validator)
            : base(context, mapper)
        {
            _validator = validator;
        }

        public override IQueryable<Zanr> AddFilter(ZanrSearchObject searchObject, IQueryable<Zanr> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.Naziv))
            {
                query = query.Where(x => x.Naziv.ToLower().Contains(searchObject.Naziv.ToLower()));
            }

            return query;
        }

        public override async Task BeforeInsertAsync(ZanrInsertRequest request, Zanr entity, CancellationToken cancellationToken = default)
        {
            await _validator.ValidateInsertAsync(request, cancellationToken);

            entity.IsDeleted = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(ZanrUpdateRequest request, Zanr entity, CancellationToken cancellationToken = default)
        {
            await _validator.ValidateEntityExistsAsync(entity.ZanrId, cancellationToken);
            await _validator.ValidateUpdateAsync(entity.ZanrId, request, cancellationToken);

            await base.BeforeUpdateAsync(request, entity, cancellationToken);

        }

        public override async Task BeforeDeleteAsync(Zanr entity, CancellationToken cancellationToken = default)
        {
            var uUpotrebi = await Context.KnjigaZanrs
                .AnyAsync(x => x.ZanrId == entity.ZanrId && !x.IsDeleted, cancellationToken);

            if (uUpotrebi)
            {
                throw new UserException("Ovaj žanr je u upotrebi i ne može biti obrisan.");
            }

            await base.BeforeDeleteAsync(entity, cancellationToken);
        }

    }
}
