using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class StavkaNarudzbeInsertRequest
    {
        [Required(ErrorMessage = "Knjiga je obavezna.")]
        public int KnjigaId { get; set; }

        public int Kolicina { get; set; }
    }
}
