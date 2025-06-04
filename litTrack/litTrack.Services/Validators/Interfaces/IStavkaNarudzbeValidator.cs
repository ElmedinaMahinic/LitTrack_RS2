using litTrack.Model.Requests;
using litTrack.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Interfaces
{
    public interface IStavkaNarudzbeValidator : IBaseValidatorService<StavkaNarudzbe>
    {
        Task ValidateInsertAsync(StavkaNarudzbeInsertRequest stavkaNarudzbe, CancellationToken cancellationToken = default);
    }
}
