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
    public class RecenzijaOdgovorController : BaseCRUDControllerAsync<Model.DTOs.RecenzijaOdgovorDTO, RecenzijaOdgovorSearchObject, RecenzijaOdgovorInsertRequest, RecenzijaOdgovorUpdateRequest>
    {
        private readonly IRecenzijaOdgovorService _recenzijaOdgovorService;

        public RecenzijaOdgovorController(IRecenzijaOdgovorService recenzijaOdgovorService) : base(recenzijaOdgovorService)
        {
            _recenzijaOdgovorService = recenzijaOdgovorService;
        }

        [HttpPut("ToggleLike/{recenzijaOdgovorId}/{korisnikId}")]
        public async Task<ActionResult> ToggleLikeAsync(int recenzijaOdgovorId, int korisnikId, CancellationToken cancellationToken = default)
        {
            await _recenzijaOdgovorService.ToggleLikeAsync(recenzijaOdgovorId, korisnikId, cancellationToken);
            return Ok();
        }

        [HttpPut("ToggleDislike/{recenzijaOdgovorId}/{korisnikId}")]
        public async Task<ActionResult> ToggleDislikeAsync(int recenzijaOdgovorId, int korisnikId, CancellationToken cancellationToken = default)
        {
            await _recenzijaOdgovorService.ToggleDislikeAsync(recenzijaOdgovorId, korisnikId, cancellationToken);
            return Ok();
        }

        [HttpGet]
        public override Task<PagedResult<Model.DTOs.RecenzijaOdgovorDTO>> GetList([FromQuery] RecenzijaOdgovorSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        public override Task<Model.DTOs.RecenzijaOdgovorDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [HttpPost]
        public override Task<Model.DTOs.RecenzijaOdgovorDTO> Insert(RecenzijaOdgovorInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public override Task<Model.DTOs.RecenzijaOdgovorDTO> Update(int id, RecenzijaOdgovorUpdateRequest request, CancellationToken cancellationToken = default)
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
