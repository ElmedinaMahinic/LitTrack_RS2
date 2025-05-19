using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class UlogaDTO
    {
        public int UlogaId { get; set; }

        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }
    }
}
