﻿using System;
using System.Collections.Generic;
using System.Text;

namespace litTrack.Model.SearchObjects
{
    public class ArhivaSearchObject : BaseSearchObject
    {
        public int? KorisnikId { get; set; }

        public int? KnjigaId { get; set; }

        public DateTime? DatumDodavanjaGTE { get; set; }

        public DateTime? DatumDodavanjaLTE { get; set; }
    }
}
