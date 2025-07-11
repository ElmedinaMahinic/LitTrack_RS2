﻿using litTrack.API.Controllers.BaseControllers;
using litTrack.Model.DTOs;
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
    public class LicnaPreporukaController : BaseCRUDControllerAsync<Model.DTOs.LicnaPreporukaDTO, LicnaPreporukaSearchObject, LicnaPreporukaInsertRequest, LicnaPreporukaUpdateRequest>
    {
        private readonly ILicnaPreporukaService _licnaPreporukaService;

        public LicnaPreporukaController(ILicnaPreporukaService licnaPreporukaService) : base(licnaPreporukaService)
        {
            _licnaPreporukaService = licnaPreporukaService;
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPut("OznaciKaoPogledanu/{licnaPreporukaId}")]
        public async Task<ActionResult> OznaciKaoPogledanuAsync(int licnaPreporukaId, CancellationToken cancellationToken)
        {
            await _licnaPreporukaService.OznaciKaoPogledanuAsync(licnaPreporukaId, cancellationToken);
            return Ok();
        }

        [Authorize(Roles = "Korisnik")]
        [HttpGet]
        public override Task<PagedResult<LicnaPreporukaDTO>> GetList([FromQuery] LicnaPreporukaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpGet("{id}")]
        public override Task<LicnaPreporukaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPost]
        public override Task<LicnaPreporukaDTO> Insert(LicnaPreporukaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Korisnik")]
        [HttpPut("{id}")]
        public override Task<LicnaPreporukaDTO> Update(int id, LicnaPreporukaUpdateRequest request, CancellationToken cancellationToken = default)
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
