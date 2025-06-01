using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.SearchObjects
{
    public class RecenzijaSearchObject : BaseSearchObject
    {
        public int? KorisnikId { get; set; }
        public int? KnjigaId { get; set; }

        public DateTime? DatumDodavanjaGTE { get; set; }
        public DateTime? DatumDodavanjaLTE { get; set; }

        public int? BrojLajkovaGTE { get; set; }
        public int? BrojLajkovaLTE { get; set; }

        public int? BrojDislajkovaGTE { get; set; }
        public int? BrojDislajkovaLTE { get; set; }
    }
}
