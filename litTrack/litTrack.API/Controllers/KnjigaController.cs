using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.DTOs;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Interfaces;
using litTrack.Services.ServicesImplementation;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace litTrack.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class KnjigaController : BaseCRUDControllerAsync<Model.DTOs.KnjigaDTO, KnjigaSearchObject, KnjigaInsertRequest, KnjigaUpdateRequest>
    {
        private readonly IKnjigaService _knjigaService;
        public KnjigaController(IKnjigaService service)
        : base(service)
        {
            _knjigaService = service;
        }

        [AllowAnonymous]
        [HttpGet("{knjigaId}/recommended")]
        public async Task<List<KnjigaDTO>> Recommend(int knjigaId)
        {
            return await _knjigaService.Recommend(knjigaId);
        }

        [AllowAnonymous]
        [HttpGet("traindata")]
        public async Task TrainData()
        {
            await _knjigaService.TrainData();
        }

        [AllowAnonymous]
        [HttpGet]
        public override Task<PagedResult<Model.DTOs.KnjigaDTO>> GetList([FromQuery] KnjigaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        [HttpGet("{id}")]
        public override Task<Model.DTOs.KnjigaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public override Task<Model.DTOs.KnjigaDTO> Insert(KnjigaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public override Task<Model.DTOs.KnjigaDTO> Update(int id, KnjigaUpdateRequest request, CancellationToken cancellationToken = default)
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
