using litTrack.Model.Exceptions;
using litTrack.Model.Requests;
using litTrack.Services.Database;
using litTrack.Services.Validators.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Implementation
{
    public class UlogaValidator : BaseValidatorService<Uloga>, IUlogaValidator
    {
        private readonly _210078Context context;

        public UlogaValidator(_210078Context context) : base(context)
        {
            this.context = context;
        }

        public async Task ValidateInsertAsync(UlogaInsertRequest uloga, CancellationToken cancellationToken = default)
        {
            bool postoji = await context.Ulogas
                .AnyAsync(x => x.Naziv == uloga.Naziv && !x.IsDeleted, cancellationToken);

            if (postoji)
            {
                throw new UserException($"Uloga sa nazivom '{uloga.Naziv}' već postoji!");
            }
        }

        public async Task ValidateUpdateAsync(int id, UlogaUpdateRequest uloga, CancellationToken cancellationToken = default)
        {
            bool postoji = await context.Ulogas
                .AnyAsync(x => x.UlogaId != id && x.Naziv == uloga.Naziv && !x.IsDeleted, cancellationToken);

            if (postoji)
            {
                throw new UserException($"Druga uloga sa nazivom '{uloga.Naziv}' već postoji!");
            }
        }


        public override void ValidateNoDuplicates(List<int> array)
        {
            if (array == null)
                throw new UserException("Lista uloga ne može biti prazna!");

            if (array.Count != array.Distinct().Count())
                throw new UserException("Ne možete unijeti istu ulogu više puta!");
        }
    }
}
