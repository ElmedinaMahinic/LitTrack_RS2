using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.Helpers;
using litTrack.Model.SearchObjects;
using litTrack.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace litTrack.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class NacinPlacanjaController : BaseControllerAsync<Model.DTOs.NacinPlacanjaDTO, NacinPlacanjaSearchObject>
    {
        public NacinPlacanjaController(INacinPlacanjaService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        [HttpGet]
        public override Task<PagedResult<Model.DTOs.NacinPlacanjaDTO>> GetList([FromQuery] NacinPlacanjaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        [HttpGet("{id}")]
        public override Task<Model.DTOs.NacinPlacanjaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }
    }
}
