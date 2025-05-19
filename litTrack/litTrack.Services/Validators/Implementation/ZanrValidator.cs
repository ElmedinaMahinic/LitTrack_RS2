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
    public class ZanrValidator : BaseValidatorService<Zanr>, IZanrValidator
    {
        private readonly _210078Context _context;

        public ZanrValidator(_210078Context context) : base(context)
        {
            _context = context;
        }

        public async Task ValidateInsertAsync(ZanrInsertRequest zanr, CancellationToken cancellationToken = default)
        {
            bool postoji = await _context.Zanrs
                .AnyAsync(x => x.Naziv == zanr.Naziv && !x.IsDeleted, cancellationToken);

            if (postoji)
                throw new UserException($"Žanr „{zanr.Naziv}“ već postoji!");
        }

        public async Task ValidateUpdateAsync(int id, ZanrUpdateRequest zanr, CancellationToken cancellationToken = default)
        {
            bool postoji = await _context.Zanrs
                .AnyAsync(x => x.ZanrId != id &&
                               x.Naziv == zanr.Naziv &&
                               !x.IsDeleted, cancellationToken);

            if (postoji)
                throw new UserException($"Drugi žanr s nazivom „{zanr.Naziv}“ već postoji!");
        }

        public override void ValidateNoDuplicates(List<int> array)
        {
            if (array == null)
                throw new UserException("Lista žanrova ne smije biti prazna!");

            if (array.Count != array.Distinct().Count())
                throw new UserException("Ne možete unijeti isti žanr više puta!");
        }

    }
}
