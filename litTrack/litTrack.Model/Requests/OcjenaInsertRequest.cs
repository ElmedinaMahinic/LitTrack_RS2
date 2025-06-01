using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class OcjenaInsertRequest
    {
        [Required(ErrorMessage = "KnjigaId je obavezan.")]
        public int KnjigaId { get; set; }

        [Required(ErrorMessage = "KorisnikId je obavezan.")]
        public int KorisnikId { get; set; }

        [Required(ErrorMessage = "Vrijednost ocjene je obavezna.")]
        [Range(1, 5, ErrorMessage = "Ocjena mora biti između 1 i 5.")]
        public int Vrijednost { get; set; }
    }
}
