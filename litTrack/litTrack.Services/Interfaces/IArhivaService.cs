﻿using litTrack.Model.DTOs;
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
    public interface IArhivaService : ICRUDServiceAsync<ArhivaDTO, ArhivaSearchObject, ArhivaInsertRequest, ArhivaUpdateRequest>
    {
        Task<int> GetBrojArhiviranjaAsync(int knjigaId, CancellationToken cancellationToken = default);
    }
}
