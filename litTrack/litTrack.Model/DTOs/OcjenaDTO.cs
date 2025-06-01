using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class OcjenaDTO
    {
        public int OcjenaId { get; set; }

        public int KnjigaId { get; set; }

        public int KorisnikId { get; set; }

        public int Vrijednost { get; set; }

        public DateTime DatumOcjenjivanja { get; set; }
    }
}
