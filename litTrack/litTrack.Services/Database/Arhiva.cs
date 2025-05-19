using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Arhiva : ISoftDelete
{
    public int ArhivaId { get; set; }

    public int KorisnikId { get; set; }

    public int KnjigaId { get; set; }

    public DateTime DatumDodavanja { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Knjiga Knjiga { get; set; } = null!;

    public virtual Korisnik Korisnik { get; set; } = null!;
}
