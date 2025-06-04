using litTrack.Services.Database;
using MapsterMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.NarudzbaStateMachine
{
    public class PonistenaNarudzbaState : BaseNarudzbaState
    {
        public PonistenaNarudzbaState(_210078Context context, IMapper mapper, IServiceProvider serviceProvider)
        : base(context, mapper, serviceProvider)
        {
        }

        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>(); 
        }
    }
}
