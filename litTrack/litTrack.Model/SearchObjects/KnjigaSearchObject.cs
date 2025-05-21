using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.SearchObjects
{
    public class KnjigaSearchObject : BaseSearchObject
    {
        public string? Naziv { get; set; }

        public int? GodinaIzdavanjaGTE { get; set; }
        public int? GodinaIzdavanjaLTE { get; set; }

        public decimal? CijenaGTE { get; set; }
        public decimal? CijenaLTE { get; set; }

        public int? AutorId { get; set; }

        public int? ZanrId { get; set; }

        public int? CiljnaGrupaId { get; set; }
    }
}
