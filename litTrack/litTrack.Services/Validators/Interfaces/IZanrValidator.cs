using litTrack.Model.Requests;
using litTrack.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Interfaces
{
    public interface IZanrValidator : IBaseValidatorService<Zanr>
    {
        Task ValidateInsertAsync(ZanrInsertRequest zanr, CancellationToken cancellationToken = default);
        Task ValidateUpdateAsync(int id, ZanrUpdateRequest zanr, CancellationToken cancellationToken = default);
    }
}
