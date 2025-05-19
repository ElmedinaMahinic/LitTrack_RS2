using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.Requests
{
    public class AutorUpdateRequest
    {
        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Biografija { get; set; }
    }
}
