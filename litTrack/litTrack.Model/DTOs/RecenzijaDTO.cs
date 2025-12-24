using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class RecenzijaDTO
    {
        public int RecenzijaId { get; set; }

        public int KorisnikId { get; set; }

        public int KnjigaId { get; set; }

        public string Komentar { get; set; } = null!;

        public DateTime DatumDodavanja { get; set; }

        public int BrojLajkova { get; set; }

        public int BrojDislajkova { get; set; }

        public string? KorisnickoIme { get; set; }

        public bool? JeLajkovao { get; set; }

        public bool? JeDislajkovao { get; set; }
    }
}
