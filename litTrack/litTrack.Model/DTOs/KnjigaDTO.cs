using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class KnjigaDTO
    {
        public int KnjigaId { get; set; }

        public string Naziv { get; set; } = null!;

        public string Opis { get; set; } = null!;

        public int GodinaIzdavanja { get; set; }

        public int AutorId { get; set; }

        public byte[]? Slika { get; set; }

        public decimal Cijena { get; set; }

        public string? AutorNaziv { get; set; } 

        public List<string> Zanrovi { get; set; } = new List<string>();

        public List<string> CiljneGrupe { get; set; } = new List<string>();
    }
}
