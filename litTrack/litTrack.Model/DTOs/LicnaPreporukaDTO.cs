using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class LicnaPreporukaDTO
    {
        public int LicnaPreporukaId { get; set; }

        public int KorisnikPosiljalacId { get; set; }
        public int KorisnikPrimalacId { get; set; }

        public DateTime DatumPreporuke { get; set; }

        public string? Naslov { get; set; }
        public string? Poruka { get; set; }

        public bool JePogledana { get; set; }

        public string? PosiljalacKorisnickoIme { get; set; }
        public string? PrimalacKorisnickoIme { get; set; }

        public List<string> Knjige { get; set; } = new List<string>();
    }
}
