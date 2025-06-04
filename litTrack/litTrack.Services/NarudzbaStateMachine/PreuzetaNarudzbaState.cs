using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.NarudzbaStateMachine
{
    public class PreuzetaNarudzbaState : BaseNarudzbaState
    {
        public PreuzetaNarudzbaState(_210078Context context, IMapper mapper, IServiceProvider serviceProvider)
        : base(context, mapper, serviceProvider)
        {
        }

        public override async Task<NarudzbaDTO> UToku(int narudzbaId, CancellationToken cancellationToken)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = await set.FindAsync(new object[] { narudzbaId }, cancellationToken);

            if (entity == null)
                throw new UserException("Narudžba nije pronađena.");

            entity.StateMachine = "uToku";
            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<NarudzbaDTO>(entity);
        }

        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string> { nameof(UToku) };
        }
    }
}
