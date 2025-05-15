using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class CiljnaGrupa
{
    public int CiljnaGrupaId { get; set; }

    public string Naziv { get; set; } = null!;

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual ICollection<KnjigaCiljnaGrupa> KnjigaCiljnaGrupas { get; set; } = new List<KnjigaCiljnaGrupa>();
}
