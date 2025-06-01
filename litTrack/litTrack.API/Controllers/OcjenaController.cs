using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.DTOs;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace litTrack.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class OcjenaController : BaseCRUDControllerAsync<Model.DTOs.OcjenaDTO, OcjenaSearchObject, OcjenaInsertRequest, OcjenaUpdateRequest>
    {
        private readonly IOcjenaService _ocjenaService;

        public OcjenaController(IOcjenaService ocjenaService) : base(ocjenaService)
        {
            _ocjenaService = ocjenaService;
        }

        [HttpGet("Prosjek/{knjigaId}")]
        public async Task<ActionResult<double>> GetProsjekOcjena(int knjigaId, CancellationToken cancellationToken)
        {
            var prosjek = await _ocjenaService.GetProsjekOcjenaAsync(knjigaId, cancellationToken);
            return Ok(prosjek);
        }


        [HttpGet]
        public override Task<PagedResult<OcjenaDTO>> GetList([FromQuery] OcjenaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        public override Task<OcjenaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [HttpPost]
        public override Task<OcjenaDTO> Insert(OcjenaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public override Task<OcjenaDTO> Update(int id, OcjenaUpdateRequest request, CancellationToken cancellationToken = default)
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
