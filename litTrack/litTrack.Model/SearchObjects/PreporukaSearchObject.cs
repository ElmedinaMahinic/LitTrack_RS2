using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.SearchObjects
{
    public class PreporukaSearchObject : BaseSearchObject
    {
        public int? KorisnikId { get; set; }
        public int? KnjigaId { get; set; }
        public DateTime? DatumPreporukeGTE { get; set; }
        public DateTime? DatumPreporukeLTE { get; set; }
    }
}
