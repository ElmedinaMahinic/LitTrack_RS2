using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace litTrack.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class StavkaNarudzbeController : BaseCRUDControllerAsync<Model.DTOs.StavkaNarudzbeDTO, StavkaNarudzbeSearchObject, StavkaNarudzbeInsertRequest, StavkaNarudzbeUpdateRequest>
    {
        public StavkaNarudzbeController(IStavkaNarudzbeService service)
            : base(service)
        {
        }

        
    }
}
