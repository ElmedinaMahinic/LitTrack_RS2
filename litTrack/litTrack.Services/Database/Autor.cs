using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Autor
{
    public int AutorId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string? Biografija { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual ICollection<Knjiga> Knjigas { get; set; } = new List<Knjiga>();
}
