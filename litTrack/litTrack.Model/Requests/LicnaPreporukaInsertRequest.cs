using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class LicnaPreporukaInsertRequest
    {
        [Required(ErrorMessage = "Pošiljalac je obavezan.")]
        public int KorisnikPosiljalacId { get; set; }

        [Required(ErrorMessage = "Primalac je obavezan.")]
        public int KorisnikPrimalacId { get; set; }

        [MaxLength(100, ErrorMessage = "Naslov može imati najviše 100 karaktera.")]
        [MinLength(1, ErrorMessage = "Naslov ne može biti prazan.")]
        public string? Naslov { get; set; }

        [MaxLength(1000, ErrorMessage = "Poruka može imati najviše 1000 karaktera.")]
        [MinLength(1, ErrorMessage = "Poruka ne može biti prazna.")]
        public string? Poruka { get; set; }

        public List<int> Knjige { get; set; } = new List<int>();
    }
}
