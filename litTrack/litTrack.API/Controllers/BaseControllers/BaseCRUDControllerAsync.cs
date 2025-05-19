using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesInterfaces;
using Microsoft.AspNetCore.Mvc;

namespace litTrack.API.Controllers.BaseControllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class BaseCRUDControllerAsync<TModel, TSearch, TInsert, TUpdate> : BaseControllerAsync<TModel, TSearch> where TSearch : BaseSearchObject where TModel : class
    {
        protected readonly ICRUDServiceAsync<TModel, TSearch, TInsert, TUpdate> _crudService;

        public BaseCRUDControllerAsync(ICRUDServiceAsync<TModel, TSearch, TInsert, TUpdate> service) : base(service)
        {
            _crudService = service;
        }
        [HttpPost]
        public virtual Task<TModel> Insert(TInsert request, CancellationToken cancellationToken = default)
        {
            return _crudService.InsertAsync(request, cancellationToken);
        }

        [HttpPut("{id}")]
        public virtual Task<TModel> Update(int id, TUpdate request, CancellationToken cancellationToken = default)
        {
            return _crudService.UpdateAsync(id, request, cancellationToken);
        }

        [HttpDelete("{id}")]
        public virtual Task Delete(int id, CancellationToken cancellationToken = default)
        {
            return _crudService.DeleteAsync(id, cancellationToken);
        }

    }
}
