using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.SearchObjects
{
    public class NarudzbaSearchObject : BaseSearchObject
    {
        public string? Sifra { get; set; }
        public decimal? UkupnaCijena { get; set; }
        public DateTime? DatumNarudzbe { get; set; }
        public DateTime? DatumNarudzbeGTE { get; set; }
        public DateTime? DatumNarudzbeLTE { get; set; }
        public List<string>? StateMachine { get; set; }
        public int? KorisnikId { get; set; }
        public int? NacinPlacanjaId { get; set; }
    }
}
