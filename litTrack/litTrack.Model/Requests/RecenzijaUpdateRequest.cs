﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Text;

namespace litTrack.Model.Requests
{
    public class RecenzijaUpdateRequest
    {
        [Required(ErrorMessage = "Komentar je obavezan.")]
        [MinLength(1, ErrorMessage = "Komentar ne može biti prazan.")]
        [MaxLength(500, ErrorMessage = "Komentar može imati najviše 500 znakova.")]
        public string Komentar { get; set; } = string.Empty;
    }
}
