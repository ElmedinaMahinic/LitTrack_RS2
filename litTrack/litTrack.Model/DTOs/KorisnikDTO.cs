using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class KorisnikDTO
    {
        public int KorisnikId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string KorisnickoIme { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string? Telefon { get; set; }

        public bool? JeAktivan { get; set; }

        public DateTime DatumRegistracije { get; set; }

        public List<string> Uloge { get; set; } = new List<string>();
    }
}
