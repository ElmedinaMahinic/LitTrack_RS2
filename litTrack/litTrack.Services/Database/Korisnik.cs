using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Korisnik
{
    public int KorisnikId { get; set; }

    public string Ime { get; set; } = null!;

    public string Prezime { get; set; } = null!;

    public string KorisnickoIme { get; set; } = null!;

    public string Email { get; set; } = null!;

    public string? Telefon { get; set; }

    public string LozinkaHash { get; set; } = null!;

    public string LozinkaSalt { get; set; } = null!;

    public bool? JeAktivan { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public DateTime DatumRegistracije { get; set; }

    public virtual ICollection<Arhiva> Arhivas { get; set; } = new List<Arhiva>();

    public virtual ICollection<KorisnikUloga> KorisnikUlogas { get; set; } = new List<KorisnikUloga>();

    public virtual ICollection<LicnaPreporuka> LicnaPreporukaKorisnikPosiljalacs { get; set; } = new List<LicnaPreporuka>();

    public virtual ICollection<LicnaPreporuka> LicnaPreporukaKorisnikPrimalacs { get; set; } = new List<LicnaPreporuka>();

    public virtual ICollection<MojaListum> MojaLista { get; set; } = new List<MojaListum>();

    public virtual ICollection<Narudzba> Narudzbas { get; set; } = new List<Narudzba>();

    public virtual ICollection<Obavijest> Obavijests { get; set; } = new List<Obavijest>();

    public virtual ICollection<Ocjena> Ocjenas { get; set; } = new List<Ocjena>();

    public virtual ICollection<Preporuka> Preporukas { get; set; } = new List<Preporuka>();

    public virtual ICollection<RecenzijaOdgovorReakcija> RecenzijaOdgovorReakcijas { get; set; } = new List<RecenzijaOdgovorReakcija>();

    public virtual ICollection<RecenzijaOdgovor> RecenzijaOdgovors { get; set; } = new List<RecenzijaOdgovor>();

    public virtual ICollection<RecenzijaReakcija> RecenzijaReakcijas { get; set; } = new List<RecenzijaReakcija>();

    public virtual ICollection<Recenzija> Recenzijas { get; set; } = new List<Recenzija>();
}
