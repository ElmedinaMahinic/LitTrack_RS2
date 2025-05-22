using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.Requests
{
    public class KorisnikUpdateRequest
    {
        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Email { get; set; }

        public string? Telefon { get; set; }

        public bool? JeAktivan { get; set; }

        public string? StaraLozinka { get; set; }

        public string? Lozinka { get; set; }

        public string? LozinkaPotvrda { get; set; }
    }
}
