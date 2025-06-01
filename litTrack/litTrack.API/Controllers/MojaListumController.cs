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
    public class MojaListumController : BaseCRUDControllerAsync<Model.DTOs.MojaListumDTO, MojaListumSearchObject, MojaListumInsertRequest, MojaListumUpdateRequest>
    {
        private readonly IMojaListumService _mojaListumService;
        public MojaListumController(IMojaListumService mojaListumService)
            : base(mojaListumService)
        {
            _mojaListumService = mojaListumService;
        }

        [HttpPut("OznaciKaoProcitanu/{mojaListaId}")]
        public async Task<ActionResult> OznaciKaoProcitanuAsync(int mojaListaId, CancellationToken cancellationToken)
        {
            await _mojaListumService.OznaciKaoProcitanuAsync(mojaListaId, cancellationToken);
            return Ok();
        }

        [HttpGet]
        public override Task<PagedResult<Model.DTOs.MojaListumDTO>> GetList([FromQuery] MojaListumSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        public override Task<Model.DTOs.MojaListumDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [HttpPost]
        public override Task<Model.DTOs.MojaListumDTO> Insert(MojaListumInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public override Task<Model.DTOs.MojaListumDTO> Update(int id, MojaListumUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        [HttpDelete("{id}")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }

    }
}
