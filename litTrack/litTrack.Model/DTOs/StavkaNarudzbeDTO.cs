using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class StavkaNarudzbeDTO
    {
        public int StavkaNarudzbeId { get; set; }

        public int NarudzbaId { get; set; }

        public int KnjigaId { get; set; }

        public int Kolicina { get; set; }

        public decimal Cijena { get; set; }

        public string? NazivKnjige { get; set; }

        public byte[]? Slika { get; set; }

    }
}
