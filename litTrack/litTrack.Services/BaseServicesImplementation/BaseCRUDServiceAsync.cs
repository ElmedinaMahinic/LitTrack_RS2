using litTrack.Model.Exceptions;
using litTrack.Model.SearchObjects;
using litTrack.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.BaseServicesImplementation
{
    public class BaseCRUDServiceAsync<TModel, TSearch, TDbEntity, TInsert, TUpdate> : BaseServiceAsync<TModel, TSearch, TDbEntity> where TModel : class where TSearch : BaseSearchObject where TDbEntity : class
    {
        public BaseCRUDServiceAsync(_210078Context context, IMapper mapper) : base(context, mapper)
        {
        }

        public virtual async Task<TModel> InsertAsync(TInsert request, CancellationToken cancellationToken = default)
        {
            if (request == null)
                throw new ArgumentNullException(nameof(request));

            TDbEntity entity = Mapper.Map<TDbEntity>(request);

            await BeforeInsertAsync(request, entity, cancellationToken);
            Context.Add(entity);
            await Context.SaveChangesAsync(cancellationToken);

            await AfterInsertAsync(request, entity, cancellationToken);

            return Mapper.Map<TModel>(entity);
        }

        public virtual Task BeforeInsertAsync(TInsert request, TDbEntity entity, CancellationToken cancellationToken = default)
            => Task.CompletedTask;
        public virtual Task AfterInsertAsync(TInsert request, TDbEntity entity, CancellationToken cancellationToken = default)
            => Task.CompletedTask;


        public virtual async Task<TModel> UpdateAsync(int id, TUpdate request, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<TDbEntity>();

            var entity = await set.FindAsync(id, cancellationToken);

            if (entity == null)
                throw new UserException("Unesite postojeći id.");

            Mapper.Map(request, entity);
            await BeforeUpdateAsync(request, entity, cancellationToken);


            await Context.SaveChangesAsync(cancellationToken);

            await AfterUpdateAsync(request, entity, cancellationToken);

            return Mapper.Map<TModel>(entity);
        }

        public virtual Task BeforeUpdateAsync(TUpdate request, TDbEntity entity, CancellationToken cancellationToken = default)
            => Task.CompletedTask;
        public virtual Task AfterUpdateAsync(TUpdate request, TDbEntity entity, CancellationToken cancellationToken = default)
            => Task.CompletedTask;

        public virtual async Task DeleteAsync(int id, CancellationToken cancellationToken = default)
        {

            var entity = await Context.Set<TDbEntity>().FindAsync(id, cancellationToken);

            if (entity == null)
                throw new UserException("Unesite postojeći id.");

            await BeforeDeleteAsync(entity, cancellationToken);
            
            if (entity is ISoftDelete softDeleteEntity)
            {
                softDeleteEntity.IsDeleted = true;
                softDeleteEntity.VrijemeBrisanja = DateTime.Now;
                Context.Update(entity);
            }
            else
            {
                Context.Remove(entity);
            }

            await Context.SaveChangesAsync(cancellationToken);
            await AfterDeleteAsync(entity, cancellationToken);

        }

        public virtual Task BeforeDeleteAsync(TDbEntity entity, CancellationToken cancellationToken = default)
            => Task.CompletedTask;
        public virtual Task AfterDeleteAsync(TDbEntity entity, CancellationToken cancellationToken = default)
            => Task.CompletedTask;
    }
}
