using litTrack.Model.DTOs;
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
    public class CiljnaGrupaService : BaseCRUDServiceAsync<CiljnaGrupaDTO, CiljnaGrupaSearchObject, CiljnaGrupa, CiljnaGrupaInsertRequest, CiljnaGrupaUpdateRequest>, ICiljnaGrupaService
    {
        private readonly ICiljnaGrupaValidator _validator;
        public CiljnaGrupaService(_210078Context context, IMapper mapper, ICiljnaGrupaValidator validator)
            : base(context, mapper)
        {
            _validator = validator;
        }

        public override IQueryable<CiljnaGrupa> AddFilter(CiljnaGrupaSearchObject searchObject, IQueryable<CiljnaGrupa> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.Naziv))
            {
                query = query.Where(x => x.Naziv.ToLower().Contains(searchObject.Naziv.ToLower()));
            }

            return query;
        }

        public override async Task BeforeInsertAsync(CiljnaGrupaInsertRequest request, CiljnaGrupa entity, CancellationToken cancellationToken = default)
        {
            await _validator.ValidateInsertAsync(request, cancellationToken);

            entity.IsDeleted = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(CiljnaGrupaUpdateRequest request, CiljnaGrupa entity, CancellationToken cancellationToken = default)
        {
            await _validator.ValidateEntityExistsAsync(entity.CiljnaGrupaId, cancellationToken);
            await _validator.ValidateUpdateAsync(entity.CiljnaGrupaId, request, cancellationToken);

            await base.BeforeUpdateAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeDeleteAsync(CiljnaGrupa entity, CancellationToken cancellationToken = default)
        {
            var uUpotrebi = await Context.KnjigaCiljnaGrupas
                .AnyAsync(x => x.CiljnaGrupaId == entity.CiljnaGrupaId && !x.IsDeleted, cancellationToken);

            if (uUpotrebi)
            {
                throw new UserException("Ciljna grupa je u upotrebi i ne može biti obrisana.");
            }

            await base.BeforeDeleteAsync(entity, cancellationToken);
        }


    }
}
