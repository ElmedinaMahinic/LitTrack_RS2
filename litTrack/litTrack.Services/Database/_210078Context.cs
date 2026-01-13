using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore;

namespace litTrack.Services.Database;

public partial class _210078Context : DbContext
{
    public _210078Context()
    {
    }

    public _210078Context(DbContextOptions<_210078Context> options)
        : base(options)
    {
    }

    public virtual DbSet<Arhiva> Arhivas { get; set; }

    public virtual DbSet<Autor> Autors { get; set; }

    public virtual DbSet<CiljnaGrupa> CiljnaGrupas { get; set; }

    public virtual DbSet<Knjiga> Knjigas { get; set; }

    public virtual DbSet<KnjigaCiljnaGrupa> KnjigaCiljnaGrupas { get; set; }

    public virtual DbSet<KnjigaZanr> KnjigaZanrs { get; set; }

    public virtual DbSet<Korisnik> Korisniks { get; set; }

    public virtual DbSet<KorisnikUloga> KorisnikUlogas { get; set; }

    public virtual DbSet<LicnaPreporuka> LicnaPreporukas { get; set; }

    public virtual DbSet<LicnaPreporukaKnjiga> LicnaPreporukaKnjigas { get; set; }

    public virtual DbSet<MojaListum> MojaLista { get; set; }

    public virtual DbSet<NacinPlacanja> NacinPlacanjas { get; set; }

    public virtual DbSet<Narudzba> Narudzbas { get; set; }

    public virtual DbSet<Obavijest> Obavijests { get; set; }

    public virtual DbSet<Ocjena> Ocjenas { get; set; }

    public virtual DbSet<Preporuka> Preporukas { get; set; }

    public virtual DbSet<Recenzija> Recenzijas { get; set; }

    public virtual DbSet<RecenzijaOdgovor> RecenzijaOdgovors { get; set; }

    public virtual DbSet<RecenzijaOdgovorReakcija> RecenzijaOdgovorReakcijas { get; set; }

    public virtual DbSet<RecenzijaReakcija> RecenzijaReakcijas { get; set; }

    public virtual DbSet<StavkaNarudzbe> StavkaNarudzbes { get; set; }

    public virtual DbSet<Uloga> Ulogas { get; set; }

    public virtual DbSet<Zanr> Zanrs { get; set; }

