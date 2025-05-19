using litTrack.Model.Requests;
using litTrack.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Interfaces
{
    public interface IAutorValidator : IBaseValidatorService<Autor>
    {
        Task ValidateInsertAsync(AutorInsertRequest autor, CancellationToken cancellationToken = default);
        Task ValidateUpdateAsync(int id, AutorUpdateRequest autor, CancellationToken cancellationToken = default);
    }
}
