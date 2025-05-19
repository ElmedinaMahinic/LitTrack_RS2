using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class AutorDTO
    {
        public int AutorId { get; set; }

        public string Ime { get; set; } = null!;

        public string Prezime { get; set; } = null!;

        public string? Biografija { get; set; }
    }
}
