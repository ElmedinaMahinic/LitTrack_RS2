using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesInterfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Interfaces
{
    public interface INacinPlacanjaService : IServiceAsync<Model.DTOs.NacinPlacanjaDTO, NacinPlacanjaSearchObject>
    {
    }
}
