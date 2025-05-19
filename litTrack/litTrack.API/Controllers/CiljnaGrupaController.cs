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
    public class CiljnaGrupaController : BaseCRUDControllerAsync<Model.DTOs.CiljnaGrupaDTO, CiljnaGrupaSearchObject, CiljnaGrupaInsertRequest, CiljnaGrupaUpdateRequest>
    {
        public CiljnaGrupaController(ICiljnaGrupaService service)
           : base(service)
        {
        }

        [HttpGet]
        public override Task<PagedResult<Model.DTOs.CiljnaGrupaDTO>> GetList([FromQuery] CiljnaGrupaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        public override Task<Model.DTOs.CiljnaGrupaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [HttpPost]
        public override Task<Model.DTOs.CiljnaGrupaDTO> Insert(CiljnaGrupaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public override Task<Model.DTOs.CiljnaGrupaDTO> Update(int id, CiljnaGrupaUpdateRequest request, CancellationToken cancellationToken = default)
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
