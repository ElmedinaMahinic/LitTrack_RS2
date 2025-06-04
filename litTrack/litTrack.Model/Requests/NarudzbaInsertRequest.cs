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

        public List<StavkaNarudzbeInsertRequest> StavkeNarudzbe { get; set; } = new List<StavkaNarudzbeInsertRequest>();
    }
}
