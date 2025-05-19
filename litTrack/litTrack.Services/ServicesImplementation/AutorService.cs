using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Interfaces;
using litTrack.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using litTrack.Services.Validators.Interfaces;
using litTrack.Model.Exceptions;
using Microsoft.EntityFrameworkCore;

namespace litTrack.Services.ServicesImplementation
{
    public class AutorService : BaseCRUDServiceAsync<Model.DTOs.AutorDTO, AutorSearchObject, Database.Autor, AutorInsertRequest, AutorUpdateRequest>, IAutorService
    {
        private readonly IAutorValidator _validator;
        public AutorService(_210078Context context, IMapper mapper, IAutorValidator validator)
            : base(context, mapper)
        {
            _validator = validator;
        }

        public override IQueryable<Autor> AddFilter(AutorSearchObject searchObject, IQueryable<Database.Autor> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.ImePrezime))
            {
                string imePrezime = searchObject.ImePrezime.ToLower();

                query = query.Where(x =>
                    (x.Ime + " " + x.Prezime).ToLower().Contains(imePrezime) ||
                    x.Ime.ToLower().Contains(imePrezime) ||
                    x.Prezime.ToLower().Contains(imePrezime));
            }

            return query;
        }

        public override async Task BeforeInsertAsync(AutorInsertRequest request, Autor entity, CancellationToken cancellationToken = default)
        {
            await _validator.ValidateInsertAsync(request, cancellationToken);

            entity.IsDeleted = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(AutorUpdateRequest request, Autor entity, CancellationToken cancellationToken = default)
        {
            await _validator.ValidateEntityExistsAsync(entity.AutorId, cancellationToken);
            await _validator.ValidateUpdateAsync(entity.AutorId, request, cancellationToken);

            await base.BeforeUpdateAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeDeleteAsync(Autor entity, CancellationToken cancellationToken = default)
        {
            var uUpotrebi = await Context.Knjigas
                .AnyAsync(x => x.AutorId == entity.AutorId && !x.IsDeleted, cancellationToken);

            if (uUpotrebi)
            {
                throw new UserException("Ovaj autor je u upotrebi i ne može biti obrisan.");
            }

            await base.BeforeDeleteAsync(entity, cancellationToken);
        }
    }
}
