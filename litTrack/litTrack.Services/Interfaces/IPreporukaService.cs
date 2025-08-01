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
    public interface IPreporukaService : ICRUDServiceAsync<PreporukaDTO, PreporukaSearchObject, PreporukaInsertRequest, PreporukaUpdateRequest>
    {
        Task<int> GetBrojPreporukaAsync(int knjigaId, CancellationToken cancellationToken = default);
    }
}
