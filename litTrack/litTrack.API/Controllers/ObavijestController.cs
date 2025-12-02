using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace litTrack.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ObavijestController : BaseCRUDControllerAsync<Model.DTOs.ObavijestDTO, ObavijestSearchObject, ObavijestInsertRequest, ObavijestUpdateRequest>
    {
        private readonly IObavijestService _obavijestService;
        public ObavijestController(IObavijestService obavijestService)
            : base(obavijestService)
        {
            _obavijestService = obavijestService;
        }

        [Authorize]
        [HttpPut("OznaciKaoProcitanu/{obavijestId}")]
        public async Task<ActionResult> OznaciKaoProcitanuAsync(int obavijestId, CancellationToken cancellationToken)
        {
            await _obavijestService.OznaciKaoProcitanuAsync(obavijestId, cancellationToken);
            return Ok();
        }

        [Authorize]
        [HttpGet]
        public override Task<PagedResult<Model.DTOs.ObavijestDTO>> GetList([FromQuery] ObavijestSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [Authorize]
        [HttpGet("{id}")]
        public override Task<Model.DTOs.ObavijestDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public override Task<Model.DTOs.ObavijestDTO> Insert(ObavijestInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public override Task<Model.DTOs.ObavijestDTO> Update(int id, ObavijestUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        [Authorize]
        [HttpDelete("{id}")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }

    }
}
