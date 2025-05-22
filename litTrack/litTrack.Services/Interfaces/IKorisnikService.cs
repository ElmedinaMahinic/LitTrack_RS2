using litTrack.Model.DTOs;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Interfaces
{
    public interface IKorisnikService : ICRUDServiceAsync<KorisnikDTO, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {
        Task<KorisnikDTO> LoginAsync(KorisnikLoginRequest request, CancellationToken cancellationToken = default);

    }
}
