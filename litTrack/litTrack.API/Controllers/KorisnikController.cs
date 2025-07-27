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
    public class KorisnikController : BaseCRUDControllerAsync<Model.DTOs.KorisnikDTO, KorisnikSearchObject, KorisnikInsertRequest, KorisnikUpdateRequest>
    {
        private readonly IKorisnikService _korisnikService;

        public KorisnikController(IKorisnikService korisnikService) : base(korisnikService)
        {
            _korisnikService = korisnikService;
        }

        [Authorize]  
        [HttpPut("Aktiviraj/{korisnikId}")]
        public async Task<ActionResult> AktivirajAsync(int korisnikId, CancellationToken cancellationToken)
        {
            await _korisnikService.AktivirajAsync(korisnikId, cancellationToken);
            return Ok();
        }

        [Authorize] 
        [HttpPut("Deaktiviraj/{korisnikId}")]
        public async Task<ActionResult> DeaktivirajAsync(int korisnikId, CancellationToken cancellationToken)
        {
            await _korisnikService.DeaktivirajAsync(korisnikId, cancellationToken);
            return Ok();
        }


        [AllowAnonymous]
        [HttpPost("login")]
        public async Task<ActionResult<KorisnikDTO>> Login([FromBody] KorisnikLoginRequest request, CancellationToken cancellationToken)
        {
            var dto = await _korisnikService.LoginAsync(request, cancellationToken);
            return Ok(dto);
        }

        [Authorize]
        [HttpGet("info")]
        public async Task<ActionResult<KorisnikDTO>> GetInfo(CancellationToken cancellationToken = default)
        {
            var dto = await _korisnikService.GetInfoAsync(cancellationToken);
            return Ok(dto);
        }

        [Authorize]
        [HttpGet]
        public override Task<PagedResult<KorisnikDTO>> GetList([FromQuery] KorisnikSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [Authorize]
        [HttpGet("{id}")]
        public override Task<KorisnikDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [AllowAnonymous]
        [HttpPost]
        public override Task<KorisnikDTO> Insert(KorisnikInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize]
        [HttpPut("{id}")]
        public override Task<KorisnikDTO> Update(int id, KorisnikUpdateRequest request, CancellationToken cancellationToken = default)
        {
            return base.Update(id, request, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpDelete("{id}")]
        public override Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return base.Delete(id, cancellationToken);
        }
    }
}
