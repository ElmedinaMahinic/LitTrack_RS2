using litTrack.Model.Requests;
using litTrack.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Interfaces
{
    public interface ICiljnaGrupaValidator : IBaseValidatorService<CiljnaGrupa>
    {
        Task ValidateInsertAsync(CiljnaGrupaInsertRequest ciljnaGrupa, CancellationToken cancellationToken = default);
        Task ValidateUpdateAsync(int id, CiljnaGrupaUpdateRequest ciljnaGrupa, CancellationToken cancellationToken = default);
    }
}
