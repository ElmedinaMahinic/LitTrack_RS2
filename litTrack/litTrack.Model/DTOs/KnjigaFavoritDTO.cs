using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.DTOs
{
    public class KnjigaFavoritDTO
    {
        public int KnjigaId { get; set; }
        public string? NazivKnjige { get; set; }
        public string? AutorNaziv { get; set; }
        public byte[]? Slika { get; set; }
        public int BrojArhiviranja { get; set; }
    }
}
