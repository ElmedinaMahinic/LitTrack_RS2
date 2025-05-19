using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Zanr : ISoftDelete
{
    public int ZanrId { get; set; }

    public string Naziv { get; set; } = null!;

    public string? Opis { get; set; }

    public byte[]? Slika { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual ICollection<KnjigaZanr> KnjigaZanrs { get; set; } = new List<KnjigaZanr>();
}
