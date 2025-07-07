using litTrack.API.Controllers.BaseControllers;
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
    public class ZanrController : BaseCRUDControllerAsync<Model.DTOs.ZanrDTO, ZanrSearchObject, ZanrInsertRequest, ZanrUpdateRequest>
    {
        public ZanrController(IZanrService service)
            : base(service)
        {
        }

        [AllowAnonymous]
        [HttpGet]
        public override Task<PagedResult<Model.DTOs.ZanrDTO>> GetList([FromQuery] ZanrSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [AllowAnonymous]
        [HttpGet("{id}")]
        public override Task<Model.DTOs.ZanrDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public override Task<Model.DTOs.ZanrDTO> Insert(ZanrInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public override Task<Model.DTOs.ZanrDTO> Update(int id, ZanrUpdateRequest request, CancellationToken cancellationToken = default)
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
