﻿using litTrack.Model.Exceptions;
using litTrack.Services.Database;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators
{
    public class BaseValidatorService<TEntity> : IBaseValidatorService<TEntity> where TEntity : class
    {
        private readonly _210078Context context;

        public BaseValidatorService(_210078Context context)
        {
            this.context = context;
        }

        public virtual async Task ValidateEntityExistsAsync(int id, CancellationToken cancellationToken = default)
        {
            var entity = await context.Set<TEntity>().FindAsync(new object[] { id }, cancellationToken);

            if (entity == null)
                throw new UserException($"Ne postoji {typeof(TEntity).Name} sa id: {id}");

            if (entity is ISoftDelete softDeletedEntity && softDeletedEntity.IsDeleted)
                throw new UserException($"{typeof(TEntity).Name} sa id: {id} je obrisan.");
        }

        public virtual void ValidateNoDuplicates(List<int> array)
        {
            if (array == null)
                throw new UserException("Lista je null!");

            if (array.Count != array.Distinct().Count())
                throw new UserException($"Lista {typeof(TEntity).Name} ima duplikate!");

        }

    }
}
