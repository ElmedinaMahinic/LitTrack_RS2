using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class KnjigaUpdateRequest
    {
        [Required(ErrorMessage = "Naziv je obavezan.")]
        [MaxLength(100, ErrorMessage = "Naziv može imati najviše 100 karaktera.")]
        [MinLength(1, ErrorMessage = "Naziv ne može biti prazan.")]
        public string Naziv { get; set; } = string.Empty;

        [Required(ErrorMessage = "Opis je obavezan.")]
        [MaxLength(1000, ErrorMessage = "Opis može imati najviše 1000 karaktera.")]
        [MinLength(1, ErrorMessage = "Opis ne može biti prazan.")]
        public string Opis { get; set; } = string.Empty;

        public int GodinaIzdavanja { get; set; }

        [Required(ErrorMessage = "Autor je obavezan.")]
        public int AutorId { get; set; }

        public byte[]? Slika { get; set; }

        [Required(ErrorMessage = "Cijena je obavezna.")]
        [Range(1, 1000, ErrorMessage = "Cijena mora biti između 1 i 1000.")]
        public decimal Cijena { get; set; }

        public List<int>? CiljneGrupe { get; set; }

        public List<int>? Zanrovi { get; set; }

    }
}
