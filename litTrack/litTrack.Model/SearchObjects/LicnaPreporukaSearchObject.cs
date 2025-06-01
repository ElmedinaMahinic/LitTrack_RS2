using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.SearchObjects
{
    public class LicnaPreporukaSearchObject : BaseSearchObject
    {
        public int? KorisnikPosiljalacId { get; set; }

        public int? KorisnikPrimalacId { get; set; }

        public DateTime? DatumPreporuke { get; set; }

        public DateTime? DatumPreporukeGTE { get; set; }

        public DateTime? DatumPreporukeLTE { get; set; }

        public bool? JePogledana { get; set; }
    }
}
