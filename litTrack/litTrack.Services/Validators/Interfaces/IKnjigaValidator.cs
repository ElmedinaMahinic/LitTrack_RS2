using litTrack.Model.Requests;
using litTrack.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Interfaces
{
    public interface IKnjigaValidator : IBaseValidatorService<Knjiga>
    {
        Task ValidateInsertAsync(KnjigaInsertRequest knjiga, CancellationToken cancellationToken = default);
        Task ValidateUpdateAsync(int id, KnjigaUpdateRequest knjiga, CancellationToken cancallationToken = default);
    }
}
