using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Requests;
using litTrack.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.NarudzbaStateMachine
{
    public class KreiranaNarudzbaState : BaseNarudzbaState
    {
        public KreiranaNarudzbaState(_210078Context context, IMapper mapper, IServiceProvider serviceProvider)
       : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<NarudzbaDTO> Update(int narudzbaId, NarudzbaUpdateRequest request, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = await set.FindAsync(new object[] { narudzbaId }, cancellationToken);

            if (entity == null)
                throw new UserException("Narudžba nije pronađena");

            Mapper.Map(request, entity);
            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<NarudzbaDTO>(entity);
        }

        public override async Task<NarudzbaDTO> Preuzeta(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = await set.FindAsync(new object[] { narudzbaId }, cancellationToken);

            if (entity == null)
                throw new UserException("Narudžba nije pronađena");

            entity.StateMachine = "preuzeta";
            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<NarudzbaDTO>(entity);
        }

        public override async Task<NarudzbaDTO> Ponistena(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = await set.FindAsync(new object[] { narudzbaId }, cancellationToken);

            if (entity == null)
                throw new UserException("Narudžba nije pronađena");

            entity.StateMachine = "ponistena";
            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<NarudzbaDTO>(entity);
        }


        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>() { nameof(Update), nameof(Preuzeta), nameof(Ponistena) };
        }
    }
}
