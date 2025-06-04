using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class NarudzbaDTO
    {
        public int NarudzbaId { get; set; }

        public string Sifra { get; set; } = string.Empty;

        public DateTime DatumNarudzbe { get; set; }

        public decimal UkupnaCijena { get; set; }

        public string? StateMachine { get; set; }

        public int KorisnikId { get; set; }

        public int NacinPlacanjaId { get; set; }

        public string? ImePrezime { get; set; } 

        public string? NacinPlacanja { get; set; }   

        public int? BrojStavki { get; set; }
    }
}
