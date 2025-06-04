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
    public class NarudzbaController : BaseCRUDControllerAsync<Model.DTOs.NarudzbaDTO, NarudzbaSearchObject, NarudzbaInsertRequest, NarudzbaUpdateRequest>
    {
        private readonly INarudzbaService _narudzbaService;
        public NarudzbaController(INarudzbaService narudzbaService)
            : base(narudzbaService)
        {
            _narudzbaService= narudzbaService;
        }

        [HttpPut("{narudzbaId}/preuzmi")]
        public async Task<Model.DTOs.NarudzbaDTO> Preuzmi(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return await _narudzbaService.PreuzmiAsync(narudzbaId, cancellationToken);
        }

        [HttpPut("{narudzbaId}/uToku")]
        public async Task<Model.DTOs.NarudzbaDTO> UToku(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return await _narudzbaService.UTokuAsync(narudzbaId, cancellationToken);
        }

        [HttpPut("{narudzbaId}/ponisti")]
        public async Task<Model.DTOs.NarudzbaDTO> Ponisti(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return await _narudzbaService.PonistiAsync(narudzbaId, cancellationToken);
        }

        [HttpPut("{narudzbaId}/zavrsi")]
        public async Task<Model.DTOs.NarudzbaDTO> Zavrsi(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return await _narudzbaService.ZavrsiAsync(narudzbaId, cancellationToken);
        }

        [HttpGet("{narudzbaId}/allowedActions")]
        public Task<List<string>> AllowedActions(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return _narudzbaService.AllowedActionsAsync(narudzbaId, cancellationToken);
        }


        [HttpGet]
        public override Task<PagedResult<Model.DTOs.NarudzbaDTO>> GetList([FromQuery] NarudzbaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        public override Task<Model.DTOs.NarudzbaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [HttpPost]
        public override Task<Model.DTOs.NarudzbaDTO> Insert(NarudzbaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public override Task<Model.DTOs.NarudzbaDTO> Update(int id, NarudzbaUpdateRequest request, CancellationToken cancellationToken = default)
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
