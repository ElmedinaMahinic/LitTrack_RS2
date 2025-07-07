using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.DTOs;
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
    public class OcjenaController : BaseCRUDControllerAsync<Model.DTOs.OcjenaDTO, OcjenaSearchObject, OcjenaInsertRequest, OcjenaUpdateRequest>
    {
        private readonly IOcjenaService _ocjenaService;

        public OcjenaController(IOcjenaService ocjenaService) : base(ocjenaService)
        {
            _ocjenaService = ocjenaService;
        }

        [AllowAnonymous]
        [HttpGet("Prosjek/{knjigaId}")]
        public async Task<ActionResult<double>> GetProsjekOcjena(int knjigaId, CancellationToken cancellationToken)
        {
            var prosjek = await _ocjenaService.GetProsjekOcjenaAsync(knjigaId, cancellationToken);
            return Ok(prosjek);
        }

        [AllowAnonymous]
        [HttpGet]
        public override Task<PagedResult<OcjenaDTO>> GetList([FromQuery] OcjenaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        [HttpGet("{id}")]
        public override Task<OcjenaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPost]
        public override Task<OcjenaDTO> Insert(OcjenaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPut("{id}")]
        public override Task<OcjenaDTO> Update(int id, OcjenaUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpDelete("{id}")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }
    }
}
