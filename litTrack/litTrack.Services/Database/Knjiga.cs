using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Knjiga : ISoftDelete
{
    public int KnjigaId { get; set; }

    public string Naziv { get; set; } = null!;

    public string Opis { get; set; } = null!;

    public int GodinaIzdavanja { get; set; }

    public int AutorId { get; set; }

    public byte[]? Slika { get; set; }

    public decimal Cijena { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual ICollection<Arhiva> Arhivas { get; set; } = new List<Arhiva>();

    public virtual Autor Autor { get; set; } = null!;

    public virtual ICollection<KnjigaCiljnaGrupa> KnjigaCiljnaGrupas { get; set; } = new List<KnjigaCiljnaGrupa>();

    public virtual ICollection<KnjigaZanr> KnjigaZanrs { get; set; } = new List<KnjigaZanr>();

    public virtual ICollection<LicnaPreporukaKnjiga> LicnaPreporukaKnjigas { get; set; } = new List<LicnaPreporukaKnjiga>();

    public virtual ICollection<MojaListum> MojaLista { get; set; } = new List<MojaListum>();

    public virtual ICollection<Ocjena> Ocjenas { get; set; } = new List<Ocjena>();

    public virtual ICollection<Preporuka> Preporukas { get; set; } = new List<Preporuka>();

    public virtual ICollection<Recenzija> Recenzijas { get; set; } = new List<Recenzija>();

    public virtual ICollection<StavkaNarudzbe> StavkaNarudzbes { get; set; } = new List<StavkaNarudzbe>();
}
