using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class StavkaNarudzbe : ISoftDelete
{
    public int StavkaNarudzbeId { get; set; }

    public int NarudzbaId { get; set; }

    public int KnjigaId { get; set; }

    public int Kolicina { get; set; }

    public decimal Cijena { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Knjiga Knjiga { get; set; } = null!;

    public virtual Narudzba Narudzba { get; set; } = null!;
}
