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
    public class LicnaPreporukaValidator : BaseValidatorService<LicnaPreporuka>, ILicnaPreporukaValidator
    {

        public LicnaPreporukaValidator(_210078Context context) : base(context)
        {
        }


        public Task ValidateInsertAsync(LicnaPreporukaInsertRequest licnaPreporuka, CancellationToken cancellationToken = default)
        {
            if (licnaPreporuka.Knjige == null || licnaPreporuka.Knjige.Count == 0)
                throw new UserException("Potrebno je odabrati barem jednu knjigu.");

            if (licnaPreporuka.KorisnikPosiljalacId == licnaPreporuka.KorisnikPrimalacId)
                throw new UserException("Pošiljalac i primalac ne mogu biti isti korisnik.");

            return Task.CompletedTask;
        }


    }
}
