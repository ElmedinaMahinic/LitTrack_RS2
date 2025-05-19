using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class ZanrDTO
    {
        public int ZanrId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public byte[]? Slika { get; set; }
    }
}
