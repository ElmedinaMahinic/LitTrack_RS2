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
    public class PreporukaController : BaseCRUDControllerAsync<Model.DTOs.PreporukaDTO, PreporukaSearchObject, PreporukaInsertRequest, PreporukaUpdateRequest>
    {
        private readonly IPreporukaService _preporukaService;

        public PreporukaController(IPreporukaService preporukaService) : base(preporukaService)
        {
            _preporukaService = preporukaService;
        }

        [Authorize]
        [HttpGet("BrojPreporuka/{knjigaId}")]
        public async Task<ActionResult<int>> GetBrojPreporuka(int knjigaId, CancellationToken cancellationToken)
        {
            var brojPreporuka = await _preporukaService.GetBrojPreporukaAsync(knjigaId, cancellationToken);
            return Ok(brojPreporuka);
        }

        [Authorize]
        [HttpGet]
        public override Task<PagedResult<PreporukaDTO>> GetList([FromQuery] PreporukaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpGet("{id}")]
        public override Task<PreporukaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPost]
        public override Task<PreporukaDTO> Insert(PreporukaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPut("{id}")]
        public override Task<PreporukaDTO> Update(int id, PreporukaUpdateRequest request, CancellationToken cancellationToken = default)
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
