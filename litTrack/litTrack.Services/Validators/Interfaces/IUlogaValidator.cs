using litTrack.Model.Requests;
using litTrack.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Interfaces
{
    public interface IUlogaValidator : IBaseValidatorService<Uloga>
    {
        Task ValidateInsertAsync(UlogaInsertRequest uloga, CancellationToken cancellationToken = default);
        Task ValidateUpdateAsync(int id, UlogaUpdateRequest uloga, CancellationToken cancellationToken = default);
    }
}
