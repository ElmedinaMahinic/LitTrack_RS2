using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.Requests
{
    public class KorisnikInsertRequest
    {
        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string KorisnickoIme { get; set; } = null!;

        public string Email { get; set; } = null!;

        public string? Telefon { get; set; }

        public string Lozinka { get; set; } = null!;
        public string LozinkaPotvrda { get; set; } = null!;

        public List<int> Uloge { get; set; } = new List<int>();
    }
}
