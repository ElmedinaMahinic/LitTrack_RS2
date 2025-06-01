using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class PreporukaDTO
    {
        public int PreporukaId { get; set; }

        public int KorisnikId { get; set; }

        public int KnjigaId { get; set; }

        public DateTime DatumPreporuke { get; set; }

        public string? NazivKnjige { get; set; }

        public string? AutorNaziv { get; set; }

        public decimal? Cijena { get; set; }

        public byte[]? Slika { get; set; }
    }
}
