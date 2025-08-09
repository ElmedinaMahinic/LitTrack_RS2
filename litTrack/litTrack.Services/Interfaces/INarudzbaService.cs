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
    public interface INarudzbaService : ICRUDServiceAsync<NarudzbaDTO, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
    {
        Task<NarudzbaDTO> PreuzmiAsync(int narudzbaId, CancellationToken cancellationToken = default);

        Task<NarudzbaDTO> UTokuAsync(int narudzbaId, CancellationToken cancellationToken = default);

        Task<NarudzbaDTO> ZavrsiAsync(int narudzbaId, CancellationToken cancellationToken = default);

        Task<NarudzbaDTO> PonistiAsync(int narudzbaId, CancellationToken cancellationToken = default);

        Task<List<string>> AllowedActionsAsync(int narudzbaId, CancellationToken cancellationToken = default);

        Task<int[]> GetBrojNarudzbiPoMjesecimaAsync(string? stateFilter = null, CancellationToken cancellationToken = default);

    }
}
