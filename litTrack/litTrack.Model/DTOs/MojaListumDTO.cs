using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class MojaListumDTO
    {
        public int MojaListaId { get; set; }

        public int KorisnikId { get; set; }

        public int KnjigaId { get; set; }

        public bool JeProcitana { get; set; }

        public DateTime DatumDodavanja { get; set; }

        public string? NazivKnjige { get; set; }

        public string? AutorNaziv { get; set; }

        public decimal? Cijena { get; set; }

        public byte[]? Slika { get; set; }
    }
}
