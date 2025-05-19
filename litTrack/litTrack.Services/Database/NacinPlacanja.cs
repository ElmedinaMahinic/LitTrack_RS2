using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class NacinPlacanja : ISoftDelete
{
    public int NacinPlacanjaId { get; set; }

    public string Naziv { get; set; } = null!;

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual ICollection<Narudzba> Narudzbas { get; set; } = new List<Narudzba>();
}
