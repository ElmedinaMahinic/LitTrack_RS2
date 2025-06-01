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
    public interface ILicnaPreporukaService : ICRUDServiceAsync<LicnaPreporukaDTO, LicnaPreporukaSearchObject, LicnaPreporukaInsertRequest, LicnaPreporukaUpdateRequest>
    {
        Task OznaciKaoPogledanuAsync(int licnaPreporukaId, CancellationToken cancellationToken = default);
    }
}
