using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class AutorInsertRequest
    {
        [Required(ErrorMessage = "Ime je obavezno.")]
        [MaxLength(50, ErrorMessage = "Ime može imati najviše 50 karaktera.")]
        [MinLength(1, ErrorMessage = "Ime ne može biti prazno.")]
        public string Ime { get; set; } = string.Empty;

        [Required(ErrorMessage = "Prezime je obavezno.")]
        [MaxLength(50, ErrorMessage = "Prezime može imati najviše 50 karaktera.")]
        [MinLength(1, ErrorMessage = "Prezime ne može biti prazno.")]
        public string Prezime { get; set; } = string.Empty;

        [MaxLength(1000, ErrorMessage = "Biografija može imati najviše 1000 karaktera.")]
        [MinLength(1, ErrorMessage = "Biografija ne može biti prazna.")]
        public string? Biografija { get; set; }
    }
}
