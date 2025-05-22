using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.Requests
{
    public class KorisnikLoginRequest
    {
        public string KorisnickoIme { get; set; } = string.Empty;
        public string Lozinka { get; set; } = string.Empty;
    }
}
