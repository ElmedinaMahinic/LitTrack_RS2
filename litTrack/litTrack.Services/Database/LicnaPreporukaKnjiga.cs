using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class LicnaPreporukaKnjiga : ISoftDelete
{
    public int LicnaPreporukaKnjigaId { get; set; }

    public int KnjigaId { get; set; }

    public int LicnaPreporukaId { get; set; }

    public DateTime DatumDodavanja { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Knjiga Knjiga { get; set; } = null!;

    public virtual LicnaPreporuka LicnaPreporuka { get; set; } = null!;
}
