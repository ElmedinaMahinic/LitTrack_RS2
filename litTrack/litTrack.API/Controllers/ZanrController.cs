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
    public class ZanrController : BaseCRUDControllerAsync<Model.DTOs.ZanrDTO, ZanrSearchObject, ZanrInsertRequest, ZanrUpdateRequest>
    {
        public ZanrController(IZanrService service)
            : base(service)
        {
        }

        [HttpGet]
        public override Task<PagedResult<Model.DTOs.ZanrDTO>> GetList([FromQuery] ZanrSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [HttpGet("{id}")]
        public override Task<Model.DTOs.ZanrDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [HttpPost]
        public override Task<Model.DTOs.ZanrDTO> Insert(ZanrInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public override Task<Model.DTOs.ZanrDTO> Update(int id, ZanrUpdateRequest request, CancellationToken cancellationToken = default)
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
