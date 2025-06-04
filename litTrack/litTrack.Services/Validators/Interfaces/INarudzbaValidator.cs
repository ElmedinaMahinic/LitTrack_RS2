using litTrack.Model.Requests;
using litTrack.Services.Database;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Interfaces
{
    public interface INarudzbaValidator : IBaseValidatorService<Narudzba>
    {
        Task ValidateInsertAsync(NarudzbaInsertRequest narudzba, CancellationToken cancellationToken = default);
    }
}
