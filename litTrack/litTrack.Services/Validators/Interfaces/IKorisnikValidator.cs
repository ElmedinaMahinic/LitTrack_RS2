using litTrack.Model.Requests;
using litTrack.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Interfaces
{
    public interface IKorisnikValidator : IBaseValidatorService<Korisnik>
    {
        Task ValidateInsertAsync(KorisnikInsertRequest korisnik, CancellationToken cancellationToken = default);
        Task ValidateUpdateAsync(int id, KorisnikUpdateRequest korisnik, CancellationToken cancellationToken = default);
    }
}
