using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Interfaces;
using litTrack.Services.ServicesImplementation;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

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

        [Authorize]
        [HttpGet("BrojNarudzbiPoMjesecima")]
        public async Task<ActionResult<int[]>> GetBrojNarudzbiPoMjesecima([FromQuery] string? stateFilter = null, CancellationToken cancellationToken = default)
        {
            var brojNarudzbi = await _narudzbaService.GetBrojNarudzbiPoMjesecimaAsync(stateFilter, cancellationToken);
            return Ok(brojNarudzbi);
        }


        [Authorize(Roles = "Radnik")]
        [HttpPut("{narudzbaId}/preuzmi")]
        public async Task<Model.DTOs.NarudzbaDTO> Preuzmi(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return await _narudzbaService.PreuzmiAsync(narudzbaId, cancellationToken);
        }

        [Authorize(Roles = "Radnik")]
        [HttpPut("{narudzbaId}/uToku")]
        public async Task<Model.DTOs.NarudzbaDTO> UToku(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return await _narudzbaService.UTokuAsync(narudzbaId, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPut("{narudzbaId}/ponisti")]
        public async Task<Model.DTOs.NarudzbaDTO> Ponisti(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return await _narudzbaService.PonistiAsync(narudzbaId, cancellationToken);
        }

        [Authorize(Roles = "Radnik")]
        [HttpPut("{narudzbaId}/zavrsi")]
        public async Task<Model.DTOs.NarudzbaDTO> Zavrsi(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return await _narudzbaService.ZavrsiAsync(narudzbaId, cancellationToken);
        }

        [Authorize]
        [HttpGet("{narudzbaId}/allowedActions")]
        public Task<List<string>> AllowedActions(int narudzbaId, CancellationToken cancellationToken = default)
        {
            return _narudzbaService.AllowedActionsAsync(narudzbaId, cancellationToken);
        }

        [Authorize]
        [HttpGet]
        public override Task<PagedResult<Model.DTOs.NarudzbaDTO>> GetList([FromQuery] NarudzbaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [Authorize]
        [HttpGet("{id}")]
        public override Task<Model.DTOs.NarudzbaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPost]
        public override Task<Model.DTOs.NarudzbaDTO> Insert(NarudzbaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPut("{id}")]
        public override Task<Model.DTOs.NarudzbaDTO> Update(int id, NarudzbaUpdateRequest request, CancellationToken cancellationToken = default)
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
