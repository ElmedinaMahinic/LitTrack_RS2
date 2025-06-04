using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.SearchObjects
{
    public class StavkaNarudzbeSearchObject : BaseSearchObject
    {
        public decimal? CijenaLTE { get; set; }
        public decimal? CijenaGTE { get; set; }

        public int? NarudzbaId { get; set; }

        public int? KnjigaId { get; set; }
    }
}
