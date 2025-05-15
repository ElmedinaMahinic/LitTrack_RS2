using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class KnjigaCiljnaGrupa
{
    public int KnjigaCiljnaGrupaId { get; set; }

    public int CiljnaGrupaId { get; set; }

    public int KnjigaId { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual CiljnaGrupa CiljnaGrupa { get; set; } = null!;

    public virtual Knjiga Knjiga { get; set; } = null!;
}