    //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
//#warning To protect potentially sensitive information in your connection string, you should move it out of source code. You can avoid scaffolding the connection string by using the Name= syntax to read it from configuration - see https://go.microsoft.com/fwlink/?linkid=2131148. For more guidance on storing connection strings, see http://go.microsoft.com/fwlink/?LinkId=723263.
 //       => optionsBuilder.UseSqlServer("Data Source=localhost, 1433;Initial Catalog=210078; user=sa; Password=littrackrs2; TrustServerCertificate=True");

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Arhiva>(entity =>
        {
            entity.HasKey(e => e.ArhivaId).HasName("PK__Arhiva__A791E50CEDF81B55");

            entity.ToTable("Arhiva");

            entity.Property(e => e.DatumDodavanja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.Arhivas)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Arhiva__KnjigaId__787EE5A0");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Arhivas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Arhiva__Korisnik__778AC167");
        });

        modelBuilder.Entity<Autor>(entity =>
        {
            entity.HasKey(e => e.AutorId).HasName("PK__Autor__F58AE929C01DC9E3");

            entity.ToTable("Autor");

            entity.Property(e => e.Biografija).HasColumnType("text");
            entity.Property(e => e.Ime).HasMaxLength(100);
            entity.Property(e => e.Prezime).HasMaxLength(100);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");
        });

        modelBuilder.Entity<CiljnaGrupa>(entity =>
        {
            entity.HasKey(e => e.CiljnaGrupaId).HasName("PK__CiljnaGr__98C63198BEBC86D0");

            entity.ToTable("CiljnaGrupa");

            entity.Property(e => e.Naziv).HasMaxLength(255);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");
        });

        modelBuilder.Entity<Knjiga>(entity =>
        {
            entity.HasKey(e => e.KnjigaId).HasName("PK__Knjiga__4A1281F35F8B0735");

            entity.ToTable("Knjiga");

            entity.Property(e => e.Cijena).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Naziv).HasMaxLength(255);
            entity.Property(e => e.Opis).HasColumnType("text");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Autor).WithMany(p => p.Knjigas)
                .HasForeignKey(d => d.AutorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Knjiga__AutorId__4CA06362");
        });

        modelBuilder.Entity<KnjigaCiljnaGrupa>(entity =>
        {
            entity.HasKey(e => e.KnjigaCiljnaGrupaId).HasName("PK__KnjigaCi__4EFEF21ACEDB5D78");

            entity.ToTable("KnjigaCiljnaGrupa");

            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.CiljnaGrupa).WithMany(p => p.KnjigaCiljnaGrupas)
                .HasForeignKey(d => d.CiljnaGrupaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KnjigaCil__Ciljn__17F790F9");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.KnjigaCiljnaGrupas)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KnjigaCil__Knjig__18EBB532");
        });

        modelBuilder.Entity<KnjigaZanr>(entity =>
        {
            entity.HasKey(e => e.KnjigaZanrId).HasName("PK__KnjigaZa__C9603E085A499ECB");

            entity.ToTable("KnjigaZanr");

            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.KnjigaZanrs)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KnjigaZan__Knjig__1CBC4616");

            entity.HasOne(d => d.Zanr).WithMany(p => p.KnjigaZanrs)
                .HasForeignKey(d => d.ZanrId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KnjigaZan__ZanrI__1DB06A4F");
        });

        modelBuilder.Entity<Korisnik>(entity =>
        {
            entity.HasKey(e => e.KorisnikId).HasName("PK__Korisnik__80B06D419B1DE257");

            entity.ToTable("Korisnik");

            entity.HasIndex(e => e.KorisnickoIme, "UQ__Korisnik__992E6F92884A89AE").IsUnique();

            entity.HasIndex(e => e.Email, "UQ__Korisnik__A9D10534846D507F").IsUnique();

            entity.Property(e => e.DatumRegistracije)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Email).HasMaxLength(255);
            entity.Property(e => e.Ime).HasMaxLength(100);
            entity.Property(e => e.JeAktivan)
                .IsRequired()
                .HasDefaultValueSql("((1))");
            entity.Property(e => e.KorisnickoIme).HasMaxLength(50);
            entity.Property(e => e.Prezime).HasMaxLength(100);
            entity.Property(e => e.Telefon).HasMaxLength(50);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");
        });

        modelBuilder.Entity<KorisnikUloga>(entity =>
        {
            entity.HasKey(e => e.KorisnikUlogaId).HasName("PK__Korisnik__1608726E1E4EFB68");

            entity.ToTable("KorisnikUloga");

            entity.Property(e => e.DatumDodavanja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.KorisnikUlogas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KorisnikU__Koris__412EB0B6");

            entity.HasOne(d => d.Uloga).WithMany(p => p.KorisnikUlogas)
                .HasForeignKey(d => d.UlogaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__KorisnikU__Uloga__4222D4EF");
        });

        modelBuilder.Entity<LicnaPreporuka>(entity =>
        {
            entity.HasKey(e => e.LicnaPreporukaId).HasName("PK__LicnaPre__661F4B6FB47AC50A");

            entity.ToTable("LicnaPreporuka");

            entity.Property(e => e.DatumPreporuke)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Naslov).HasMaxLength(255);
            entity.Property(e => e.Poruka).HasColumnType("text");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.KorisnikPosiljalac).WithMany(p => p.LicnaPreporukaKorisnikPosiljalacs)
                .HasForeignKey(d => d.KorisnikPosiljalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LicnaPrep__Koris__02FC7413");

            entity.HasOne(d => d.KorisnikPrimalac).WithMany(p => p.LicnaPreporukaKorisnikPrimalacs)
                .HasForeignKey(d => d.KorisnikPrimalacId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LicnaPrep__Koris__03F0984C");
        });

        modelBuilder.Entity<LicnaPreporukaKnjiga>(entity =>
        {
            entity.HasKey(e => e.LicnaPreporukaKnjigaId).HasName("PK__LicnaPre__F239CF61704965BA");

            entity.ToTable("LicnaPreporukaKnjiga");

            entity.Property(e => e.DatumDodavanja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.LicnaPreporukaKnjigas)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LicnaPrep__Knjig__09A971A2");

            entity.HasOne(d => d.LicnaPreporuka).WithMany(p => p.LicnaPreporukaKnjigas)
                .HasForeignKey(d => d.LicnaPreporukaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__LicnaPrep__Licna__0A9D95DB");
        });

        modelBuilder.Entity<MojaListum>(entity =>
        {
            entity.HasKey(e => e.MojaListaId).HasName("PK__MojaList__66014D0C51AC6E88");

            entity.Property(e => e.DatumDodavanja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.MojaLista)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__MojaLista__Knjig__71D1E811");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.MojaLista)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__MojaLista__Koris__70DDC3D8");
        });

        modelBuilder.Entity<NacinPlacanja>(entity =>
        {
            entity.HasKey(e => e.NacinPlacanjaId).HasName("PK__NacinPla__AD0C4729CE104513");

            entity.ToTable("NacinPlacanja");

            entity.Property(e => e.Naziv).HasMaxLength(100);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");
        });

        modelBuilder.Entity<Narudzba>(entity =>
        {
            entity.HasKey(e => e.NarudzbaId).HasName("PK__Narudzba__FBEC1377C971AA25");

            entity.ToTable("Narudzba");

            entity.Property(e => e.DatumNarudzbe)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Sifra).HasMaxLength(100);
            entity.Property(e => e.StateMachine).HasMaxLength(100);
            entity.Property(e => e.UkupnaCijena).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Narudzbas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Narudzba__Korisn__245D67DE");

            entity.HasOne(d => d.NacinPlacanja).WithMany(p => p.Narudzbas)
                .HasForeignKey(d => d.NacinPlacanjaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Narudzba__NacinP__25518C17");
        });

        modelBuilder.Entity<Obavijest>(entity =>
        {
            entity.HasKey(e => e.ObavijestId).HasName("PK__Obavijes__99D330E0C7775465");

            entity.ToTable("Obavijest");

            entity.Property(e => e.DatumObavijesti)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Naslov).HasMaxLength(255);
            entity.Property(e => e.Sadrzaj).HasColumnType("text");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Obavijests)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Obavijest__Koris__0F624AF8");
        });

        modelBuilder.Entity<Ocjena>(entity =>
        {
            entity.HasKey(e => e.OcjenaId).HasName("PK__Ocjena__E6FC7AA976F0339E");

            entity.ToTable("Ocjena");

            entity.Property(e => e.DatumOcjenjivanja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.Ocjenas)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ocjena__KnjigaId__5165187F");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Ocjenas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Ocjena__Korisnik__52593CB8");
        });

        modelBuilder.Entity<Preporuka>(entity =>
        {
            entity.HasKey(e => e.PreporukaId).HasName("PK__Preporuk__6AE7EE0836B67ED2");

            entity.ToTable("Preporuka");

            entity.Property(e => e.DatumPreporuke)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.Preporukas)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Preporuka__Knjig__7E37BEF6");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Preporukas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Preporuka__Koris__7D439ABD");
        });

        modelBuilder.Entity<Recenzija>(entity =>
        {
            entity.HasKey(e => e.RecenzijaId).HasName("PK__Recenzij__D36C60706A202B0F");

            entity.ToTable("Recenzija");

            entity.Property(e => e.DatumDodavanja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Komentar).HasColumnType("text");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.Recenzijas)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Recenzija__Knjig__59063A47");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.Recenzijas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Recenzija__Koris__5812160E");
        });

        modelBuilder.Entity<RecenzijaOdgovor>(entity =>
        {
            entity.HasKey(e => e.RecenzijaOdgovorId).HasName("PK__Recenzij__23922A442E357E94");

            entity.ToTable("RecenzijaOdgovor");

            entity.Property(e => e.DatumDodavanja)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");
            entity.Property(e => e.Komentar).HasColumnType("text");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.RecenzijaOdgovors)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Recenzija__Koris__60A75C0F");

            entity.HasOne(d => d.Recenzija).WithMany(p => p.RecenzijaOdgovors)
                .HasForeignKey(d => d.RecenzijaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Recenzija__Recen__5FB337D6");
        });

        modelBuilder.Entity<RecenzijaOdgovorReakcija>(entity =>
        {
            entity.HasKey(e => e.RecenzijaOdgovorReakcijaId).HasName("PK__Recenzij__BA973BC71C722F2F");

            entity.ToTable("RecenzijaOdgovorReakcija");

            entity.Property(e => e.DatumReakcije)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.RecenzijaOdgovorReakcijas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Recenzija__Koris__6D0D32F4");

            entity.HasOne(d => d.RecenzijaOdgovor).WithMany(p => p.RecenzijaOdgovorReakcijas)
                .HasForeignKey(d => d.RecenzijaOdgovorId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Recenzija__Recen__6C190EBB");
        });

        modelBuilder.Entity<RecenzijaReakcija>(entity =>
        {
            entity.HasKey(e => e.RecenzijaReakcijaId).HasName("PK__Recenzij__7B1C616CADF19167");

            entity.ToTable("RecenzijaReakcija");

            entity.Property(e => e.DatumReakcije)
                .HasDefaultValueSql("(getdate())")
                .HasColumnType("datetime");

            entity.HasOne(d => d.Korisnik).WithMany(p => p.RecenzijaReakcijas)
                .HasForeignKey(d => d.KorisnikId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Recenzija__Koris__68487DD7");

            entity.HasOne(d => d.Recenzija).WithMany(p => p.RecenzijaReakcijas)
                .HasForeignKey(d => d.RecenzijaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__Recenzija__Recen__6754599E");
        });

        modelBuilder.Entity<StavkaNarudzbe>(entity =>
        {
            entity.HasKey(e => e.StavkaNarudzbeId).HasName("PK__StavkaNa__39E50D70A9D88EC6");

            entity.ToTable("StavkaNarudzbe");

            entity.Property(e => e.Cijena).HasColumnType("decimal(10, 2)");
            entity.Property(e => e.Kolicina).HasDefaultValueSql("((1))");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");

            entity.HasOne(d => d.Knjiga).WithMany(p => p.StavkaNarudzbes)
                .HasForeignKey(d => d.KnjigaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__StavkaNar__Knjig__2BFE89A6");

            entity.HasOne(d => d.Narudzba).WithMany(p => p.StavkaNarudzbes)
                .HasForeignKey(d => d.NarudzbaId)
                .OnDelete(DeleteBehavior.ClientSetNull)
                .HasConstraintName("FK__StavkaNar__Narud__2B0A656D");
        });

        modelBuilder.Entity<Uloga>(entity =>
        {
            entity.HasKey(e => e.UlogaId).HasName("PK__Uloga__DCAB23CB383B19E2");

            entity.ToTable("Uloga");

            entity.Property(e => e.Naziv).HasMaxLength(50);
            entity.Property(e => e.Opis).HasMaxLength(255);
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");
        });

        modelBuilder.Entity<Zanr>(entity =>
        {
            entity.HasKey(e => e.ZanrId).HasName("PK__Zanr__953868D3C3D2169D");

            entity.ToTable("Zanr");

            entity.Property(e => e.Naziv).HasMaxLength(100);
            entity.Property(e => e.Opis).HasColumnType("text");
            entity.Property(e => e.VrijemeBrisanja).HasColumnType("datetime");
        });

        try
        {
            Console.WriteLine("Seed podataka");
            modelBuilder.Seed();
        }
        catch (Exception ex)
        {
            Console.WriteLine("Greška prilikom seedanja:");
            Console.WriteLine(ex.ToString());
        }

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}

public static class ModelBuilderExtensions
{
    public static void Seed(this ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Autor>().HasData(
             new Autor { AutorId = 1, Ime = "Ivo", Prezime = "Andrić", Biografija = "Ivo Andrić (1892 - 1975) bio je bosanskohercegovački i jugoslovenski književnik, dobitnik Nobelove nagrade za književnost 1961. godine.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 2, Ime = "Meša", Prezime = "Selimović", Biografija = "Meša Selimović (1910 - 1982) bio je jedan od najznačajnijih pisaca jugoslovenske književnosti 20. vijeka.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 3, Ime = "Mak", Prezime = "Dizdar", Biografija = "Mak Dizdar (1917 - 1971) bio je bosanskohercegovački pjesnik, poznat po snažnom oslanjanju na srednjovijekovne stećke i bosansku duhovnu tradiciju.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 4, Ime = "William", Prezime = "Shakespeare", Biografija = "William Shakespeare (1564 - 1616) bio je engleski pjesnik i dramatičar, često smatran najvećim piscem na engleskom jeziku.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 5, Ime = "Fjodor", Prezime = "Dostojevski", Biografija = "Fjodor Dostojevski (1821 - 1881) bio je ruski romanopisac i filozof, koji je duboko istraživao ljudsku psihologiju, moralne dileme i pitanje slobodne volje.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 6, Ime = "Jane", Prezime = "Austen", Biografija = "Jane Austen (1775 - 1817) bila je engleska spisateljica poznata po realističnim romanima o društvu i braku u engleskoj provinciji.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 7, Ime = "George", Prezime = "Orwell", Biografija = "George Orwell (1903 - 1950) bio je Britanski pisac i novinar. Najpoznatiji je po romanima 1984 i Životinjska farma.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 8, Ime = "J.K.", Prezime = "Rowling", Biografija = "J.K. Rowling (rođena 1965) britanska je autorica najpoznatija po serijalu Harry Potter.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 9, Ime = "Dan", Prezime = "Brown", Biografija = "Dan Brown (rođen 1964) je američki pisac trilera, najpoznatiji po romanu Da Vincijev kod.", IsDeleted = false, VrijemeBrisanja = null },
             new Autor { AutorId = 10, Ime = "Paulo", Prezime = "Coelho", Biografija = "Paolo Coelho ( rođen 1947) je brazilski pisac čije knjige imaju snažnu duhovnu i motivacijsku dimenziju.", IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<CiljnaGrupa>().HasData(
             new CiljnaGrupa { CiljnaGrupaId = 1, Naziv = "Djeca", IsDeleted = false, VrijemeBrisanja = null },
             new CiljnaGrupa { CiljnaGrupaId = 2, Naziv = "Tinejdžeri", IsDeleted = false, VrijemeBrisanja = null },
             new CiljnaGrupa { CiljnaGrupaId = 3, Naziv = "Odrasli", IsDeleted = false, VrijemeBrisanja = null },
             new CiljnaGrupa { CiljnaGrupaId = 4, Naziv = "Mladi", IsDeleted = false, VrijemeBrisanja = null },
             new CiljnaGrupa { CiljnaGrupaId = 5, Naziv = "Studenti", IsDeleted = false, VrijemeBrisanja = null },
             new CiljnaGrupa { CiljnaGrupaId = 6, Naziv = "Porodično čitanje", IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<Zanr>().HasData(
            new Zanr { ZanrId = 1, Naziv = "Roman", Opis = "Prozna književna forma dužeg obima koja prati likove kroz složen zaplet i razvoj.", Slika = null, IsDeleted = false, VrijemeBrisanja = null },
            new Zanr { ZanrId = 2, Naziv = "Drama", Opis = "Književna vrsta namijenjena izvođenju na sceni, fokusirana na sukob likova. Radnja se razvija kroz dijalog i scenske napomene.", Slika = null, IsDeleted = false, VrijemeBrisanja = null },
            new Zanr { ZanrId = 3, Naziv = "Poezija", Opis = "Književna forma koja koristi ritam, rimu i slikovit jezik za izražavanje osjećanja i misli.", Slika = null, IsDeleted = false, VrijemeBrisanja = null },
            new Zanr { ZanrId = 4, Naziv = "Triler", Opis = "Napeta i uzbudljiva književna forma puna iznenađenja. Ima za cilj držati čitaoca u iščekivanju.", Slika = null, IsDeleted = false, VrijemeBrisanja = null },
            new Zanr { ZanrId = 5, Naziv = "Fantastika", Opis = "Djela u kojima se pojavljuju natprirodni elementi, magija i izmišljeni svjetovi.", Slika = null, IsDeleted = false, VrijemeBrisanja = null },
            new Zanr { ZanrId = 6, Naziv = "Naučna fantastika", Opis = "Književni žanr zasnovan na naučnim ili tehnološkim idejama i budućim mogućnostima.", Slika = null, IsDeleted = false, VrijemeBrisanja = null },
            new Zanr { ZanrId = 7, Naziv = "Kriminalistički", Opis = "Radnja se vrti oko zločina, istrage i razotkrivanje počinioca.", Slika = null, IsDeleted = false, VrijemeBrisanja = null },
            new Zanr { ZanrId = 8, Naziv = "Ljubavni", Opis = "Žanr sa fokusom na romantične odnose i emocije između likova.", Slika = null, IsDeleted = false, VrijemeBrisanja = null },
            new Zanr { ZanrId = 9, Naziv = "Historijski", Opis = "Radnja smještena u prošlost. Žanr povezan sa stvarnim historijskim događajima ili periodima.", Slika = null, IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<Uloga>().HasData(
            new Uloga { UlogaId = 1, Naziv = "Admin", Opis = "Administrator LitTrack aplikacije.", IsDeleted = false, VrijemeBrisanja = null },
            new Uloga { UlogaId = 2, Naziv = "Radnik", Opis = "Radnik koji upravlja narudžbama u LitTrack aplikaciji.", IsDeleted = false, VrijemeBrisanja = null },
            new Uloga { UlogaId = 3, Naziv = "Korisnik", Opis = "Korisnik LitTrack aplikacije.", IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<Korisnik>().HasData(
            new Korisnik
            {
                KorisnikId = 1,
                Ime = "Admin",
                Prezime = "Admin",
                KorisnickoIme = "admin",
                Email = "admin@gmail.com",
                Telefon = "+061123123",
                LozinkaSalt = "9sbhiWrjAErHS+tLC9DcOg==",
                LozinkaHash = "p8HBu5IH77NBN6VEpuNX7RK+bRbiMTg6vfvAYQrh+Rs=",
                JeAktivan = true,
                DatumRegistracije = new DateTime(2025, 1, 1, 9, 0, 0, 0),
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Korisnik
            {
                KorisnikId = 2,
                Ime = "Radnik",
                Prezime = "Radnik",
                KorisnickoIme = "radnik",
                Email = "radnik@gmail.com",
                Telefon = "+061123124",
                LozinkaSalt = "9sbhiWrjAErHS+tLC9DcOg==",
                LozinkaHash = "p8HBu5IH77NBN6VEpuNX7RK+bRbiMTg6vfvAYQrh+Rs=",
                JeAktivan = true,
                DatumRegistracije = new DateTime(2025, 1, 1, 9, 0, 0, 0),
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Korisnik
            {
                KorisnikId = 3,
                Ime = "Korisnik",
                Prezime = "Korisnik",
                KorisnickoIme = "korisnik",
                Email = "korisnik@gmail.com",
                Telefon = "+061123125",
                LozinkaSalt = "9sbhiWrjAErHS+tLC9DcOg==",
                LozinkaHash = "p8HBu5IH77NBN6VEpuNX7RK+bRbiMTg6vfvAYQrh+Rs=",
                JeAktivan = true,
                DatumRegistracije = new DateTime(2025, 1, 1, 9, 0, 0, 0),
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Korisnik
            {
                KorisnikId = 4,
                Ime = "Korisnik",
                Prezime = "KorisnikDva",
                KorisnickoIme = "korisnik2",
                Email = "korisnik2@gmail.com",
                Telefon = "+061123126",
                LozinkaSalt = "9sbhiWrjAErHS+tLC9DcOg==",
                LozinkaHash = "p8HBu5IH77NBN6VEpuNX7RK+bRbiMTg6vfvAYQrh+Rs=",
                JeAktivan = true,
                DatumRegistracije = new DateTime(2025, 1, 1, 9, 0, 0, 0),
                IsDeleted = false,
                VrijemeBrisanja = null
            }
        );

        modelBuilder.Entity<KorisnikUloga>().HasData(
            new KorisnikUloga { KorisnikUlogaId = 1, KorisnikId = 1, UlogaId = 1, DatumDodavanja = new DateTime(2025, 1, 1, 9, 0, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new KorisnikUloga { KorisnikUlogaId = 2, KorisnikId = 2, UlogaId = 2, DatumDodavanja = new DateTime(2025, 1, 1, 9, 0, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new KorisnikUloga { KorisnikUlogaId = 3, KorisnikId = 3, UlogaId = 3, DatumDodavanja = new DateTime(2025, 1, 1, 9, 0, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new KorisnikUloga { KorisnikUlogaId = 4, KorisnikId = 4, UlogaId = 3, DatumDodavanja = new DateTime(2025, 1, 1, 9, 0, 0, 0), IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<NacinPlacanja>().HasData(
            new NacinPlacanja { NacinPlacanjaId = 1, Naziv = "Gotovina", IsDeleted = false, VrijemeBrisanja = null },
            new NacinPlacanja { NacinPlacanjaId = 2, Naziv = "Paypal", IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<Knjiga>().HasData(
            new Knjiga { KnjigaId = 1, Naziv = "Na Drini ćuprija", Opis = "Historijski roman koji prati sudbinu ljudi oko višegradske ćuprije kroz više stoljeća. Djelo snažno prikazuje uticaj velikih istorijskih događaja na živote običnih ljudi i trajnu borbu između prolaznosti i postojanosti.", GodinaIzdavanja = 1945, AutorId = 1, Slika = null, Cijena = 25, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 2, Naziv = "Prokleta avlija", Opis = "Psihološki roman smješten u zatvorsko okruženje koji kroz razgovore zatvorenika razotkriva ljudske sudbine. Kroz sudbinu glavnog lika istražuju se teme pravde, krivice i ljudske nemoći.", GodinaIzdavanja = 1954, AutorId = 1, Slika = null, Cijena = 20, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 3, Naziv = "Derviš i smrt", Opis = "Filozofski roman o unutrašnjoj borbi čovjeka suočenog s nepravdom i vlastitim uvjerenjima. Djelo postavlja pitanja o moralu, vjeri i smislu života u svijetu punom proturječja.", GodinaIzdavanja = 1966, AutorId = 2, Slika = null, Cijena = 23, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 4, Naziv = "Tvrđava", Opis = "Roman koji prikazuje posljedice rata na pojedinca i društvo. Kroz sudbinu glavnog junaka istražuju se nada, razočaranje i snaga ljudskog duha.", GodinaIzdavanja = 1970, AutorId = 2, Slika = null, Cijena = 21, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 5, Naziv = "Kameni spavač", Opis = "Zbirka poezije nadahnuta stećcima i bosanskom srednjovjekovnom baštinom. Pjesme progovaraju o prolaznosti, smrti i vječnom traganju za smislom.", GodinaIzdavanja = 1966, AutorId = 3, Slika = null, Cijena = 19, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 6, Naziv = "Hamlet", Opis = "Shakespeareova tragedija o danskom princu koji traga za istinom i pravdom. Djelo istražuje dileme osvete, morala i ljudske savjesti.", GodinaIzdavanja = 1603, AutorId = 4, Slika = null, Cijena = 18, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 7, Naziv = "Romeo i Julija", Opis = "Jedna od najpoznatijih ljubavnih tragedija o dvoje mladih čija je ljubav jača od mržnje njihovih porodica. Priča o strasti, žrtvi i tragičnoj sudbini.", GodinaIzdavanja = 1597, AutorId = 4, Slika = null, Cijena = 17, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 8, Naziv = "Zločin i kazna", Opis = "Roman koji duboko istražuje ljudsku savjest, krivicu i iskupljenje. Prati psihološku borbu čovjeka koji pokušava opravdati vlastiti zločin.", GodinaIzdavanja = 1866, AutorId = 5, Slika = null, Cijena = 24, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 9, Naziv = "Braća Karamazovi", Opis = "Porodična saga i filozofska drama o vjeri, moralu i slobodi izbora. Kroz sudbinu braće Karamazov razotkriva se kompleksnost ljudske prirode.", GodinaIzdavanja = 1880, AutorId = 5, Slika = null, Cijena = 26, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 10, Naziv = "Ponos i predrasude", Opis = "Klasični roman o ljubavi, društvenim normama i predrasudama engleskog društva. Prati emocionalni razvoj Elizabeth Bennet i gospodina Darcyja.", GodinaIzdavanja = 1813, AutorId = 6, Slika = null, Cijena = 19, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 11, Naziv = "1984", Opis = "Distopijski roman koji prikazuje totalitarno društvo pod stalnim nadzorom. Djelo upozorava na opasnosti gubitka slobode i manipulacije istinom.", GodinaIzdavanja = 1949, AutorId = 7, Slika = null, Cijena = 22, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 12, Naziv = "Životinjska farma", Opis = "Politička satira koja kroz priču o životinjama kritikuje društvene i političke sisteme. Djelo snažno prikazuje zloupotrebu moći i izdaju ideala.", GodinaIzdavanja = 1945, AutorId = 7, Slika = null, Cijena = 16, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 13, Naziv = "Harry Potter i Kamen mudraca", Opis = "Fantastična avantura o dječaku čarobnjaku koji otkriva svoj pravi identitet. Početak slavnog serijala o prijateljstvu, hrabrosti i borbi dobra i zla.", GodinaIzdavanja = 1997, AutorId = 8, Slika = null, Cijena = 30, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 14, Naziv = "Harry Potter i Odaja tajni", Opis = "Drugi dio serijala donosi novu misteriju u Hogwartsu. Harry i njegovi prijatelji suočavaju se s opasnom tajnom iz prošlosti škole.", GodinaIzdavanja = 1998, AutorId = 8, Slika = null, Cijena = 30, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 15, Naziv = "Da Vincijev kod", Opis = "Napeti triler o tajnim društvima, simbolima i drevnim misterijama. Roman povezuje istoriju, religiju i savremeni svijet u jednu uzbudljivu priču.", GodinaIzdavanja = 2003, AutorId = 9, Slika = null, Cijena = 27, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 16, Naziv = "Anđeli i demoni", Opis = "Triler smješten u Vatikan koji kombinuje nauku, religiju i zavjeru. Glavni junak pokušava spriječiti katastrofu koja prijeti cijelom svijetu.", GodinaIzdavanja = 2000, AutorId = 9, Slika = null, Cijena = 26, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 17, Naziv = "Alhemičar", Opis = "Filozofski roman o potrazi za ličnom sudbinom i snovima. Kroz putovanje mladog pastira istražuje se smisao života i važnost slijeđenja srca.", GodinaIzdavanja = 1988, AutorId = 10, Slika = null, Cijena = 20, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 18, Naziv = "Jedanaest minuta", Opis = "Roman o ljubavi, strasti i pronalasku vlastitog identiteta. Djelo se bavi pitanjima intime, slobode i emocionalne povezanosti.", GodinaIzdavanja = 2003, AutorId = 10, Slika = null, Cijena = 21, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 19, Naziv = "Inferno", Opis = "Savremeni triler koji spaja umjetnost, istoriju i opasnu zavjeru. Glavni junak pokušava spriječiti katastrofalni plan koji prijeti čovječanstvu.", GodinaIzdavanja = 2013, AutorId = 9, Slika = null, Cijena = 28, IsDeleted = false, VrijemeBrisanja = null },
            new Knjiga { KnjigaId = 20, Naziv = "Zapis o vremenu", Opis = "Zbirka eseja i refleksija o društvu, kulturi i prolaznosti vremena. Djelo nudi duboka razmišljanja o čovjeku i njegovom mjestu u svijetu.", GodinaIzdavanja = 1975, AutorId = 3, Slika = null, Cijena = 16, IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<KnjigaCiljnaGrupa>().HasData(
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 1, KnjigaId = 1, CiljnaGrupaId = 2, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 2, KnjigaId = 1, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 3, KnjigaId = 1, CiljnaGrupaId = 4, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 4, KnjigaId = 1, CiljnaGrupaId = 5, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 5, KnjigaId = 2, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 6, KnjigaId = 3, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 7, KnjigaId = 3, CiljnaGrupaId = 4, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 8, KnjigaId = 4, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 9, KnjigaId = 4, CiljnaGrupaId = 5, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 10, KnjigaId = 5, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 11, KnjigaId = 5, CiljnaGrupaId = 6, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 12, KnjigaId = 6, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 13, KnjigaId = 7, CiljnaGrupaId = 4, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 14, KnjigaId = 7, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 15, KnjigaId = 8, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 16, KnjigaId = 9, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 17, KnjigaId = 9, CiljnaGrupaId = 5, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 18, KnjigaId = 10, CiljnaGrupaId = 4, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 19, KnjigaId = 10, CiljnaGrupaId = 5, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 20, KnjigaId = 11, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 21, KnjigaId = 12, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 22, KnjigaId = 13, CiljnaGrupaId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 23, KnjigaId = 13, CiljnaGrupaId = 2, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 24, KnjigaId = 13, CiljnaGrupaId = 6, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 25, KnjigaId = 14, CiljnaGrupaId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 26, KnjigaId = 14, CiljnaGrupaId = 2, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 27, KnjigaId = 15, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 28, KnjigaId = 16, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 29, KnjigaId = 17, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 30, KnjigaId = 17, CiljnaGrupaId = 5, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 31, KnjigaId = 18, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 32, KnjigaId = 18, CiljnaGrupaId = 4, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 33, KnjigaId = 19, CiljnaGrupaId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaCiljnaGrupa { KnjigaCiljnaGrupaId = 34, KnjigaId = 20, CiljnaGrupaId = 5, IsDeleted = false, VrijemeBrisanja = null }
        );


        modelBuilder.Entity<KnjigaZanr>().HasData(
            new KnjigaZanr { KnjigaZanrId = 1, KnjigaId = 1, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 2, KnjigaId = 1, ZanrId = 9, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 3, KnjigaId = 2, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 4, KnjigaId = 3, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 5, KnjigaId = 3, ZanrId = 9, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 6, KnjigaId = 4, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 7, KnjigaId = 5, ZanrId = 3, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 8, KnjigaId = 6, ZanrId = 2, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 9, KnjigaId = 7, ZanrId = 2, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 10, KnjigaId = 7, ZanrId = 8, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 11, KnjigaId = 8, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 12, KnjigaId = 9, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 13, KnjigaId = 10, ZanrId = 8, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 14, KnjigaId = 11, ZanrId = 6, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 15, KnjigaId = 12, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 16, KnjigaId = 12, ZanrId = 7, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 17, KnjigaId = 13, ZanrId = 5, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 18, KnjigaId = 13, ZanrId = 6, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 19, KnjigaId = 14, ZanrId = 5, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 20, KnjigaId = 15, ZanrId = 4, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 21, KnjigaId = 15, ZanrId = 7, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 22, KnjigaId = 16, ZanrId = 4, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 23, KnjigaId = 17, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 24, KnjigaId = 17, ZanrId = 8, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 25, KnjigaId = 18, ZanrId = 1, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 26, KnjigaId = 19, ZanrId = 4, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 27, KnjigaId = 19, ZanrId = 7, IsDeleted = false, VrijemeBrisanja = null },
            new KnjigaZanr { KnjigaZanrId = 28, KnjigaId = 20, ZanrId = 3, IsDeleted = false, VrijemeBrisanja = null }
        );


        modelBuilder.Entity<MojaListum>().HasData(
            new MojaListum { MojaListaId = 1, KorisnikId = 3, KnjigaId = 1, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 1, 10, 0, 0, 120), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 2, KorisnikId = 3, KnjigaId = 2, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 2, 10, 0, 0, 130), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 3, KorisnikId = 3, KnjigaId = 3, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 3, 10, 0, 0, 140), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 4, KorisnikId = 3, KnjigaId = 4, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 4, 10, 0, 0, 150), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 5, KorisnikId = 3, KnjigaId = 5, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 5, 10, 0, 0, 160), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 6, KorisnikId = 3, KnjigaId = 6, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 6, 10, 0, 0, 170), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 7, KorisnikId = 3, KnjigaId = 7, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 7, 10, 0, 0, 180), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 8, KorisnikId = 3, KnjigaId = 15, JeProcitana = false, DatumDodavanja = new DateTime(2025, 2, 8, 10, 0, 0, 190), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 9, KorisnikId = 3, KnjigaId = 13, JeProcitana = false, DatumDodavanja = new DateTime(2025, 2, 9, 10, 0, 0, 200), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 10, KorisnikId = 3, KnjigaId = 14, JeProcitana = false, DatumDodavanja = new DateTime(2025, 2, 10, 10, 0, 0, 210), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 11, KorisnikId = 4, KnjigaId = 1, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 1, 9, 0, 0, 120), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 12, KorisnikId = 4, KnjigaId = 2, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 2, 9, 0, 0, 130), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 13, KorisnikId = 4, KnjigaId = 3, JeProcitana = false, DatumDodavanja = new DateTime(2025, 2, 3, 9, 0, 0, 140), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 14, KorisnikId = 4, KnjigaId = 4, JeProcitana = false, DatumDodavanja = new DateTime(2025, 2, 4, 9, 0, 0, 150), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 15, KorisnikId = 4, KnjigaId = 5, JeProcitana = false, DatumDodavanja = new DateTime(2025, 2, 5, 9, 0, 0, 160), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 16, KorisnikId = 4, KnjigaId = 8, JeProcitana = false, DatumDodavanja = new DateTime(2025, 2, 6, 9, 0, 0, 170), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 17, KorisnikId = 4, KnjigaId = 9, JeProcitana = false, DatumDodavanja = new DateTime(2025, 2, 7, 9, 0, 0, 180), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 18, KorisnikId = 4, KnjigaId = 13, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 8, 9, 0, 0, 190), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 19, KorisnikId = 4, KnjigaId = 14, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 9, 9, 0, 0, 200), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 20, KorisnikId = 4, KnjigaId = 15, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 10, 9, 0, 0, 210), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 21, KorisnikId = 4, KnjigaId = 16, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 11, 9, 0, 0, 220), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 22, KorisnikId = 4, KnjigaId = 17, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 12, 9, 0, 0, 220), IsDeleted = false, VrijemeBrisanja = null },
            new MojaListum { MojaListaId = 23, KorisnikId = 4, KnjigaId = 19, JeProcitana = true, DatumDodavanja = new DateTime(2025, 2, 12, 9, 0, 0, 220), IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<Arhiva>().HasData(
            new Arhiva { ArhivaId = 1, KorisnikId = 3, KnjigaId = 1, DatumDodavanja = new DateTime(2025, 2, 10, 10, 0, 0, 110), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 2, KorisnikId = 3, KnjigaId = 2, DatumDodavanja = new DateTime(2025, 2, 11, 10, 0, 0, 120), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 3, KorisnikId = 3, KnjigaId = 3, DatumDodavanja = new DateTime(2025, 2, 12, 10, 0, 0, 130), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 4, KorisnikId = 3, KnjigaId = 4, DatumDodavanja = new DateTime(2025, 2, 13, 10, 0, 0, 140), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 5, KorisnikId = 3, KnjigaId = 7, DatumDodavanja = new DateTime(2025, 2, 14, 10, 0, 0, 150), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 6, KorisnikId = 3, KnjigaId = 13, DatumDodavanja = new DateTime(2025, 2, 15, 10, 0, 0, 160), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 7, KorisnikId = 3, KnjigaId = 14, DatumDodavanja = new DateTime(2025, 2, 16, 10, 0, 0, 170), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 8, KorisnikId = 3, KnjigaId = 17, DatumDodavanja = new DateTime(2025, 2, 17, 10, 0, 0, 180), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 9, KorisnikId = 4, KnjigaId = 1, DatumDodavanja = new DateTime(2025, 2, 10, 9, 0, 0, 110), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 10, KorisnikId = 4, KnjigaId = 2, DatumDodavanja = new DateTime(2025, 2, 11, 9, 0, 0, 120), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 11, KorisnikId = 4, KnjigaId = 3, DatumDodavanja = new DateTime(2025, 2, 12, 9, 0, 0, 130), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 12, KorisnikId = 4, KnjigaId = 14, DatumDodavanja = new DateTime(2025, 2, 13, 9, 0, 0, 140), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 13, KorisnikId = 4, KnjigaId = 15, DatumDodavanja = new DateTime(2025, 2, 14, 9, 0, 0, 150), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 14, KorisnikId = 4, KnjigaId = 16, DatumDodavanja = new DateTime(2025, 2, 15, 9, 0, 0, 160), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 15, KorisnikId = 4, KnjigaId = 18, DatumDodavanja = new DateTime(2025, 2, 16, 9, 0, 0, 170), IsDeleted = false, VrijemeBrisanja = null },
            new Arhiva { ArhivaId = 16, KorisnikId = 4, KnjigaId = 19, DatumDodavanja = new DateTime(2025, 2, 17, 9, 0, 0, 180), IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<LicnaPreporuka>().HasData(
            new LicnaPreporuka { LicnaPreporukaId = 1, KorisnikPosiljalacId = 3, KorisnikPrimalacId = 4, DatumPreporuke = new DateTime(2025, 2, 7, 10, 0, 0), Naslov = "Odlične knjige", Poruka = "Ove knjige su mi se baš dopale, nadam se da ćeš ih i ti pročitati.", JePogledana = true, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 2, KorisnikPosiljalacId = 3, KorisnikPrimalacId = 4, DatumPreporuke = new DateTime(2025, 2, 8, 10, 0, 0), Naslov = "Preporuka", Poruka = "Vrijedi pročitati, mene su zabavile.", JePogledana = false, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 3, KorisnikPosiljalacId = 3, KorisnikPrimalacId = 4, DatumPreporuke = new DateTime(2025, 2, 9, 10, 0, 0), Naslov = "Top knjige", Poruka = "Super štivo za vikend kada budeš imao slobodnog vremena.", JePogledana = true, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 4, KorisnikPosiljalacId = 3, KorisnikPrimalacId = 4, DatumPreporuke = new DateTime(2025, 2, 10, 10, 0, 0), Naslov = "Knjiški savjet", Poruka = "Mislim da će ti se svidjeti.", JePogledana = false, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 5, KorisnikPosiljalacId = 3, KorisnikPrimalacId = 4, DatumPreporuke = new DateTime(2025, 2, 11, 10, 0, 0), Naslov = "Još jedna preporuka", Poruka = "Vrijedi pažnje, dosta ljudi ih je pohvalilo.", JePogledana = true, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 6, KorisnikPosiljalacId = 4, KorisnikPrimalacId = 3, DatumPreporuke = new DateTime(2025, 2, 12, 9, 0, 0), Naslov = "Moja preporuka", Poruka = "Sjajne knjige.", JePogledana = true, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 7, KorisnikPosiljalacId = 4, KorisnikPrimalacId = 3, DatumPreporuke = new DateTime(2025, 2, 13, 9, 0, 0), Naslov = "Čitaj ovo", Poruka = "Vrhunsko štivo, nećeš se pokajati.", JePogledana = false, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 8, KorisnikPosiljalacId = 4, KorisnikPrimalacId = 3, DatumPreporuke = new DateTime(2025, 2, 14, 9, 0, 0), Naslov = "Preporuka", Poruka = "Obavezno pročitaj.", JePogledana = true, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 9, KorisnikPosiljalacId = 4, KorisnikPrimalacId = 3, DatumPreporuke = new DateTime(2025, 2, 15, 9, 0, 0), Naslov = "Knjiški savjet", Poruka = "Preporučujem ti.", JePogledana = false, IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporuka { LicnaPreporukaId = 10, KorisnikPosiljalacId = 4, KorisnikPrimalacId = 3, DatumPreporuke = new DateTime(2025, 2, 16, 9, 0, 0), Naslov = "Top izbor", Poruka = "Nećeš se pokajati jer su knjige stvarno super.", JePogledana = true, IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<LicnaPreporukaKnjiga>().HasData(
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 1, LicnaPreporukaId = 1, KnjigaId = 1, DatumDodavanja = new DateTime(2025, 2, 7, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 2, LicnaPreporukaId = 1, KnjigaId = 2, DatumDodavanja = new DateTime(2025, 2, 7, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 3, LicnaPreporukaId = 2, KnjigaId = 3, DatumDodavanja = new DateTime(2025, 2, 8, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 4, LicnaPreporukaId = 3, KnjigaId = 4, DatumDodavanja = new DateTime(2025, 2, 9, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 5, LicnaPreporukaId = 4, KnjigaId = 5, DatumDodavanja = new DateTime(2025, 2, 10, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 6, LicnaPreporukaId = 5, KnjigaId = 6, DatumDodavanja = new DateTime(2025, 2, 11, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 7, LicnaPreporukaId = 5, KnjigaId = 7, DatumDodavanja = new DateTime(2025, 2, 11, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 8, LicnaPreporukaId = 6, KnjigaId = 1, DatumDodavanja = new DateTime(2025, 2, 12, 9, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 9, LicnaPreporukaId = 7, KnjigaId = 2, DatumDodavanja = new DateTime(2025, 2, 13, 9, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 10, LicnaPreporukaId = 8, KnjigaId = 13, DatumDodavanja = new DateTime(2025, 2, 14, 9, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 11, LicnaPreporukaId = 8, KnjigaId = 14, DatumDodavanja = new DateTime(2025, 2, 14, 9, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 12, LicnaPreporukaId = 9, KnjigaId = 15, DatumDodavanja = new DateTime(2025, 2, 15, 9, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 13, LicnaPreporukaId = 10, KnjigaId = 16, DatumDodavanja = new DateTime(2025, 2, 16, 9, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 14, LicnaPreporukaId = 10, KnjigaId = 17, DatumDodavanja = new DateTime(2025, 2, 16, 9, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new LicnaPreporukaKnjiga { LicnaPreporukaKnjigaId = 15, LicnaPreporukaId = 10, KnjigaId = 19, DatumDodavanja = new DateTime(2025, 2, 16, 9, 0, 0), IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<Ocjena>().HasData(
            new Ocjena { OcjenaId = 1, KorisnikId = 3, KnjigaId = 1, Vrijednost = 4, DatumOcjenjivanja = new DateTime(2025, 2, 2, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 2, KorisnikId = 3, KnjigaId = 2, Vrijednost = 5, DatumOcjenjivanja = new DateTime(2025, 2, 3, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 3, KorisnikId = 3, KnjigaId = 3, Vrijednost = 5, DatumOcjenjivanja = new DateTime(2025, 2, 4, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 4, KorisnikId = 3, KnjigaId = 4, Vrijednost = 4, DatumOcjenjivanja = new DateTime(2025, 2, 5, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 5, KorisnikId = 3, KnjigaId = 5, Vrijednost = 3, DatumOcjenjivanja = new DateTime(2025, 2, 6, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 6, KorisnikId = 4, KnjigaId = 1, Vrijednost = 5, DatumOcjenjivanja = new DateTime(2025, 2, 7, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 7, KorisnikId = 4, KnjigaId = 2, Vrijednost = 4, DatumOcjenjivanja = new DateTime(2025, 2, 8, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 8, KorisnikId = 4, KnjigaId = 13, Vrijednost = 5, DatumOcjenjivanja = new DateTime(2025, 2, 9, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 9, KorisnikId = 4, KnjigaId = 14, Vrijednost = 4, DatumOcjenjivanja = new DateTime(2025, 2, 10, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 10, KorisnikId = 4, KnjigaId = 15, Vrijednost = 4, DatumOcjenjivanja = new DateTime(2025, 2, 11, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 11, KorisnikId = 4, KnjigaId = 17, Vrijednost = 5, DatumOcjenjivanja = new DateTime(2025, 2, 12, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Ocjena { OcjenaId = 12, KorisnikId = 4, KnjigaId = 19, Vrijednost = 4, DatumOcjenjivanja = new DateTime(2025, 2, 13, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<Preporuka>().HasData(
            new Preporuka { PreporukaId = 1, KorisnikId = 3, KnjigaId = 1, DatumPreporuke = new DateTime(2025, 1, 1, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 2, KorisnikId = 3, KnjigaId = 2, DatumPreporuke = new DateTime(2025, 1, 2, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 3, KorisnikId = 3, KnjigaId = 3, DatumPreporuke = new DateTime(2025, 1, 3, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 4, KorisnikId = 3, KnjigaId = 4, DatumPreporuke = new DateTime(2025, 1, 4, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 5, KorisnikId = 3, KnjigaId = 6, DatumPreporuke = new DateTime(2025, 1, 5, 12, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 6, KorisnikId = 4, KnjigaId = 1, DatumPreporuke = new DateTime(2025, 1, 6, 11, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 7, KorisnikId = 4, KnjigaId = 13, DatumPreporuke = new DateTime(2025, 1, 7, 11, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 8, KorisnikId = 4, KnjigaId = 14, DatumPreporuke = new DateTime(2025, 1, 8, 11, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 9, KorisnikId = 4, KnjigaId = 15, DatumPreporuke = new DateTime(2025, 1, 9, 11, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 10, KorisnikId = 4, KnjigaId = 17, DatumPreporuke = new DateTime(2025, 1, 10, 11, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new Preporuka { PreporukaId = 11, KorisnikId = 4, KnjigaId = 19, DatumPreporuke = new DateTime(2025, 1, 11, 11, 0, 0), IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<Recenzija>().HasData(
            new Recenzija { RecenzijaId = 1, KorisnikId = 3, KnjigaId = 1, Komentar = "Sjajna knjiga, preporučujem svima!", DatumDodavanja = new DateTime(2025, 1, 1, 13, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 2, KorisnikId = 3, KnjigaId = 2, Komentar = "Odlična knjiga, zaista me oduševila.", DatumDodavanja = new DateTime(2025, 1, 2, 13, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 3, KorisnikId = 3, KnjigaId = 3, Komentar = "Vrhunska knjiga, sve pohvale.", DatumDodavanja = new DateTime(2025, 1, 3, 13, 0, 0), BrojLajkova = 0, BrojDislajkova = 1, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 4, KorisnikId = 3, KnjigaId = 5, Komentar = "Dobar sadržaj, ali očekivao sam više.", DatumDodavanja = new DateTime(2025, 1, 4, 13, 0, 0), BrojLajkova = 0, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 5, KorisnikId = 3, KnjigaId = 7, Komentar = "Fenomenalno štivo, preporuka!", DatumDodavanja = new DateTime(2025, 1, 5, 13, 0, 0), BrojLajkova = 0, BrojDislajkova = 1, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 6, KorisnikId = 4, KnjigaId = 1, Komentar = "Odlična knjiga, uživao sam.", DatumDodavanja = new DateTime(2025, 1, 6, 12, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 7, KorisnikId = 4, KnjigaId = 2, Komentar = "Vrlo zanimljivo štivo.", DatumDodavanja = new DateTime(2025, 1, 7, 12, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 8, KorisnikId = 4, KnjigaId = 13, Komentar = "Sjajan uvod u serijal.", DatumDodavanja = new DateTime(2025, 1, 8, 12, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 9, KorisnikId = 4, KnjigaId = 14, Komentar = "Drugi dio je jednako dobar.", DatumDodavanja = new DateTime(2025, 1, 9, 12, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 10, KorisnikId = 4, KnjigaId = 15, Komentar = "Nije loše, iznenadila me je radnja knjige.", DatumDodavanja = new DateTime(2025, 1, 10, 12, 0, 0), BrojLajkova = 0, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new Recenzija { RecenzijaId = 11, KorisnikId = 4, KnjigaId = 19, Komentar = "Svidjela mi se, vrijedi pročitati bar jednom.", DatumDodavanja = new DateTime(2025, 1, 11, 12, 0, 0), BrojLajkova = 0, BrojDislajkova = 1, IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<RecenzijaReakcija>().HasData(
            new RecenzijaReakcija { RecenzijaReakcijaId = 1, RecenzijaId = 6, KorisnikId = 3, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 6, 14, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaReakcija { RecenzijaReakcijaId = 2, RecenzijaId = 7, KorisnikId = 3, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 7, 14, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaReakcija { RecenzijaReakcijaId = 3, RecenzijaId = 8, KorisnikId = 3, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 8, 14, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaReakcija { RecenzijaReakcijaId = 4, RecenzijaId = 11, KorisnikId = 3, JeLajk = false, DatumReakcije = new DateTime(2025, 1, 11, 14, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaReakcija { RecenzijaReakcijaId = 5, RecenzijaId = 1, KorisnikId = 4, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 1, 15, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaReakcija { RecenzijaReakcijaId = 6, RecenzijaId = 2, KorisnikId = 4, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 2, 15, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaReakcija { RecenzijaReakcijaId = 7, RecenzijaId = 3, KorisnikId = 4, JeLajk = false, DatumReakcije = new DateTime(2025, 1, 3, 15, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaReakcija { RecenzijaReakcijaId = 8, RecenzijaId = 5, KorisnikId = 4, JeLajk = false, DatumReakcije = new DateTime(2025, 1, 5, 15, 0, 0), IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<RecenzijaOdgovor>().HasData(
            new RecenzijaOdgovor { RecenzijaOdgovorId = 1, RecenzijaId = 6, KorisnikId = 3, Komentar = "Da, i meni se stvarno dopala.", DatumDodavanja = new DateTime(2025, 1, 6, 15, 0, 0), BrojLajkova = 0, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 2, RecenzijaId = 7, KorisnikId = 3, Komentar = "Slažem se, meni je super.", DatumDodavanja = new DateTime(2025, 1, 7, 15, 0, 0), BrojLajkova = 0, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 3, RecenzijaId = 8, KorisnikId = 3, Komentar = "Stvarno? Nisam gledao filmove, da li je bolje prvo pročitati knjige?", DatumDodavanja = new DateTime(2025, 1, 8, 15, 0, 0), BrojLajkova = 0, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 4, RecenzijaId = 9, KorisnikId = 3, Komentar = "Jesi li čitao sve knjige redom ili mogu odmah čitati ovu?", DatumDodavanja = new DateTime(2025, 1, 14, 15, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 5, RecenzijaId = 1, KorisnikId = 4, Komentar = "Baš je odlična i meni.", DatumDodavanja = new DateTime(2025, 1, 1, 16, 0, 0), BrojLajkova = 0, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 6, RecenzijaId = 4, KorisnikId = 4, Komentar = "Da li onda bolje da je ne čitam? Planirao sam.", DatumDodavanja = new DateTime(2025, 1, 6, 16, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 7, RecenzijaId = 5, KorisnikId = 4, Komentar = "Baš je želim čitati.", DatumDodavanja = new DateTime(2025, 1, 8, 13, 30, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 8, RecenzijaId = 4, KorisnikId = 3, Komentar = "Nije toliko loša ali nećeš ništa propustiti.", DatumDodavanja = new DateTime(2025, 1, 6, 17, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 9, RecenzijaId = 5, KorisnikId = 3, Komentar = "Definitivno nećeš požaliti.", DatumDodavanja = new DateTime(2025, 1, 8, 14, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 10, RecenzijaId = 8, KorisnikId = 4, Komentar = "I filmovi i knjige su super. Ja sam prvo gledao filmove i opet su mi knjige bile zanimljive.", DatumDodavanja = new DateTime(2025, 1, 8, 16, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 11, RecenzijaId = 9, KorisnikId = 4, Komentar = "Preporučujem da ih čitaš redom.", DatumDodavanja = new DateTime(2025, 1, 14, 16, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovor { RecenzijaOdgovorId = 12, RecenzijaId = 8, KorisnikId = 3, Komentar = "Onda ću i ja tako.", DatumDodavanja = new DateTime(2025, 1, 8, 17, 0, 0), BrojLajkova = 1, BrojDislajkova = 0, IsDeleted = false, VrijemeBrisanja = null }
        );

        modelBuilder.Entity<RecenzijaOdgovorReakcija>().HasData(
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 1, RecenzijaOdgovorId = 6, KorisnikId = 3, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 7, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 2, RecenzijaOdgovorId = 7, KorisnikId = 3, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 8, 10, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 3, RecenzijaOdgovorId = 10, KorisnikId = 3, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 8, 17, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 4, RecenzijaOdgovorId = 11, KorisnikId = 3, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 14, 17, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 5, RecenzijaOdgovorId = 3, KorisnikId = 4, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 8, 16, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 6, RecenzijaOdgovorId = 4, KorisnikId = 4, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 14, 16, 30, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 7, RecenzijaOdgovorId = 8, KorisnikId = 4, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 6, 18, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 8, RecenzijaOdgovorId = 9, KorisnikId = 4, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 8, 15, 0, 0), IsDeleted = false, VrijemeBrisanja = null },
            new RecenzijaOdgovorReakcija { RecenzijaOdgovorReakcijaId = 9, RecenzijaOdgovorId = 12, KorisnikId = 4, JeLajk = true, DatumReakcije = new DateTime(2025, 1, 8, 18, 0, 0), IsDeleted = false, VrijemeBrisanja = null }
        );

        
        modelBuilder.Entity<Narudzba>().HasData(
                new Narudzba { NarudzbaId = 1, KorisnikId = 3, NacinPlacanjaId = 1, Sifra = "NAR-20260101120000-1234", DatumNarudzbe = new DateTime(2026, 1, 1, 12, 0, 0, 123), UkupnaCijena = 25, StateMachine = "kreirana", Adresa = "Mostar, Zalik", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 2, KorisnikId = 3, NacinPlacanjaId = 2, Sifra = "NAR-20260101121000-2345", DatumNarudzbe = new DateTime(2026, 1, 1, 12, 10, 0, 456), UkupnaCijena = 63, StateMachine = "kreirana", Adresa = "Mostar, Centar", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 3, KorisnikId = 3, NacinPlacanjaId = 1, Sifra = "NAR-20260101122000-3456", DatumNarudzbe = new DateTime(2026, 1, 1, 12, 20, 0, 789), UkupnaCijena = 58, StateMachine = "kreirana", Adresa = "Mostar, Bijeli Brijeg", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 4, KorisnikId = 3, NacinPlacanjaId = 2, Sifra = "NAR-20251225100000-4567", DatumNarudzbe = new DateTime(2025, 12, 25, 10, 0, 0, 111), UkupnaCijena = 68, StateMachine = "zavrsena", Adresa = "Mostar, Luka", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 5, KorisnikId = 3, NacinPlacanjaId = 1, Sifra = "NAR-20251226100000-5678", DatumNarudzbe = new DateTime(2025, 12, 26, 10, 0, 0, 222), UkupnaCijena = 21, StateMachine = "ponistena", Adresa = "Mostar, Musala", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 6, KorisnikId = 3, NacinPlacanjaId = 1, Sifra = "NAR-20251227100000-6789", DatumNarudzbe = new DateTime(2025, 12, 27, 10, 0, 0, 333), UkupnaCijena = 37, StateMachine = "uToku", Adresa = "Mostar, Bulevar", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 7, KorisnikId = 3, NacinPlacanjaId = 2, Sifra = "NAR-20251228100000-7890", DatumNarudzbe = new DateTime(2025, 12, 28, 10, 0, 0, 444), UkupnaCijena = 58, StateMachine = "uToku", Adresa = "Mostar, Zalik", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 8, KorisnikId = 3, NacinPlacanjaId = 1, Sifra = "NAR-20251229100000-8901", DatumNarudzbe = new DateTime(2025, 12, 29, 10, 0, 0, 555), UkupnaCijena = 26, StateMachine = "preuzeta", Adresa = "Mostar, Centar", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 9, KorisnikId = 4, NacinPlacanjaId = 1, Sifra = "NAR-20260102100000-9012", DatumNarudzbe = new DateTime(2026, 1, 2, 10, 0, 0, 123), UkupnaCijena = 19, StateMachine = "kreirana", Adresa = "Sarajevo, Stari Grad", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 10, KorisnikId = 4, NacinPlacanjaId = 2, Sifra = "NAR-20260102103000-0123", DatumNarudzbe = new DateTime(2026, 1, 2, 10, 30, 0, 456), UkupnaCijena = 60, StateMachine = "kreirana", Adresa = "Sarajevo, Bistrik", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 11, KorisnikId = 4, NacinPlacanjaId = 1, Sifra = "NAR-20251220100000-1235", DatumNarudzbe = new DateTime(2025, 12, 20, 10, 0, 0, 111), UkupnaCijena = 30, StateMachine = "ponistena", Adresa = "Sarajevo, Marijin Dvor", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 12, KorisnikId = 4, NacinPlacanjaId = 1, Sifra = "NAR-20251221100000-2346", DatumNarudzbe = new DateTime(2025, 12, 21, 10, 0, 0, 222), UkupnaCijena = 60, StateMachine = "ponistena", Adresa = "Sarajevo, Ilidža", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 13, KorisnikId = 4, NacinPlacanjaId = 2, Sifra = "NAR-20251222100000-3457", DatumNarudzbe = new DateTime(2025, 12, 22, 10, 0, 0, 333), UkupnaCijena = 73, StateMachine = "zavrsena", Adresa = "Sarajevo, Dobrinja", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 14, KorisnikId = 4, NacinPlacanjaId = 2, Sifra = "NAR-20251223100000-4568", DatumNarudzbe = new DateTime(2025, 12, 23, 10, 0, 0, 444), UkupnaCijena = 42, StateMachine = "zavrsena", Adresa = "Sarajevo, Vogošća", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 15, KorisnikId = 4, NacinPlacanjaId = 1, Sifra = "NAR-20251224100000-5679", DatumNarudzbe = new DateTime(2025, 12, 24, 10, 0, 0, 555), UkupnaCijena = 44, StateMachine = "zavrsena", Adresa = "Sarajevo, Centar", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 16, KorisnikId = 4, NacinPlacanjaId = 2, Sifra = "NAR-20251225100000-6780", DatumNarudzbe = new DateTime(2025, 12, 25, 10, 0, 0, 666), UkupnaCijena = 25, StateMachine = "uToku", Adresa = "Sarajevo, Grbavica", IsDeleted = false, VrijemeBrisanja = null },
                new Narudzba { NarudzbaId = 17, KorisnikId = 4, NacinPlacanjaId = 1, Sifra = "NAR-20260103000000-7891", DatumNarudzbe = new DateTime(2026, 1, 3, 0, 0, 0, 777), UkupnaCijena = 20, StateMachine = "kreirana", Adresa = "Sarajevo, Ilidža", IsDeleted = false, VrijemeBrisanja = null }
            );

       
        modelBuilder.Entity<StavkaNarudzbe>().HasData(
                new StavkaNarudzbe { StavkaNarudzbeId = 1, NarudzbaId = 1, KnjigaId = 1, Kolicina = 1, Cijena = 25, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 2, NarudzbaId = 2, KnjigaId = 2, Kolicina = 2, Cijena = 20, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 3, NarudzbaId = 2, KnjigaId = 3, Kolicina = 1, Cijena = 23, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 4, NarudzbaId = 3, KnjigaId = 4, Kolicina = 1, Cijena = 21, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 5, NarudzbaId = 3, KnjigaId = 5, Kolicina = 1, Cijena = 19, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 6, NarudzbaId = 3, KnjigaId = 6, Kolicina = 1, Cijena = 18, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 7, NarudzbaId = 4, KnjigaId = 1, Kolicina = 1, Cijena = 25, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 8, NarudzbaId = 4, KnjigaId = 2, Kolicina = 2, Cijena = 20, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 9, NarudzbaId = 4, KnjigaId = 3, Kolicina = 1, Cijena = 23, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 10, NarudzbaId = 5, KnjigaId = 4, Kolicina = 1, Cijena = 21, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 11, NarudzbaId = 6, KnjigaId = 5, Kolicina = 1, Cijena = 19, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 12, NarudzbaId = 6, KnjigaId = 6, Kolicina = 1, Cijena = 18, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 13, NarudzbaId = 7, KnjigaId = 7, Kolicina = 2, Cijena = 17, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 14, NarudzbaId = 7, KnjigaId = 8, Kolicina = 1, Cijena = 24, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 15, NarudzbaId = 8, KnjigaId = 9, Kolicina = 1, Cijena = 26, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 16, NarudzbaId = 9, KnjigaId = 10, Kolicina = 1, Cijena = 19, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 17, NarudzbaId = 10, KnjigaId = 11, Kolicina = 2, Cijena = 22, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 18, NarudzbaId = 10, KnjigaId = 12, Kolicina = 1, Cijena = 16, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 19, NarudzbaId = 11, KnjigaId = 13, Kolicina = 1, Cijena = 30, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 20, NarudzbaId = 12, KnjigaId = 14, Kolicina = 2, Cijena = 30, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 21, NarudzbaId = 13, KnjigaId = 15, Kolicina = 1, Cijena = 27, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 22, NarudzbaId = 13, KnjigaId = 16, Kolicina = 1, Cijena = 26, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 23, NarudzbaId = 13, KnjigaId = 17, Kolicina = 1, Cijena = 20, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 24, NarudzbaId = 14, KnjigaId = 18, Kolicina = 2, Cijena = 21, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 25, NarudzbaId = 15, KnjigaId = 19, Kolicina = 1, Cijena = 28, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 26, NarudzbaId = 15, KnjigaId = 20, Kolicina = 1, Cijena = 16, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 27, NarudzbaId = 16, KnjigaId = 1, Kolicina = 1, Cijena = 25, IsDeleted = false, VrijemeBrisanja = null },
                new StavkaNarudzbe { StavkaNarudzbeId = 28, NarudzbaId = 17, KnjigaId = 2, Kolicina = 1, Cijena = 20, IsDeleted = false, VrijemeBrisanja = null }
            );

        modelBuilder.Entity<Obavijest>().HasData(
            new Obavijest
            {
                ObavijestId = 1,
                KorisnikId = 2,
                Naslov = "Nova narudžba",
                Sadrzaj = "Poštovani, kreirana je nova narudžba broj NAR-20260101120000-1234. Molimo vas da preuzmete narudžbu i krenete sa obradom.",
                DatumObavijesti = new DateTime(2026, 1, 1, 12, 0, 0, 123),
                JePogledana = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Obavijest
            {
                ObavijestId = 2,
                KorisnikId = 2,
                Naslov = "Nova narudžba",
                Sadrzaj = "Poštovani, kreirana je nova narudžba broj NAR-20260101121000-2345. Molimo vas da preuzmete narudžbu i krenete sa obradom.",
                DatumObavijesti = new DateTime(2026, 1, 1, 12, 10, 0, 456),
                JePogledana = false,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Obavijest
            {
                ObavijestId = 3,
                KorisnikId = 2,
                Naslov = "Poništena narudžba",
                Sadrzaj = "Poštovani, narudžba NAR-20251220100000-1235 je poništena.",
                DatumObavijesti = new DateTime(2025, 12, 20, 10, 0, 0, 111),
                JePogledana = false,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Obavijest
            {
                ObavijestId = 4,
                KorisnikId = 2,
                Naslov = "Poništena narudžba",
                Sadrzaj = "Poštovani, narudžba NAR-20260101121000-2345 je poništena.",
                DatumObavijesti = new DateTime(2025, 12, 20, 10, 0, 0, 111),
                JePogledana = false,
                IsDeleted = false,
                VrijemeBrisanja = null
            },

            new Obavijest
            {
                ObavijestId = 5,
                KorisnikId = 3,
                Naslov = "Narudžba je zaprimljena",
                Sadrzaj = "Poštovanje Korisnik,\n\n" +
                          "Vaša narudžba #NAR-20251229100000-8901 je uspješno zaprimljena 29.12.2025. Trenutno je u obradi.\n\n" +
                          "Detalji narudžbe:\n" +
                          "- Broj narudžbe: NAR-20251229100000-8901\n" +
                          "- Kupac: Korisnik Korisnik\n" +
                          "- Datum narudžbe: 29.12.2025 10:00\n" +
                          "- Ukupan iznos: 26 KM\n\n" +
                          "Dalji status narudžbe možete pratiti u sekciji Obavijesti.\n\n" +
                          "Hvala Vam na narudžbi,\nVaš LitTrack tim",
                DatumObavijesti = new DateTime(2025, 12, 29, 10, 0, 0, 555),
                JePogledana = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Obavijest
            {
                ObavijestId = 6,
                KorisnikId = 3,
                Naslov = "Narudžba je poslana",
                Sadrzaj = "Poštovanje Korisnik,\n\n" +
                          "Vaša narudžba #NAR-20251228100000-7890 je uspješno zapakovana i poslana.\n\n" +
                          "Detalji narudžbe:\n" +
                          "- Broj narudžbe: NAR-20251228100000-7890\n" +
                          "- Kupac: Korisnik Korisnik\n" +
                          "- Datum narudžbe: 28.12.2025 10:00\n" +
                          "- Ukupan iznos: 58 KM\n\n" +
                          "Hvala Vam na narudžbi,\nVaš LitTrack tim",
                DatumObavijesti = new DateTime(2025, 12, 28, 10, 0, 0, 444),
                JePogledana = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Obavijest
            {
                ObavijestId = 7,
                KorisnikId = 3,
                Naslov = "Narudžba je poslana",
                Sadrzaj = "Poštovanje Korisnik,\n\n" +
                          "Vaša narudžba #NAR-20251227100000-6789 je uspješno zapakovana i poslana.\n\n" +
                          "Detalji narudžbe:\n" +
                          "- Broj narudžbe: NAR-20251227100000-6789\n" +
                          "- Kupac: Korisnik Korisnik\n" +
                          "- Datum narudžbe: 27.12.2025 10:00\n" +
                          "- Ukupan iznos: 37 KM\n\n" +
                          "Hvala Vam na narudžbi,\nVaš LitTrack tim",
                DatumObavijesti = new DateTime(2025, 12, 27, 10, 0, 0, 333),
                JePogledana = false,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Obavijest
            {
                ObavijestId = 8,
                KorisnikId = 3,
                Naslov = "Moja preporuka",
                Sadrzaj = "Poštovanje Korisnik Korisnik,\n\n" +
                          "Primili ste preporuku od korisnika Korisnik KorisnikDva.\n" +
                          "Naslov preporuke: Moja preporuka\n\n" +
                          "Lijep pozdrav,\nVaš LitTrack tim",
                DatumObavijesti = new DateTime(2025, 2, 12, 9, 0, 0),
                JePogledana = false,
                IsDeleted = false,
                VrijemeBrisanja = null
            },

            new Obavijest
            {
                ObavijestId = 9,
                KorisnikId = 4,
                Naslov = "Narudžba je poslana",
                Sadrzaj = "Poštovanje Korisnik,\n\n" +
                          "Vaša narudžba #NAR-20251225100000-6780 je uspješno zapakovana i poslana.\n\n" +
                          "Detalji narudžbe:\n" +
                          "- Broj narudžbe: NAR-20251225100000-6780\n" +
                          "- Kupac: Korisnik KorisnikDva\n" +
                          "- Datum narudžbe: 25.12.2025 10:00\n" +
                          "- Ukupan iznos: 25 KM\n\n" +
                          "Hvala Vam na narudžbi,\nVaš LitTrack tim",
                DatumObavijesti = new DateTime(2025, 12, 25, 10, 0, 0, 666),
                JePogledana = true,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Obavijest
            {
                ObavijestId = 10,
                KorisnikId = 4,
                Naslov = "Preporuka",
                Sadrzaj = "Poštovanje Korisnik KorisnikDva,\n\n" +
                          "Primili ste preporuku od korisnika Korisnik Korisnik.\n" +
                          "Naslov preporuke: Preporuka\n\n" +
                          "Lijep pozdrav,\nVaš LitTrack tim",
                DatumObavijesti = new DateTime(2025, 2, 8, 10, 0, 0),
                JePogledana = false,
                IsDeleted = false,
                VrijemeBrisanja = null
            },
            new Obavijest
            {
                ObavijestId = 11,
                KorisnikId = 4,
                Naslov = "Odlične knjige",
                Sadrzaj = "Poštovanje Korisnik KorisnikDva,\n\n" +
                          "Primili ste preporuku od korisnika Korisnik Korisnik.\n" +
                          "Naslov preporuke: Odlične knjige\n\n" +
                          "Lijep pozdrav,\nVaš LitTrack tim",
                DatumObavijesti = new DateTime(2025, 2, 7, 10, 0, 0),
                JePogledana = false,
                IsDeleted = false,
                VrijemeBrisanja = null
            }
        );


    }
}
