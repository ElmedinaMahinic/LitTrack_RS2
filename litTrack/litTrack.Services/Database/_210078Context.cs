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

        OnModelCreatingPartial(modelBuilder);
    }

    partial void OnModelCreatingPartial(ModelBuilder modelBuilder);
}
