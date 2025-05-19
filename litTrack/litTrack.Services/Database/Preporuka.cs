using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Preporuka : ISoftDelete
{
    public int PreporukaId { get; set; }

    public int KorisnikId { get; set; }

    public int KnjigaId { get; set; }

    public DateTime DatumPreporuke { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Knjiga Knjiga { get; set; } = null!;

    public virtual Korisnik Korisnik { get; set; } = null!;
}
