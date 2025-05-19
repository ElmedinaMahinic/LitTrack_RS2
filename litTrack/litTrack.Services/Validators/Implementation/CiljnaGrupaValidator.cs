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
    public class CiljnaGrupaValidator : BaseValidatorService<CiljnaGrupa>, ICiljnaGrupaValidator
    {
        private readonly _210078Context context;

        public CiljnaGrupaValidator(_210078Context context) : base(context)
        {
            this.context = context;
        }

        public async Task ValidateInsertAsync(CiljnaGrupaInsertRequest ciljnaGrupa, CancellationToken cancellationToken = default)
        {
            bool postoji = await context.CiljnaGrupas
                .AnyAsync(x => x.Naziv == ciljnaGrupa.Naziv && !x.IsDeleted, cancellationToken);

            if (postoji)
            {
                throw new UserException($"Ciljna grupa '{ciljnaGrupa.Naziv}' već postoji!");
            }
        }

        public async Task ValidateUpdateAsync(int id, CiljnaGrupaUpdateRequest ciljnaGrupa, CancellationToken cancellationToken = default)
        {
            bool postoji = await context.CiljnaGrupas
                .AnyAsync(x => x.CiljnaGrupaId != id && x.Naziv == ciljnaGrupa.Naziv && !x.IsDeleted, cancellationToken);

            if (postoji)
            {
                throw new UserException($"Druga ciljna grupa sa nazivom '{ciljnaGrupa.Naziv}' već postoji!");
            }
        }


        public override void ValidateNoDuplicates(List<int> array)
        {
            if (array == null)
                throw new UserException("Lista ciljnih grupa ne smije biti prazna!");

            if (array.Count != array.Distinct().Count())
                throw new UserException("Ne možete unijeti istu ciljnu grupu više puta!");
        }
    }
}
