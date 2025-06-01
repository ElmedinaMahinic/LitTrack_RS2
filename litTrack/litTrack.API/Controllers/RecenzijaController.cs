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
    public class RecenzijaController : BaseCRUDControllerAsync<Model.DTOs.RecenzijaDTO, RecenzijaSearchObject, RecenzijaInsertRequest, RecenzijaUpdateRequest>
    {
        private readonly IRecenzijaService _recenzijaService;

        public RecenzijaController(IRecenzijaService recenzijaService) : base(recenzijaService)
        {
            _recenzijaService = recenzijaService;
        }

        [HttpPut("ToggleLike/{recenzijaId}/{korisnikId}")]
        public async Task<ActionResult> ToggleLikeAsync(int recenzijaId, int korisnikId, CancellationToken cancellationToken = default)
        {
            await _recenzijaService.ToggleLikeAsync(recenzijaId, korisnikId, cancellationToken);
            return Ok();
        }

        [HttpPut("ToggleDislike/{recenzijaId}/{korisnikId}")]
        public async Task<ActionResult> ToggleDislikeAsync(int recenzijaId, int korisnikId, CancellationToken cancellationToken = default)
        {
            await _recenzijaService.ToggleDislikeAsync(recenzijaId, korisnikId, cancellationToken);
            return Ok();
        }

        [HttpGet]
        public override Task<PagedResult<Model.DTOs.RecenzijaDTO>> GetList([FromQuery] RecenzijaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        public override Task<Model.DTOs.RecenzijaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [HttpPost]
        public override Task<Model.DTOs.RecenzijaDTO> Insert(RecenzijaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public override Task<Model.DTOs.RecenzijaDTO> Update(int id, RecenzijaUpdateRequest request, CancellationToken cancellationToken = default)
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
