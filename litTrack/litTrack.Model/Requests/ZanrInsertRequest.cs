using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.Requests
{
    public class ZanrInsertRequest
    {
        public string Naziv { get; set; } = null!;

        public string? Opis { get; set; }

        public byte[]? Slika { get; set; }
    }
}
