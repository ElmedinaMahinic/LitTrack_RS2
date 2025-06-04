using litTrack.Model.Exceptions;
using litTrack.Model.Requests;
using litTrack.Services.Database;
using litTrack.Services.Validators.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Implementation
{
    public class StavkaNarudzbeValidator : BaseValidatorService<StavkaNarudzbe>, IStavkaNarudzbeValidator
    {
        public StavkaNarudzbeValidator(_210078Context context) : base(context)
        {
        }

        public Task ValidateInsertAsync(StavkaNarudzbeInsertRequest stavkaNarudzbe, CancellationToken cancellationToken = default)
        {

            if (stavkaNarudzbe.Kolicina <= 0)
                throw new UserException("Količina mora biti veća od 0.");

            return Task.CompletedTask;
        }
    }
}
