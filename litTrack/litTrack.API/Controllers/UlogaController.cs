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
    public class UlogaController : BaseCRUDControllerAsync<Model.DTOs.UlogaDTO, UlogaSearchObject, UlogaInsertRequest, UlogaUpdateRequest>
    {
        public UlogaController(IUlogaService service)
            : base(service)
        {
        }

        [Authorize]
        [HttpGet]
        public override Task<PagedResult<Model.DTOs.UlogaDTO>> GetList([FromQuery] UlogaSearchObject searchObject, CancellationToken cancellationToken = default)
        {
            return base.GetList(searchObject, cancellationToken);
        }

        [Authorize]
        [HttpGet("{id}")]
        public override Task<Model.DTOs.UlogaDTO> GetById(int id, CancellationToken cancellationToken = default)
        {
            return base.GetById(id, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPost]
        public override Task<Model.DTOs.UlogaDTO> Insert(UlogaInsertRequest request, CancellationToken cancellationToken = default)
        {
            return base.Insert(request, cancellationToken);
        }

        [Authorize(Roles = "Admin")]
        [HttpPut("{id}")]
        public override Task<Model.DTOs.UlogaDTO> Update(int id, UlogaUpdateRequest request, CancellationToken cancellationToken = default)
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
