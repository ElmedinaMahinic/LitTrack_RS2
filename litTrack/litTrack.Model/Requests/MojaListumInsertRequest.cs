using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class MojaListumInsertRequest
    {
        [Required(ErrorMessage = "Korisnik je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Knjiga je obavezna.")]
        public int KnjigaId { get; set; }
    }
}
