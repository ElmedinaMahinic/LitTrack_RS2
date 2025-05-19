using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace litTrack.Services.Migrations
{
    /// <inheritdoc />
    public partial class InitialCreate : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Autor",
                columns: table => new
                {
                    AutorId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Biografija = table.Column<string>(type: "text", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Autor__F58AE929C01DC9E3", x => x.AutorId);
                });

            migrationBuilder.CreateTable(
                name: "CiljnaGrupa",
                columns: table => new
                {
                    CiljnaGrupaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__CiljnaGr__98C63198BEBC86D0", x => x.CiljnaGrupaId);
                });

            migrationBuilder.CreateTable(
                name: "Korisnik",
                columns: table => new
                {
                    KorisnikId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Ime = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Prezime = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    KorisnickoIme = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Email = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Telefon = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: true),
                    LozinkaHash = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    LozinkaSalt = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    JeAktivan = table.Column<bool>(type: "bit", nullable: false, defaultValueSql: "((1))"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true),
                    DatumRegistracije = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnik__80B06D419B1DE257", x => x.KorisnikId);
                });

            migrationBuilder.CreateTable(
                name: "NacinPlacanja",
                columns: table => new
                {
                    NacinPlacanjaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__NacinPla__AD0C4729CE104513", x => x.NacinPlacanjaId);
                });

            migrationBuilder.CreateTable(
                name: "Uloga",
                columns: table => new
                {
                    UlogaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(50)", maxLength: 50, nullable: false),
                    Opis = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Uloga__DCAB23CB383B19E2", x => x.UlogaId);
                });

            migrationBuilder.CreateTable(
                name: "Zanr",
                columns: table => new
                {
                    ZanrId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    Opis = table.Column<string>(type: "text", nullable: true),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Zanr__953868D3C3D2169D", x => x.ZanrId);
                });

            migrationBuilder.CreateTable(
                name: "Knjiga",
                columns: table => new
                {
                    KnjigaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    Naziv = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Opis = table.Column<string>(type: "text", nullable: false),
                    GodinaIzdavanja = table.Column<int>(type: "int", nullable: false),
                    AutorId = table.Column<int>(type: "int", nullable: false),
                    Slika = table.Column<byte[]>(type: "varbinary(max)", nullable: true),
                    Cijena = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Knjiga__4A1281F35F8B0735", x => x.KnjigaId);
                    table.ForeignKey(
                        name: "FK__Knjiga__AutorId__4CA06362",
                        column: x => x.AutorId,
                        principalTable: "Autor",
                        principalColumn: "AutorId");
                });

            migrationBuilder.CreateTable(
                name: "LicnaPreporuka",
                columns: table => new
                {
                    LicnaPreporukaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikPosiljalacId = table.Column<int>(type: "int", nullable: false),
                    KorisnikPrimalacId = table.Column<int>(type: "int", nullable: false),
                    DatumPreporuke = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    Naslov = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: true),
                    Poruka = table.Column<string>(type: "text", nullable: true),
                    JePogledana = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__LicnaPre__661F4B6FB47AC50A", x => x.LicnaPreporukaId);
                    table.ForeignKey(
                        name: "FK__LicnaPrep__Koris__02FC7413",
                        column: x => x.KorisnikPosiljalacId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                    table.ForeignKey(
                        name: "FK__LicnaPrep__Koris__03F0984C",
                        column: x => x.KorisnikPrimalacId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "Obavijest",
                columns: table => new
                {
                    ObavijestId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Naslov = table.Column<string>(type: "nvarchar(255)", maxLength: 255, nullable: false),
                    Sadrzaj = table.Column<string>(type: "text", nullable: false),
                    DatumObavijesti = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    JePogledana = table.Column<bool>(type: "bit", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Obavijes__99D330E0C7775465", x => x.ObavijestId);
                    table.ForeignKey(
                        name: "FK__Obavijest__Koris__0F624AF8",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "Narudzba",
                columns: table => new
                {
                    NarudzbaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    NacinPlacanjaId = table.Column<int>(type: "int", nullable: false),
                    Sifra = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: false),
                    DatumNarudzbe = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    UkupnaCijena = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    StateMachine = table.Column<string>(type: "nvarchar(100)", maxLength: 100, nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Narudzba__FBEC1377C971AA25", x => x.NarudzbaId);
                    table.ForeignKey(
                        name: "FK__Narudzba__Korisn__245D67DE",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                    table.ForeignKey(
                        name: "FK__Narudzba__NacinP__25518C17",
                        column: x => x.NacinPlacanjaId,
                        principalTable: "NacinPlacanja",
                        principalColumn: "NacinPlacanjaId");
                });

            migrationBuilder.CreateTable(
                name: "KorisnikUloga",
                columns: table => new
                {
                    KorisnikUlogaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    UlogaId = table.Column<int>(type: "int", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Korisnik__1608726E1E4EFB68", x => x.KorisnikUlogaId);
                    table.ForeignKey(
                        name: "FK__KorisnikU__Koris__412EB0B6",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                    table.ForeignKey(
                        name: "FK__KorisnikU__Uloga__4222D4EF",
                        column: x => x.UlogaId,
                        principalTable: "Uloga",
                        principalColumn: "UlogaId");
                });

            migrationBuilder.CreateTable(
                name: "Arhiva",
                columns: table => new
                {
                    ArhivaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Arhiva__A791E50CEDF81B55", x => x.ArhivaId);
                    table.ForeignKey(
                        name: "FK__Arhiva__KnjigaId__787EE5A0",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FK__Arhiva__Korisnik__778AC167",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "KnjigaCiljnaGrupa",
                columns: table => new
                {
                    KnjigaCiljnaGrupaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    CiljnaGrupaId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__KnjigaCi__4EFEF21ACEDB5D78", x => x.KnjigaCiljnaGrupaId);
                    table.ForeignKey(
                        name: "FK__KnjigaCil__Ciljn__17F790F9",
                        column: x => x.CiljnaGrupaId,
                        principalTable: "CiljnaGrupa",
                        principalColumn: "CiljnaGrupaId");
                    table.ForeignKey(
                        name: "FK__KnjigaCil__Knjig__18EBB532",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                });

            migrationBuilder.CreateTable(
                name: "KnjigaZanr",
                columns: table => new
                {
                    KnjigaZanrId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    ZanrId = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__KnjigaZa__C9603E085A499ECB", x => x.KnjigaZanrId);
                    table.ForeignKey(
                        name: "FK__KnjigaZan__Knjig__1CBC4616",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FK__KnjigaZan__ZanrI__1DB06A4F",
                        column: x => x.ZanrId,
                        principalTable: "Zanr",
                        principalColumn: "ZanrId");
                });

            migrationBuilder.CreateTable(
                name: "MojaLista",
                columns: table => new
                {
                    MojaListaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    JeProcitana = table.Column<bool>(type: "bit", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__MojaList__66014D0C51AC6E88", x => x.MojaListaId);
                    table.ForeignKey(
                        name: "FK__MojaLista__Knjig__71D1E811",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FK__MojaLista__Koris__70DDC3D8",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "Ocjena",
                columns: table => new
                {
                    OcjenaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Vrijednost = table.Column<int>(type: "int", nullable: false),
                    DatumOcjenjivanja = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Ocjena__E6FC7AA976F0339E", x => x.OcjenaId);
                    table.ForeignKey(
                        name: "FK__Ocjena__KnjigaId__5165187F",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FK__Ocjena__Korisnik__52593CB8",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "Preporuka",
                columns: table => new
                {
                    PreporukaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    DatumPreporuke = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Preporuk__6AE7EE0836B67ED2", x => x.PreporukaId);
                    table.ForeignKey(
                        name: "FK__Preporuka__Knjig__7E37BEF6",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FK__Preporuka__Koris__7D439ABD",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "Recenzija",
                columns: table => new
                {
                    RecenzijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    Komentar = table.Column<string>(type: "text", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    BrojLajkova = table.Column<int>(type: "int", nullable: false),
                    BrojDislajkova = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Recenzij__D36C60706A202B0F", x => x.RecenzijaId);
                    table.ForeignKey(
                        name: "FK__Recenzija__Knjig__59063A47",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FK__Recenzija__Koris__5812160E",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                });

            migrationBuilder.CreateTable(
                name: "LicnaPreporukaKnjiga",
                columns: table => new
                {
                    LicnaPreporukaKnjigaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    LicnaPreporukaId = table.Column<int>(type: "int", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__LicnaPre__F239CF61704965BA", x => x.LicnaPreporukaKnjigaId);
                    table.ForeignKey(
                        name: "FK__LicnaPrep__Knjig__09A971A2",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FK__LicnaPrep__Licna__0A9D95DB",
                        column: x => x.LicnaPreporukaId,
                        principalTable: "LicnaPreporuka",
                        principalColumn: "LicnaPreporukaId");
                });

            migrationBuilder.CreateTable(
                name: "StavkaNarudzbe",
                columns: table => new
                {
                    StavkaNarudzbeId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    NarudzbaId = table.Column<int>(type: "int", nullable: false),
                    KnjigaId = table.Column<int>(type: "int", nullable: false),
                    Kolicina = table.Column<int>(type: "int", nullable: false, defaultValueSql: "((1))"),
                    Cijena = table.Column<decimal>(type: "decimal(10,2)", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__StavkaNa__39E50D70A9D88EC6", x => x.StavkaNarudzbeId);
                    table.ForeignKey(
                        name: "FK__StavkaNar__Knjig__2BFE89A6",
                        column: x => x.KnjigaId,
                        principalTable: "Knjiga",
                        principalColumn: "KnjigaId");
                    table.ForeignKey(
                        name: "FK__StavkaNar__Narud__2B0A656D",
                        column: x => x.NarudzbaId,
                        principalTable: "Narudzba",
                        principalColumn: "NarudzbaId");
                });

            migrationBuilder.CreateTable(
                name: "RecenzijaOdgovor",
                columns: table => new
                {
                    RecenzijaOdgovorId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RecenzijaId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    Komentar = table.Column<string>(type: "text", nullable: false),
                    DatumDodavanja = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())"),
                    BrojLajkova = table.Column<int>(type: "int", nullable: false),
                    BrojDislajkova = table.Column<int>(type: "int", nullable: false),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false),
                    VrijemeBrisanja = table.Column<DateTime>(type: "datetime", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Recenzij__23922A442E357E94", x => x.RecenzijaOdgovorId);
                    table.ForeignKey(
                        name: "FK__Recenzija__Koris__60A75C0F",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                    table.ForeignKey(
                        name: "FK__Recenzija__Recen__5FB337D6",
                        column: x => x.RecenzijaId,
                        principalTable: "Recenzija",
                        principalColumn: "RecenzijaId");
                });

            migrationBuilder.CreateTable(
                name: "RecenzijaReakcija",
                columns: table => new
                {
                    RecenzijaReakcijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RecenzijaId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    JeLajk = table.Column<bool>(type: "bit", nullable: false),
                    DatumReakcije = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Recenzij__7B1C616CADF19167", x => x.RecenzijaReakcijaId);
                    table.ForeignKey(
                        name: "FK__Recenzija__Koris__68487DD7",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                    table.ForeignKey(
                        name: "FK__Recenzija__Recen__6754599E",
                        column: x => x.RecenzijaId,
                        principalTable: "Recenzija",
                        principalColumn: "RecenzijaId");
                });

            migrationBuilder.CreateTable(
                name: "RecenzijaOdgovorReakcija",
                columns: table => new
                {
                    RecenzijaOdgovorReakcijaId = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    RecenzijaOdgovorId = table.Column<int>(type: "int", nullable: false),
                    KorisnikId = table.Column<int>(type: "int", nullable: false),
                    JeLajk = table.Column<bool>(type: "bit", nullable: false),
                    DatumReakcije = table.Column<DateTime>(type: "datetime", nullable: false, defaultValueSql: "(getdate())")
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK__Recenzij__BA973BC71C722F2F", x => x.RecenzijaOdgovorReakcijaId);
                    table.ForeignKey(
                        name: "FK__Recenzija__Koris__6D0D32F4",
                        column: x => x.KorisnikId,
                        principalTable: "Korisnik",
                        principalColumn: "KorisnikId");
                    table.ForeignKey(
                        name: "FK__Recenzija__Recen__6C190EBB",
                        column: x => x.RecenzijaOdgovorId,
                        principalTable: "RecenzijaOdgovor",
                        principalColumn: "RecenzijaOdgovorId");
                });

            migrationBuilder.CreateIndex(
                name: "IX_Arhiva_KnjigaId",
                table: "Arhiva",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_Arhiva_KorisnikId",
                table: "Arhiva",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Knjiga_AutorId",
                table: "Knjiga",
                column: "AutorId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaCiljnaGrupa_CiljnaGrupaId",
                table: "KnjigaCiljnaGrupa",
                column: "CiljnaGrupaId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaCiljnaGrupa_KnjigaId",
                table: "KnjigaCiljnaGrupa",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaZanr_KnjigaId",
                table: "KnjigaZanr",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_KnjigaZanr_ZanrId",
                table: "KnjigaZanr",
                column: "ZanrId");

            migrationBuilder.CreateIndex(
                name: "UQ__Korisnik__992E6F92884A89AE",
                table: "Korisnik",
                column: "KorisnickoIme",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "UQ__Korisnik__A9D10534846D507F",
                table: "Korisnik",
                column: "Email",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikUloga_KorisnikId",
                table: "KorisnikUloga",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_KorisnikUloga_UlogaId",
                table: "KorisnikUloga",
                column: "UlogaId");

            migrationBuilder.CreateIndex(
                name: "IX_LicnaPreporuka_KorisnikPosiljalacId",
                table: "LicnaPreporuka",
                column: "KorisnikPosiljalacId");

            migrationBuilder.CreateIndex(
                name: "IX_LicnaPreporuka_KorisnikPrimalacId",
                table: "LicnaPreporuka",
                column: "KorisnikPrimalacId");

            migrationBuilder.CreateIndex(
                name: "IX_LicnaPreporukaKnjiga_KnjigaId",
                table: "LicnaPreporukaKnjiga",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_LicnaPreporukaKnjiga_LicnaPreporukaId",
                table: "LicnaPreporukaKnjiga",
                column: "LicnaPreporukaId");

            migrationBuilder.CreateIndex(
                name: "IX_MojaLista_KnjigaId",
                table: "MojaLista",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_MojaLista_KorisnikId",
                table: "MojaLista",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzba_KorisnikId",
                table: "Narudzba",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Narudzba_NacinPlacanjaId",
                table: "Narudzba",
                column: "NacinPlacanjaId");

            migrationBuilder.CreateIndex(
                name: "IX_Obavijest_KorisnikId",
                table: "Obavijest",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_KnjigaId",
                table: "Ocjena",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_Ocjena_KorisnikId",
                table: "Ocjena",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Preporuka_KnjigaId",
                table: "Preporuka",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_Preporuka_KorisnikId",
                table: "Preporuka",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzija_KnjigaId",
                table: "Recenzija",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_Recenzija_KorisnikId",
                table: "Recenzija",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_RecenzijaOdgovor_KorisnikId",
                table: "RecenzijaOdgovor",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_RecenzijaOdgovor_RecenzijaId",
                table: "RecenzijaOdgovor",
                column: "RecenzijaId");

            migrationBuilder.CreateIndex(
                name: "IX_RecenzijaOdgovorReakcija_KorisnikId",
                table: "RecenzijaOdgovorReakcija",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_RecenzijaOdgovorReakcija_RecenzijaOdgovorId",
                table: "RecenzijaOdgovorReakcija",
                column: "RecenzijaOdgovorId");

            migrationBuilder.CreateIndex(
                name: "IX_RecenzijaReakcija_KorisnikId",
                table: "RecenzijaReakcija",
                column: "KorisnikId");

            migrationBuilder.CreateIndex(
                name: "IX_RecenzijaReakcija_RecenzijaId",
                table: "RecenzijaReakcija",
                column: "RecenzijaId");

            migrationBuilder.CreateIndex(
                name: "IX_StavkaNarudzbe_KnjigaId",
                table: "StavkaNarudzbe",
                column: "KnjigaId");

            migrationBuilder.CreateIndex(
                name: "IX_StavkaNarudzbe_NarudzbaId",
                table: "StavkaNarudzbe",
                column: "NarudzbaId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Arhiva");

            migrationBuilder.DropTable(
                name: "KnjigaCiljnaGrupa");

            migrationBuilder.DropTable(
                name: "KnjigaZanr");

            migrationBuilder.DropTable(
                name: "KorisnikUloga");

            migrationBuilder.DropTable(
                name: "LicnaPreporukaKnjiga");

            migrationBuilder.DropTable(
                name: "MojaLista");

            migrationBuilder.DropTable(
                name: "Obavijest");

            migrationBuilder.DropTable(
                name: "Ocjena");

            migrationBuilder.DropTable(
                name: "Preporuka");

            migrationBuilder.DropTable(
                name: "RecenzijaOdgovorReakcija");

            migrationBuilder.DropTable(
                name: "RecenzijaReakcija");

            migrationBuilder.DropTable(
                name: "StavkaNarudzbe");

            migrationBuilder.DropTable(
                name: "CiljnaGrupa");

            migrationBuilder.DropTable(
                name: "Zanr");

            migrationBuilder.DropTable(
                name: "Uloga");

            migrationBuilder.DropTable(
                name: "LicnaPreporuka");

            migrationBuilder.DropTable(
                name: "RecenzijaOdgovor");

            migrationBuilder.DropTable(
                name: "Narudzba");

            migrationBuilder.DropTable(
                name: "Recenzija");

            migrationBuilder.DropTable(
                name: "NacinPlacanja");

            migrationBuilder.DropTable(
                name: "Knjiga");

            migrationBuilder.DropTable(
                name: "Korisnik");

            migrationBuilder.DropTable(
                name: "Autor");
        }
    }
}
