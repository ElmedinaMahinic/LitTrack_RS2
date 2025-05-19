using System;
using System.Collections.Generic;

namespace litTrack.Services.Database;

public partial class Recenzija : ISoftDelete
{
    public int RecenzijaId { get; set; }

    public int KorisnikId { get; set; }

    public int KnjigaId { get; set; }

    public string Komentar { get; set; } = null!;

    public DateTime DatumDodavanja { get; set; }

    public int BrojLajkova { get; set; }

    public int BrojDislajkova { get; set; }

    public bool IsDeleted { get; set; }

    public DateTime? VrijemeBrisanja { get; set; }

    public virtual Knjiga Knjiga { get; set; } = null!;

    public virtual Korisnik Korisnik { get; set; } = null!;

    public virtual ICollection<RecenzijaOdgovor> RecenzijaOdgovors { get; set; } = new List<RecenzijaOdgovor>();

    public virtual ICollection<RecenzijaReakcija> RecenzijaReakcijas { get; set; } = new List<RecenzijaReakcija>();
}
