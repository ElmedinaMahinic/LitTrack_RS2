using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Narudzba
{
    public int NarudzbaId { get; set; }

    public int KorisnikId { get; set; }

    public int NacinPlacanjaId { get; set; }

    public string Sifra { get; set; } = null!;

    public DateTime DatumNarudzbe { get; set; }

    public decimal UkupnaCijena { get; set; }

    public string? StateMachine { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual NacinPlacanja NacinPlacanja { get; set; } = null!;

    public virtual ICollection<StavkaNarudzbe> StavkaNarudzbes { get; set; } = new List<StavkaNarudzbe>();
}
