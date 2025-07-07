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
    public class CiljnaGrupaController : BaseCRUDControllerAsync<Model.DTOs.CiljnaGrupaDTO, CiljnaGrupaSearchObject, CiljnaGrupaInsertRequest, CiljnaGrupaUpdateRequest>
    {
        public CiljnaGrupaController(ICiljnaGrupaService service)
           : base(service)
        {
        }

        [AllowAnonymous]
        [HttpGet]
        public override Task<PagedResult<Model.DTOs.CiljnaGrupaDTO>> GetList([FromQuery] CiljnaGrupaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        [HttpGet("{id}")]
        public override Task<Model.DTOs.CiljnaGrupaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public override Task<Model.DTOs.CiljnaGrupaDTO> Insert(CiljnaGrupaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public override Task<Model.DTOs.CiljnaGrupaDTO> Update(int id, CiljnaGrupaUpdateRequest request, CancellationToken cancellationToken = default)
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
