using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class NarudzbaInsertRequest
    {
        [Required(ErrorMessage = "Korisnik je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Način plaćanja je obavezan.")]
        public int NacinPlacanjaId { get; set; }

        [Required(ErrorMessage = "Adresa je obavezna.")]
        [StringLength(200, ErrorMessage = "Adresa ne može biti duža od 200 karaktera.")]
        public string Adresa { get; set; } = string.Empty;

        public List<StavkaNarudzbeInsertRequest> StavkeNarudzbe { get; set; } = new List<StavkaNarudzbeInsertRequest>();
    }
}
