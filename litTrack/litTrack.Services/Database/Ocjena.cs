using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Ocjena
{
    public int OcjenaId { get; set; }

    public int KnjigaId { get; set; }

    public int KorisnikId { get; set; }

    public int Vrijednost { get; set; }

    public DateTime DatumOcjenjivanja { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Knjiga Knjiga { get; set; } = null!;

    public virtual Korisnik Korisnik { get; set; } = null!;
}
