using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class LicnaPreporuka : ISoftDelete
{
    public int LicnaPreporukaId { get; set; }

    public int KorisnikPosiljalacId { get; set; }

    public int KorisnikPrimalacId { get; set; }

    public DateTime DatumPreporuke { get; set; }

    public string? Naslov { get; set; }

    public string? Poruka { get; set; }

    public bool JePogledana { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Korisnik KorisnikPosiljalac { get; set; } = null!;

    public virtual Korisnik KorisnikPrimalac { get; set; } = null!;

    public virtual ICollection<LicnaPreporukaKnjiga> LicnaPreporukaKnjigas { get; set; } = new List<LicnaPreporukaKnjiga>();
}
