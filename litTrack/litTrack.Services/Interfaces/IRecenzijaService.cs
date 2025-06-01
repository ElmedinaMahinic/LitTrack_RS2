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
    public interface IRecenzijaService : ICRUDServiceAsync<RecenzijaDTO, RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>
    {
        Task ToggleLikeAsync(int recenzijaId, int korisnikId, CancellationToken cancellationToken = default);
        Task ToggleDislikeAsync(int recenzijaId, int korisnikId, CancellationToken cancellationToken = default);
    }
}
