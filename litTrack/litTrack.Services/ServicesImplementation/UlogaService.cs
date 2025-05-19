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
    public class UlogaService : BaseCRUDServiceAsync<Model.DTOs.UlogaDTO, UlogaSearchObject, Database.Uloga, UlogaInsertRequest, UlogaUpdateRequest>, IUlogaService
    {
        private readonly IUlogaValidator _validator;

        private static readonly HashSet<string> _systemRoles =
           new(StringComparer.OrdinalIgnoreCase) { "Admin", "Korisnik", "Radnik" };
        public UlogaService(_210078Context context, IMapper mapper, IUlogaValidator validator)
            : base(context, mapper)
        {
            _validator = validator;
        }

        public override IQueryable<Uloga> AddFilter(UlogaSearchObject searchObject, IQueryable<Uloga> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.Naziv))
            {
                query = query.Where(x => x.Naziv.ToLower().Contains(searchObject.Naziv.ToLower()));
            }

            return query;
        }

        public override async Task BeforeInsertAsync(UlogaInsertRequest request, Uloga entity, CancellationToken cancellationToken = default)
        {
            await _validator.ValidateInsertAsync(request, cancellationToken);

            entity.IsDeleted = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task BeforeUpdateAsync(UlogaUpdateRequest request, Uloga entity, CancellationToken cancellationToken = default)
        {
            await _validator.ValidateEntityExistsAsync(entity.UlogaId, cancellationToken);
            await _validator.ValidateUpdateAsync(entity.UlogaId, request, cancellationToken);

            await base.BeforeUpdateAsync(request, entity, cancellationToken);

        }

        public override async Task BeforeDeleteAsync(Uloga entity, CancellationToken cancellationToken = default)
        {
            if (_systemRoles.Contains(entity.Naziv))
                throw new UserException("Sistemsku ulogu (Admin, Korisnik, Radnik) nije dozvoljeno brisati.");

            bool uUpotrebi = await Context.KorisnikUlogas
                .AnyAsync(x => x.UlogaId == entity.UlogaId && !x.IsDeleted, cancellationToken);

            if (uUpotrebi)
            {
                throw new UserException("Ova uloga je u upotrebi i ne može biti obrisana.");
            }

            await base.BeforeDeleteAsync(entity, cancellationToken);
        }

    }
}
