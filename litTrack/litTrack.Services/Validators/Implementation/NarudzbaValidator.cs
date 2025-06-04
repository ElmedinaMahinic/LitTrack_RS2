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
    public class NarudzbaValidator : BaseValidatorService<Narudzba>, INarudzbaValidator
    {
        public NarudzbaValidator(_210078Context context) : base(context)
        {
        }

        public Task ValidateInsertAsync(NarudzbaInsertRequest narudzba, CancellationToken cancellationToken = default)
        {
            if (narudzba.StavkeNarudzbe == null || narudzba.StavkeNarudzbe.Count == 0)
                throw new UserException("Narudžba mora sadržavati barem jednu stavku.");


            return Task.CompletedTask;
        }
    }
}
