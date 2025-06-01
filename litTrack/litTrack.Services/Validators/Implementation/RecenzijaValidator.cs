using litTrack.Services.Database;
using litTrack.Services.Validators.Interfaces;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Implementation
{
    public class RecenzijaValidator : BaseValidatorService<Recenzija>, IRecenzijaValidator
    {
        public RecenzijaValidator(_210078Context context) : base(context)
        {
        }
    }
}
