using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.Requests
{
    public class KnjigaInsertRequest
    {
        public string Naziv { get; set; } = null!;

        public string Opis { get; set; } = null!;

        public int GodinaIzdavanja { get; set; }

        public int AutorId { get; set; }

        public byte[]? Slika { get; set; }

        public decimal Cijena { get; set; }

        public List<int> CiljneGrupe { get; set; } = new List<int>();

        public List<int> Zanrovi { get; set; } = new List<int>();
    }
}
