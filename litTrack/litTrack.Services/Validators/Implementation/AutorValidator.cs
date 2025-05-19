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
    public class AutorValidator : BaseValidatorService<Autor>, IAutorValidator
    {
        private readonly _210078Context context;

        public AutorValidator(_210078Context context) : base(context)
        {
            this.context = context;
        }

        public async Task ValidateInsertAsync(AutorInsertRequest autor, CancellationToken cancellationToken = default)
        {
            bool postoji = await context.Autors
                .AnyAsync(x => x.Ime == autor.Ime && x.Prezime == autor.Prezime && !x.IsDeleted, cancellationToken);

            if (postoji)
            {
                throw new UserException($"Autor {autor.Ime} {autor.Prezime} već postoji!");
            }
        }

        public async Task ValidateUpdateAsync(int id, AutorUpdateRequest autor, CancellationToken cancellationToken = default)
        {
            bool postoji = await context.Autors
                .AnyAsync(x => x.AutorId != id &&
                               x.Ime == autor.Ime &&
                               x.Prezime == autor.Prezime &&
                               !x.IsDeleted, cancellationToken);

            if (postoji)
            {
                throw new UserException($"Drugi autor sa imenom {autor.Ime} {autor.Prezime} već postoji!");
            }
        }

    }
}
