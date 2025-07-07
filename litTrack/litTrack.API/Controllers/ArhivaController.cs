using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace litTrack.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ArhivaController : BaseCRUDControllerAsync<Model.DTOs.ArhivaDTO, ArhivaSearchObject, ArhivaInsertRequest, ArhivaUpdateRequest>
    {
        private readonly IArhivaService _arhivaService;
        public ArhivaController(IArhivaService arhivaService)
            : base(arhivaService)
        {
            _arhivaService = arhivaService;
        }

        [Authorize]
        [HttpGet("BrojArhiviranja/{knjigaId}")]
        public async Task<ActionResult<int>> GetBrojArhiviranja(int knjigaId, CancellationToken cancellationToken)
        {
            var brojArhiviranja = await _arhivaService.GetBrojArhiviranjaAsync(knjigaId, cancellationToken);
            return Ok(brojArhiviranja);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpGet]
        public override Task<PagedResult<Model.DTOs.ArhivaDTO>> GetList([FromQuery] ArhivaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpGet("{id}")]
        public override Task<Model.DTOs.ArhivaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPost]
        public override Task<Model.DTOs.ArhivaDTO> Insert(ArhivaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPut("{id}")]
        public override Task<Model.DTOs.ArhivaDTO> Update(int id, ArhivaUpdateRequest request, CancellationToken cancellationToken = default)
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
