using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class RecenzijaInsertRequest
    {
        [Required(ErrorMessage = "Korisnik je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Knjiga je obavezna.")]
        public int KnjigaId { get; set; }

        [Required(ErrorMessage = "Komentar je obavezan.")]
        [MinLength(1, ErrorMessage = "Komentar ne može biti prazan.")]
        [MaxLength(500, ErrorMessage = "Komentar može imati najviše 500 znakova.")]
        public string Komentar { get; set; } = string.Empty;
    }
}
