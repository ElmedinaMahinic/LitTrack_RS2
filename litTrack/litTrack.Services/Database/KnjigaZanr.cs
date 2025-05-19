using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class KnjigaZanr : ISoftDelete
{
    public int KnjigaZanrId { get; set; }

    public int KnjigaId { get; set; }

    public int ZanrId { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Knjiga Knjiga { get; set; } = null!;

    public virtual Zanr Zanr { get; set; } = null!;
}
