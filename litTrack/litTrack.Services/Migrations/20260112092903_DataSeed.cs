using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

#pragma warning disable CA1814 // Prefer jagged arrays over multidimensional

namespace litTrack.Services.Migrations
{
    /// <inheritdoc />
    public partial class DataSeed : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.InsertData(
                table: "Autor",
                columns: new[] { "AutorId", "Biografija", "Ime", "IsDeleted", "Prezime", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, "Ivo Andrić (1892 - 1975) bio je bosanskohercegovački i jugoslovenski književnik, dobitnik Nobelove nagrade za književnost 1961. godine.", "Ivo", false, "Andrić", null },
                    { 2, "Meša Selimović (1910 - 1982) bio je jedan od najznačajnijih pisaca jugoslovenske književnosti 20. vijeka.", "Meša", false, "Selimović", null },
                    { 3, "Mak Dizdar (1917 - 1971) bio je bosanskohercegovački pjesnik, poznat po snažnom oslanjanju na srednjovijekovne stećke i bosansku duhovnu tradiciju.", "Mak", false, "Dizdar", null },
                    { 4, "William Shakespeare (1564 - 1616) bio je engleski pjesnik i dramatičar, često smatran najvećim piscem na engleskom jeziku.", "William", false, "Shakespeare", null },
                    { 5, "Fjodor Dostojevski (1821 - 1881) bio je ruski romanopisac i filozof, koji je duboko istraživao ljudsku psihologiju, moralne dileme i pitanje slobodne volje.", "Fjodor", false, "Dostojevski", null },
                    { 6, "Jane Austen (1775 - 1817) bila je engleska spisateljica poznata po realističnim romanima o društvu i braku u engleskoj provinciji.", "Jane", false, "Austen", null },
                    { 7, "George Orwell (1903 - 1950) bio je Britanski pisac i novinar. Najpoznatiji je po romanima 1984 i Životinjska farma.", "George", false, "Orwell", null },
                    { 8, "J.K. Rowling (rođena 1965) britanska je autorica najpoznatija po serijalu Harry Potter.", "J.K.", false, "Rowling", null },
                    { 9, "Dan Brown (rođen 1964) je američki pisac trilera, najpoznatiji po romanu Da Vincijev kod.", "Dan", false, "Brown", null },
                    { 10, "Paolo Coelho ( rođen 1947) je brazilski pisac čije knjige imaju snažnu duhovnu i motivacijsku dimenziju.", "Paulo", false, "Coelho", null }
                });

            migrationBuilder.InsertData(
                table: "CiljnaGrupa",
                columns: new[] { "CiljnaGrupaId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Djeca", null },
                    { 2, false, "Tinejdžeri", null },
                    { 3, false, "Odrasli", null },
                    { 4, false, "Mladi", null },
                    { 5, false, "Studenti", null },
                    { 6, false, "Porodično čitanje", null }
                });

            migrationBuilder.InsertData(
                table: "Korisnik",
                columns: new[] { "KorisnikId", "DatumRegistracije", "Email", "Ime", "IsDeleted", "JeAktivan", "KorisnickoIme", "LozinkaHash", "LozinkaSalt", "Prezime", "Telefon", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), "admin@gmail.com", "Admin", false, true, "admin", "p8HBu5IH77NBN6VEpuNX7RK+bRbiMTg6vfvAYQrh+Rs=", "9sbhiWrjAErHS+tLC9DcOg==", "Admin", "+061123123", null },
                    { 2, new DateTime(2025, 1, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), "radnik@gmail.com", "Radnik", false, true, "radnik", "p8HBu5IH77NBN6VEpuNX7RK+bRbiMTg6vfvAYQrh+Rs=", "9sbhiWrjAErHS+tLC9DcOg==", "Radnik", "+061123124", null },
                    { 3, new DateTime(2025, 1, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), "korisnik@gmail.com", "Korisnik", false, true, "korisnik", "p8HBu5IH77NBN6VEpuNX7RK+bRbiMTg6vfvAYQrh+Rs=", "9sbhiWrjAErHS+tLC9DcOg==", "Korisnik", "+061123125", null },
                    { 4, new DateTime(2025, 1, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), "korisnik2@gmail.com", "Korisnik", false, true, "korisnik2", "p8HBu5IH77NBN6VEpuNX7RK+bRbiMTg6vfvAYQrh+Rs=", "9sbhiWrjAErHS+tLC9DcOg==", "KorisnikDva", "+061123126", null }
                });

            migrationBuilder.InsertData(
                table: "NacinPlacanja",
                columns: new[] { "NacinPlacanjaId", "IsDeleted", "Naziv", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Gotovina", null },
                    { 2, false, "Paypal", null }
                });

            migrationBuilder.InsertData(
                table: "Uloga",
                columns: new[] { "UlogaId", "IsDeleted", "Naziv", "Opis", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Admin", "Administrator LitTrack aplikacije.", null },
                    { 2, false, "Radnik", "Radnik koji upravlja narudžbama u LitTrack aplikaciji.", null },
                    { 3, false, "Korisnik", "Korisnik LitTrack aplikacije.", null }
                });

            migrationBuilder.InsertData(
                table: "Zanr",
                columns: new[] { "ZanrId", "IsDeleted", "Naziv", "Opis", "Slika", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, false, "Roman", "Prozna književna forma dužeg obima koja prati likove kroz složen zaplet i razvoj.", null, null },
                    { 2, false, "Drama", "Književna vrsta namijenjena izvođenju na sceni, fokusirana na sukob likova. Radnja se razvija kroz dijalog i scenske napomene.", null, null },
                    { 3, false, "Poezija", "Književna forma koja koristi ritam, rimu i slikovit jezik za izražavanje osjećanja i misli.", null, null },
                    { 4, false, "Triler", "Napeta i uzbudljiva književna forma puna iznenađenja. Ima za cilj držati čitaoca u iščekivanju.", null, null },
                    { 5, false, "Fantastika", "Djela u kojima se pojavljuju natprirodni elementi, magija i izmišljeni svjetovi.", null, null },
                    { 6, false, "Naučna fantastika", "Književni žanr zasnovan na naučnim ili tehnološkim idejama i budućim mogućnostima.", null, null },
                    { 7, false, "Kriminalistički", "Radnja se vrti oko zločina, istrage i razotkrivanje počinioca.", null, null },
                    { 8, false, "Ljubavni", "Žanr sa fokusom na romantične odnose i emocije između likova.", null, null },
                    { 9, false, "Historijski", "Radnja smještena u prošlost. Žanr povezan sa stvarnim historijskim događajima ili periodima.", null, null }
                });

            migrationBuilder.InsertData(
                table: "Knjiga",
                columns: new[] { "KnjigaId", "AutorId", "Cijena", "GodinaIzdavanja", "IsDeleted", "Naziv", "Opis", "Slika", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 1, 25m, 1945, false, "Na Drini ćuprija", "Historijski roman koji prati sudbinu ljudi oko višegradske ćuprije kroz više stoljeća. Djelo snažno prikazuje uticaj velikih istorijskih događaja na živote običnih ljudi i trajnu borbu između prolaznosti i postojanosti.", null, null },
                    { 2, 1, 20m, 1954, false, "Prokleta avlija", "Psihološki roman smješten u zatvorsko okruženje koji kroz razgovore zatvorenika razotkriva ljudske sudbine. Kroz sudbinu glavnog lika istražuju se teme pravde, krivice i ljudske nemoći.", null, null },
                    { 3, 2, 23m, 1966, false, "Derviš i smrt", "Filozofski roman o unutrašnjoj borbi čovjeka suočenog s nepravdom i vlastitim uvjerenjima. Djelo postavlja pitanja o moralu, vjeri i smislu života u svijetu punom proturječja.", null, null },
                    { 4, 2, 21m, 1970, false, "Tvrđava", "Roman koji prikazuje posljedice rata na pojedinca i društvo. Kroz sudbinu glavnog junaka istražuju se nada, razočaranje i snaga ljudskog duha.", null, null },
                    { 5, 3, 19m, 1966, false, "Kameni spavač", "Zbirka poezije nadahnuta stećcima i bosanskom srednjovjekovnom baštinom. Pjesme progovaraju o prolaznosti, smrti i vječnom traganju za smislom.", null, null },
                    { 6, 4, 18m, 1603, false, "Hamlet", "Shakespeareova tragedija o danskom princu koji traga za istinom i pravdom. Djelo istražuje dileme osvete, morala i ljudske savjesti.", null, null },
                    { 7, 4, 17m, 1597, false, "Romeo i Julija", "Jedna od najpoznatijih ljubavnih tragedija o dvoje mladih čija je ljubav jača od mržnje njihovih porodica. Priča o strasti, žrtvi i tragičnoj sudbini.", null, null },
                    { 8, 5, 24m, 1866, false, "Zločin i kazna", "Roman koji duboko istražuje ljudsku savjest, krivicu i iskupljenje. Prati psihološku borbu čovjeka koji pokušava opravdati vlastiti zločin.", null, null },
                    { 9, 5, 26m, 1880, false, "Braća Karamazovi", "Porodična saga i filozofska drama o vjeri, moralu i slobodi izbora. Kroz sudbinu braće Karamazov razotkriva se kompleksnost ljudske prirode.", null, null },
                    { 10, 6, 19m, 1813, false, "Ponos i predrasude", "Klasični roman o ljubavi, društvenim normama i predrasudama engleskog društva. Prati emocionalni razvoj Elizabeth Bennet i gospodina Darcyja.", null, null },
                    { 11, 7, 22m, 1949, false, "1984", "Distopijski roman koji prikazuje totalitarno društvo pod stalnim nadzorom. Djelo upozorava na opasnosti gubitka slobode i manipulacije istinom.", null, null },
                    { 12, 7, 16m, 1945, false, "Životinjska farma", "Politička satira koja kroz priču o životinjama kritikuje društvene i političke sisteme. Djelo snažno prikazuje zloupotrebu moći i izdaju ideala.", null, null },
                    { 13, 8, 30m, 1997, false, "Harry Potter i Kamen mudraca", "Fantastična avantura o dječaku čarobnjaku koji otkriva svoj pravi identitet. Početak slavnog serijala o prijateljstvu, hrabrosti i borbi dobra i zla.", null, null },
                    { 14, 8, 30m, 1998, false, "Harry Potter i Odaja tajni", "Drugi dio serijala donosi novu misteriju u Hogwartsu. Harry i njegovi prijatelji suočavaju se s opasnom tajnom iz prošlosti škole.", null, null },
                    { 15, 9, 27m, 2003, false, "Da Vincijev kod", "Napeti triler o tajnim društvima, simbolima i drevnim misterijama. Roman povezuje istoriju, religiju i savremeni svijet u jednu uzbudljivu priču.", null, null },
                    { 16, 9, 26m, 2000, false, "Anđeli i demoni", "Triler smješten u Vatikan koji kombinuje nauku, religiju i zavjeru. Glavni junak pokušava spriječiti katastrofu koja prijeti cijelom svijetu.", null, null },
                    { 17, 10, 20m, 1988, false, "Alhemičar", "Filozofski roman o potrazi za ličnom sudbinom i snovima. Kroz putovanje mladog pastira istražuje se smisao života i važnost slijeđenja srca.", null, null },
                    { 18, 10, 21m, 2003, false, "Jedanaest minuta", "Roman o ljubavi, strasti i pronalasku vlastitog identiteta. Djelo se bavi pitanjima intime, slobode i emocionalne povezanosti.", null, null },
                    { 19, 9, 28m, 2013, false, "Inferno", "Savremeni triler koji spaja umjetnost, istoriju i opasnu zavjeru. Glavni junak pokušava spriječiti katastrofalni plan koji prijeti čovječanstvu.", null, null },
                    { 20, 3, 16m, 1975, false, "Zapis o vremenu", "Zbirka eseja i refleksija o društvu, kulturi i prolaznosti vremena. Djelo nudi duboka razmišljanja o čovjeku i njegovom mjestu u svijetu.", null, null }
                });

            migrationBuilder.InsertData(
                table: "KorisnikUloga",
                columns: new[] { "KorisnikUlogaId", "DatumDodavanja", "IsDeleted", "KorisnikId", "UlogaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 1, 1, null },
                    { 2, new DateTime(2025, 1, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 2, 2, null },
                    { 3, new DateTime(2025, 1, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 3, 3, null },
                    { 4, new DateTime(2025, 1, 1, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 4, 3, null }
                });

            migrationBuilder.InsertData(
                table: "LicnaPreporuka",
                columns: new[] { "LicnaPreporukaId", "DatumPreporuke", "IsDeleted", "JePogledana", "KorisnikPosiljalacId", "KorisnikPrimalacId", "Naslov", "Poruka", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 2, 7, 10, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 4, "Odlične knjige", "Ove knjige su mi se baš dopale, nadam se da ćeš ih i ti pročitati.", null },
                    { 2, new DateTime(2025, 2, 8, 10, 0, 0, 0, DateTimeKind.Unspecified), false, false, 3, 4, "Preporuka", "Vrijedi pročitati, mene su zabavile.", null },
                    { 3, new DateTime(2025, 2, 9, 10, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 4, "Top knjige", "Super štivo za vikend kada budeš imao slobodnog vremena.", null },
                    { 4, new DateTime(2025, 2, 10, 10, 0, 0, 0, DateTimeKind.Unspecified), false, false, 3, 4, "Knjiški savjet", "Mislim da će ti se svidjeti.", null },
                    { 5, new DateTime(2025, 2, 11, 10, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 4, "Još jedna preporuka", "Vrijedi pažnje, dosta ljudi ih je pohvalilo.", null },
                    { 6, new DateTime(2025, 2, 12, 9, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 3, "Moja preporuka", "Sjajne knjige.", null },
                    { 7, new DateTime(2025, 2, 13, 9, 0, 0, 0, DateTimeKind.Unspecified), false, false, 4, 3, "Čitaj ovo", "Vrhunsko štivo, nećeš se pokajati.", null },
                    { 8, new DateTime(2025, 2, 14, 9, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 3, "Preporuka", "Obavezno pročitaj.", null },
                    { 9, new DateTime(2025, 2, 15, 9, 0, 0, 0, DateTimeKind.Unspecified), false, false, 4, 3, "Knjiški savjet", "Preporučujem ti.", null },
                    { 10, new DateTime(2025, 2, 16, 9, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 3, "Top izbor", "Nećeš se pokajati jer su knjige stvarno super.", null }
                });

            migrationBuilder.InsertData(
                table: "Narudzba",
                columns: new[] { "NarudzbaId", "Adresa", "DatumNarudzbe", "IsDeleted", "KorisnikId", "NacinPlacanjaId", "Sifra", "StateMachine", "UkupnaCijena", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, "Mostar, Zalik", new DateTime(2026, 1, 1, 12, 0, 0, 123, DateTimeKind.Unspecified), false, 3, 1, "NAR-20260101120000-1234", "kreirana", 25m, null },
                    { 2, "Mostar, Centar", new DateTime(2026, 1, 1, 12, 10, 0, 456, DateTimeKind.Unspecified), false, 3, 2, "NAR-20260101121000-2345", "kreirana", 63m, null },
                    { 3, "Mostar, Bijeli Brijeg", new DateTime(2026, 1, 1, 12, 20, 0, 789, DateTimeKind.Unspecified), false, 3, 1, "NAR-20260101122000-3456", "kreirana", 58m, null },
                    { 4, "Mostar, Luka", new DateTime(2025, 12, 25, 10, 0, 0, 111, DateTimeKind.Unspecified), false, 3, 2, "NAR-20251225100000-4567", "zavrsena", 68m, null },
                    { 5, "Mostar, Musala", new DateTime(2025, 12, 26, 10, 0, 0, 222, DateTimeKind.Unspecified), false, 3, 1, "NAR-20251226100000-5678", "ponistena", 21m, null },
                    { 6, "Mostar, Bulevar", new DateTime(2025, 12, 27, 10, 0, 0, 333, DateTimeKind.Unspecified), false, 3, 1, "NAR-20251227100000-6789", "uToku", 37m, null },
                    { 7, "Mostar, Zalik", new DateTime(2025, 12, 28, 10, 0, 0, 444, DateTimeKind.Unspecified), false, 3, 2, "NAR-20251228100000-7890", "uToku", 58m, null },
                    { 8, "Mostar, Centar", new DateTime(2025, 12, 29, 10, 0, 0, 555, DateTimeKind.Unspecified), false, 3, 1, "NAR-20251229100000-8901", "preuzeta", 26m, null },
                    { 9, "Sarajevo, Stari Grad", new DateTime(2026, 1, 2, 10, 0, 0, 123, DateTimeKind.Unspecified), false, 4, 1, "NAR-20260102100000-9012", "kreirana", 19m, null },
                    { 10, "Sarajevo, Bistrik", new DateTime(2026, 1, 2, 10, 30, 0, 456, DateTimeKind.Unspecified), false, 4, 2, "NAR-20260102103000-0123", "kreirana", 60m, null },
                    { 11, "Sarajevo, Marijin Dvor", new DateTime(2025, 12, 20, 10, 0, 0, 111, DateTimeKind.Unspecified), false, 4, 1, "NAR-20251220100000-1235", "ponistena", 30m, null },
                    { 12, "Sarajevo, Ilidža", new DateTime(2025, 12, 21, 10, 0, 0, 222, DateTimeKind.Unspecified), false, 4, 1, "NAR-20251221100000-2346", "ponistena", 60m, null },
                    { 13, "Sarajevo, Dobrinja", new DateTime(2025, 12, 22, 10, 0, 0, 333, DateTimeKind.Unspecified), false, 4, 2, "NAR-20251222100000-3457", "zavrsena", 73m, null },
                    { 14, "Sarajevo, Vogošća", new DateTime(2025, 12, 23, 10, 0, 0, 444, DateTimeKind.Unspecified), false, 4, 2, "NAR-20251223100000-4568", "zavrsena", 42m, null },
                    { 15, "Sarajevo, Centar", new DateTime(2025, 12, 24, 10, 0, 0, 555, DateTimeKind.Unspecified), false, 4, 1, "NAR-20251224100000-5679", "zavrsena", 44m, null },
                    { 16, "Sarajevo, Grbavica", new DateTime(2025, 12, 25, 10, 0, 0, 666, DateTimeKind.Unspecified), false, 4, 2, "NAR-20251225100000-6780", "uToku", 25m, null },
                    { 17, "Sarajevo, Ilidža", new DateTime(2026, 1, 3, 0, 0, 0, 777, DateTimeKind.Unspecified), false, 4, 1, "NAR-20260103000000-7891", "kreirana", 20m, null }
                });

            migrationBuilder.InsertData(
                table: "Obavijest",
                columns: new[] { "ObavijestId", "DatumObavijesti", "IsDeleted", "JePogledana", "KorisnikId", "Naslov", "Sadrzaj", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2026, 1, 1, 12, 0, 0, 123, DateTimeKind.Unspecified), false, true, 2, "Nova narudžba", "Poštovani, kreirana je nova narudžba broj NAR-20260101120000-1234. Molimo vas da preuzmete narudžbu i krenete sa obradom.", null },
                    { 2, new DateTime(2026, 1, 1, 12, 10, 0, 456, DateTimeKind.Unspecified), false, false, 2, "Nova narudžba", "Poštovani, kreirana je nova narudžba broj NAR-20260101121000-2345. Molimo vas da preuzmete narudžbu i krenete sa obradom.", null },
                    { 3, new DateTime(2025, 12, 20, 10, 0, 0, 111, DateTimeKind.Unspecified), false, false, 2, "Poništena narudžba", "Poštovani, narudžba NAR-20251220100000-1235 je poništena.", null },
                    { 4, new DateTime(2025, 12, 20, 10, 0, 0, 111, DateTimeKind.Unspecified), false, false, 2, "Poništena narudžba", "Poštovani, narudžba NAR-20260101121000-2345 je poništena.", null },
                    { 5, new DateTime(2025, 12, 29, 10, 0, 0, 555, DateTimeKind.Unspecified), false, true, 3, "Narudžba je zaprimljena", "Poštovanje Korisnik,\n\nVaša narudžba #NAR-20251229100000-8901 je uspješno zaprimljena 29.12.2025. Trenutno je u obradi.\n\nDetalji narudžbe:\n- Broj narudžbe: NAR-20251229100000-8901\n- Kupac: Korisnik Korisnik\n- Datum narudžbe: 29.12.2025 10:00\n- Ukupan iznos: 26 KM\n\nDalji status narudžbe možete pratiti u sekciji Obavijesti.\n\nHvala Vam na narudžbi,\nVaš LitTrack tim", null },
                    { 6, new DateTime(2025, 12, 28, 10, 0, 0, 444, DateTimeKind.Unspecified), false, true, 3, "Narudžba je poslana", "Poštovanje Korisnik,\n\nVaša narudžba #NAR-20251228100000-7890 je uspješno zapakovana i poslana.\n\nDetalji narudžbe:\n- Broj narudžbe: NAR-20251228100000-7890\n- Kupac: Korisnik Korisnik\n- Datum narudžbe: 28.12.2025 10:00\n- Ukupan iznos: 58 KM\n\nHvala Vam na narudžbi,\nVaš LitTrack tim", null },
                    { 7, new DateTime(2025, 12, 27, 10, 0, 0, 333, DateTimeKind.Unspecified), false, false, 3, "Narudžba je poslana", "Poštovanje Korisnik,\n\nVaša narudžba #NAR-20251227100000-6789 je uspješno zapakovana i poslana.\n\nDetalji narudžbe:\n- Broj narudžbe: NAR-20251227100000-6789\n- Kupac: Korisnik Korisnik\n- Datum narudžbe: 27.12.2025 10:00\n- Ukupan iznos: 37 KM\n\nHvala Vam na narudžbi,\nVaš LitTrack tim", null },
                    { 8, new DateTime(2025, 2, 12, 9, 0, 0, 0, DateTimeKind.Unspecified), false, false, 3, "Moja preporuka", "Poštovanje Korisnik Korisnik,\n\nPrimili ste preporuku od korisnika Korisnik KorisnikDva.\nNaslov preporuke: Moja preporuka\n\nLijep pozdrav,\nVaš LitTrack tim", null },
                    { 9, new DateTime(2025, 12, 25, 10, 0, 0, 666, DateTimeKind.Unspecified), false, true, 4, "Narudžba je poslana", "Poštovanje Korisnik,\n\nVaša narudžba #NAR-20251225100000-6780 je uspješno zapakovana i poslana.\n\nDetalji narudžbe:\n- Broj narudžbe: NAR-20251225100000-6780\n- Kupac: Korisnik KorisnikDva\n- Datum narudžbe: 25.12.2025 10:00\n- Ukupan iznos: 25 KM\n\nHvala Vam na narudžbi,\nVaš LitTrack tim", null },
                    { 10, new DateTime(2025, 2, 8, 10, 0, 0, 0, DateTimeKind.Unspecified), false, false, 4, "Preporuka", "Poštovanje Korisnik KorisnikDva,\n\nPrimili ste preporuku od korisnika Korisnik Korisnik.\nNaslov preporuke: Preporuka\n\nLijep pozdrav,\nVaš LitTrack tim", null },
                    { 11, new DateTime(2025, 2, 7, 10, 0, 0, 0, DateTimeKind.Unspecified), false, false, 4, "Odlične knjige", "Poštovanje Korisnik KorisnikDva,\n\nPrimili ste preporuku od korisnika Korisnik Korisnik.\nNaslov preporuke: Odlične knjige\n\nLijep pozdrav,\nVaš LitTrack tim", null }
                });

            migrationBuilder.InsertData(
                table: "Arhiva",
                columns: new[] { "ArhivaId", "DatumDodavanja", "IsDeleted", "KnjigaId", "KorisnikId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 2, 10, 10, 0, 0, 110, DateTimeKind.Unspecified), false, 1, 3, null },
                    { 2, new DateTime(2025, 2, 11, 10, 0, 0, 120, DateTimeKind.Unspecified), false, 2, 3, null },
                    { 3, new DateTime(2025, 2, 12, 10, 0, 0, 130, DateTimeKind.Unspecified), false, 3, 3, null },
                    { 4, new DateTime(2025, 2, 13, 10, 0, 0, 140, DateTimeKind.Unspecified), false, 4, 3, null },
                    { 5, new DateTime(2025, 2, 14, 10, 0, 0, 150, DateTimeKind.Unspecified), false, 7, 3, null },
                    { 6, new DateTime(2025, 2, 15, 10, 0, 0, 160, DateTimeKind.Unspecified), false, 13, 3, null },
                    { 7, new DateTime(2025, 2, 16, 10, 0, 0, 170, DateTimeKind.Unspecified), false, 14, 3, null },
                    { 8, new DateTime(2025, 2, 17, 10, 0, 0, 180, DateTimeKind.Unspecified), false, 17, 3, null },
                    { 9, new DateTime(2025, 2, 10, 9, 0, 0, 110, DateTimeKind.Unspecified), false, 1, 4, null },
                    { 10, new DateTime(2025, 2, 11, 9, 0, 0, 120, DateTimeKind.Unspecified), false, 2, 4, null },
                    { 11, new DateTime(2025, 2, 12, 9, 0, 0, 130, DateTimeKind.Unspecified), false, 3, 4, null },
                    { 12, new DateTime(2025, 2, 13, 9, 0, 0, 140, DateTimeKind.Unspecified), false, 14, 4, null },
                    { 13, new DateTime(2025, 2, 14, 9, 0, 0, 150, DateTimeKind.Unspecified), false, 15, 4, null },
                    { 14, new DateTime(2025, 2, 15, 9, 0, 0, 160, DateTimeKind.Unspecified), false, 16, 4, null },
                    { 15, new DateTime(2025, 2, 16, 9, 0, 0, 170, DateTimeKind.Unspecified), false, 18, 4, null },
                    { 16, new DateTime(2025, 2, 17, 9, 0, 0, 180, DateTimeKind.Unspecified), false, 19, 4, null }
                });

            migrationBuilder.InsertData(
                table: "KnjigaCiljnaGrupa",
                columns: new[] { "KnjigaCiljnaGrupaId", "CiljnaGrupaId", "IsDeleted", "KnjigaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 2, false, 1, null },
                    { 2, 3, false, 1, null },
                    { 3, 4, false, 1, null },
                    { 4, 5, false, 1, null },
                    { 5, 3, false, 2, null },
                    { 6, 3, false, 3, null },
                    { 7, 4, false, 3, null },
                    { 8, 3, false, 4, null },
                    { 9, 5, false, 4, null },
                    { 10, 3, false, 5, null },
                    { 11, 6, false, 5, null },
                    { 12, 3, false, 6, null },
                    { 13, 4, false, 7, null },
                    { 14, 3, false, 7, null },
                    { 15, 3, false, 8, null },
                    { 16, 3, false, 9, null },
                    { 17, 5, false, 9, null },
                    { 18, 4, false, 10, null },
                    { 19, 5, false, 10, null },
                    { 20, 3, false, 11, null },
                    { 21, 3, false, 12, null },
                    { 22, 1, false, 13, null },
                    { 23, 2, false, 13, null },
                    { 24, 6, false, 13, null },
                    { 25, 1, false, 14, null },
                    { 26, 2, false, 14, null },
                    { 27, 3, false, 15, null },
                    { 28, 3, false, 16, null },
                    { 29, 3, false, 17, null },
                    { 30, 5, false, 17, null },
                    { 31, 3, false, 18, null },
                    { 32, 4, false, 18, null },
                    { 33, 3, false, 19, null },
                    { 34, 5, false, 20, null }
                });

            migrationBuilder.InsertData(
                table: "KnjigaZanr",
                columns: new[] { "KnjigaZanrId", "IsDeleted", "KnjigaId", "VrijemeBrisanja", "ZanrId" },
                values: new object[,]
                {
                    { 1, false, 1, null, 1 },
                    { 2, false, 1, null, 9 },
                    { 3, false, 2, null, 1 },
                    { 4, false, 3, null, 1 },
                    { 5, false, 3, null, 9 },
                    { 6, false, 4, null, 1 },
                    { 7, false, 5, null, 3 },
                    { 8, false, 6, null, 2 },
                    { 9, false, 7, null, 2 },
                    { 10, false, 7, null, 8 },
                    { 11, false, 8, null, 1 },
                    { 12, false, 9, null, 1 },
                    { 13, false, 10, null, 8 },
                    { 14, false, 11, null, 6 },
                    { 15, false, 12, null, 1 },
                    { 16, false, 12, null, 7 },
                    { 17, false, 13, null, 5 },
                    { 18, false, 13, null, 6 },
                    { 19, false, 14, null, 5 },
                    { 20, false, 15, null, 4 },
                    { 21, false, 15, null, 7 },
                    { 22, false, 16, null, 4 },
                    { 23, false, 17, null, 1 },
                    { 24, false, 17, null, 8 },
                    { 25, false, 18, null, 1 },
                    { 26, false, 19, null, 4 },
                    { 27, false, 19, null, 7 },
                    { 28, false, 20, null, 3 }
                });

            migrationBuilder.InsertData(
                table: "LicnaPreporukaKnjiga",
                columns: new[] { "LicnaPreporukaKnjigaId", "DatumDodavanja", "IsDeleted", "KnjigaId", "LicnaPreporukaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 2, 7, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 1, 1, null },
                    { 2, new DateTime(2025, 2, 7, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 2, 1, null },
                    { 3, new DateTime(2025, 2, 8, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 3, 2, null },
                    { 4, new DateTime(2025, 2, 9, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 4, 3, null },
                    { 5, new DateTime(2025, 2, 10, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 5, 4, null },
                    { 6, new DateTime(2025, 2, 11, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 6, 5, null },
                    { 7, new DateTime(2025, 2, 11, 10, 0, 0, 0, DateTimeKind.Unspecified), false, 7, 5, null },
                    { 8, new DateTime(2025, 2, 12, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 1, 6, null },
                    { 9, new DateTime(2025, 2, 13, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 2, 7, null },
                    { 10, new DateTime(2025, 2, 14, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 13, 8, null },
                    { 11, new DateTime(2025, 2, 14, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 14, 8, null },
                    { 12, new DateTime(2025, 2, 15, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 15, 9, null },
                    { 13, new DateTime(2025, 2, 16, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 16, 10, null },
                    { 14, new DateTime(2025, 2, 16, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 17, 10, null },
                    { 15, new DateTime(2025, 2, 16, 9, 0, 0, 0, DateTimeKind.Unspecified), false, 19, 10, null }
                });

            migrationBuilder.InsertData(
                table: "MojaLista",
                columns: new[] { "MojaListaId", "DatumDodavanja", "IsDeleted", "JeProcitana", "KnjigaId", "KorisnikId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 2, 1, 10, 0, 0, 120, DateTimeKind.Unspecified), false, true, 1, 3, null },
                    { 2, new DateTime(2025, 2, 2, 10, 0, 0, 130, DateTimeKind.Unspecified), false, true, 2, 3, null },
                    { 3, new DateTime(2025, 2, 3, 10, 0, 0, 140, DateTimeKind.Unspecified), false, true, 3, 3, null },
                    { 4, new DateTime(2025, 2, 4, 10, 0, 0, 150, DateTimeKind.Unspecified), false, true, 4, 3, null },
                    { 5, new DateTime(2025, 2, 5, 10, 0, 0, 160, DateTimeKind.Unspecified), false, true, 5, 3, null },
                    { 6, new DateTime(2025, 2, 6, 10, 0, 0, 170, DateTimeKind.Unspecified), false, true, 6, 3, null },
                    { 7, new DateTime(2025, 2, 7, 10, 0, 0, 180, DateTimeKind.Unspecified), false, true, 7, 3, null },
                    { 8, new DateTime(2025, 2, 8, 10, 0, 0, 190, DateTimeKind.Unspecified), false, false, 15, 3, null },
                    { 9, new DateTime(2025, 2, 9, 10, 0, 0, 200, DateTimeKind.Unspecified), false, false, 13, 3, null },
                    { 10, new DateTime(2025, 2, 10, 10, 0, 0, 210, DateTimeKind.Unspecified), false, false, 14, 3, null },
                    { 11, new DateTime(2025, 2, 1, 9, 0, 0, 120, DateTimeKind.Unspecified), false, true, 1, 4, null },
                    { 12, new DateTime(2025, 2, 2, 9, 0, 0, 130, DateTimeKind.Unspecified), false, true, 2, 4, null },
                    { 13, new DateTime(2025, 2, 3, 9, 0, 0, 140, DateTimeKind.Unspecified), false, false, 3, 4, null },
                    { 14, new DateTime(2025, 2, 4, 9, 0, 0, 150, DateTimeKind.Unspecified), false, false, 4, 4, null },
                    { 15, new DateTime(2025, 2, 5, 9, 0, 0, 160, DateTimeKind.Unspecified), false, false, 5, 4, null },
                    { 16, new DateTime(2025, 2, 6, 9, 0, 0, 170, DateTimeKind.Unspecified), false, false, 8, 4, null },
                    { 17, new DateTime(2025, 2, 7, 9, 0, 0, 180, DateTimeKind.Unspecified), false, false, 9, 4, null },
                    { 18, new DateTime(2025, 2, 8, 9, 0, 0, 190, DateTimeKind.Unspecified), false, true, 13, 4, null },
                    { 19, new DateTime(2025, 2, 9, 9, 0, 0, 200, DateTimeKind.Unspecified), false, true, 14, 4, null },
                    { 20, new DateTime(2025, 2, 10, 9, 0, 0, 210, DateTimeKind.Unspecified), false, true, 15, 4, null },
                    { 21, new DateTime(2025, 2, 11, 9, 0, 0, 220, DateTimeKind.Unspecified), false, true, 16, 4, null },
                    { 22, new DateTime(2025, 2, 12, 9, 0, 0, 220, DateTimeKind.Unspecified), false, true, 17, 4, null },
                    { 23, new DateTime(2025, 2, 12, 9, 0, 0, 220, DateTimeKind.Unspecified), false, true, 19, 4, null }
                });

            migrationBuilder.InsertData(
                table: "Ocjena",
                columns: new[] { "OcjenaId", "DatumOcjenjivanja", "IsDeleted", "KnjigaId", "KorisnikId", "Vrijednost", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 2, 2, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 1, 3, 4, null },
                    { 2, new DateTime(2025, 2, 3, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 2, 3, 5, null },
                    { 3, new DateTime(2025, 2, 4, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 3, 3, 5, null },
                    { 4, new DateTime(2025, 2, 5, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 4, 3, 4, null },
                    { 5, new DateTime(2025, 2, 6, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 5, 3, 3, null },
                    { 6, new DateTime(2025, 2, 7, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 1, 4, 5, null },
                    { 7, new DateTime(2025, 2, 8, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 2, 4, 4, null },
                    { 8, new DateTime(2025, 2, 9, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 13, 4, 5, null },
                    { 9, new DateTime(2025, 2, 10, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 14, 4, 4, null },
                    { 10, new DateTime(2025, 2, 11, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 15, 4, 4, null },
                    { 11, new DateTime(2025, 2, 12, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 17, 4, 5, null },
                    { 12, new DateTime(2025, 2, 13, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 19, 4, 4, null }
                });

            migrationBuilder.InsertData(
                table: "Preporuka",
                columns: new[] { "PreporukaId", "DatumPreporuke", "IsDeleted", "KnjigaId", "KorisnikId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 1, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 1, 3, null },
                    { 2, new DateTime(2025, 1, 2, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 2, 3, null },
                    { 3, new DateTime(2025, 1, 3, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 3, 3, null },
                    { 4, new DateTime(2025, 1, 4, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 4, 3, null },
                    { 5, new DateTime(2025, 1, 5, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 6, 3, null },
                    { 6, new DateTime(2025, 1, 6, 11, 0, 0, 0, DateTimeKind.Unspecified), false, 1, 4, null },
                    { 7, new DateTime(2025, 1, 7, 11, 0, 0, 0, DateTimeKind.Unspecified), false, 13, 4, null },
                    { 8, new DateTime(2025, 1, 8, 11, 0, 0, 0, DateTimeKind.Unspecified), false, 14, 4, null },
                    { 9, new DateTime(2025, 1, 9, 11, 0, 0, 0, DateTimeKind.Unspecified), false, 15, 4, null },
                    { 10, new DateTime(2025, 1, 10, 11, 0, 0, 0, DateTimeKind.Unspecified), false, 17, 4, null },
                    { 11, new DateTime(2025, 1, 11, 11, 0, 0, 0, DateTimeKind.Unspecified), false, 19, 4, null }
                });

            migrationBuilder.InsertData(
                table: "Recenzija",
                columns: new[] { "RecenzijaId", "BrojDislajkova", "BrojLajkova", "DatumDodavanja", "IsDeleted", "KnjigaId", "Komentar", "KorisnikId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 0, 1, new DateTime(2025, 1, 1, 13, 0, 0, 0, DateTimeKind.Unspecified), false, 1, "Sjajna knjiga, preporučujem svima!", 3, null },
                    { 2, 0, 1, new DateTime(2025, 1, 2, 13, 0, 0, 0, DateTimeKind.Unspecified), false, 2, "Odlična knjiga, zaista me oduševila.", 3, null },
                    { 3, 1, 0, new DateTime(2025, 1, 3, 13, 0, 0, 0, DateTimeKind.Unspecified), false, 3, "Vrhunska knjiga, sve pohvale.", 3, null },
                    { 4, 0, 0, new DateTime(2025, 1, 4, 13, 0, 0, 0, DateTimeKind.Unspecified), false, 5, "Dobar sadržaj, ali očekivao sam više.", 3, null },
                    { 5, 1, 0, new DateTime(2025, 1, 5, 13, 0, 0, 0, DateTimeKind.Unspecified), false, 7, "Fenomenalno štivo, preporuka!", 3, null },
                    { 6, 0, 1, new DateTime(2025, 1, 6, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 1, "Odlična knjiga, uživao sam.", 4, null },
                    { 7, 0, 1, new DateTime(2025, 1, 7, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 2, "Vrlo zanimljivo štivo.", 4, null },
                    { 8, 0, 1, new DateTime(2025, 1, 8, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 13, "Sjajan uvod u serijal.", 4, null },
                    { 9, 0, 1, new DateTime(2025, 1, 9, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 14, "Drugi dio je jednako dobar.", 4, null },
                    { 10, 0, 0, new DateTime(2025, 1, 10, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 15, "Nije loše, iznenadila me je radnja knjige.", 4, null },
                    { 11, 1, 0, new DateTime(2025, 1, 11, 12, 0, 0, 0, DateTimeKind.Unspecified), false, 19, "Svidjela mi se, vrijedi pročitati bar jednom.", 4, null }
                });

            migrationBuilder.InsertData(
                table: "StavkaNarudzbe",
                columns: new[] { "StavkaNarudzbeId", "Cijena", "IsDeleted", "KnjigaId", "Kolicina", "NarudzbaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 25m, false, 1, 1, 1, null },
                    { 2, 20m, false, 2, 2, 2, null },
                    { 3, 23m, false, 3, 1, 2, null },
                    { 4, 21m, false, 4, 1, 3, null },
                    { 5, 19m, false, 5, 1, 3, null },
                    { 6, 18m, false, 6, 1, 3, null },
                    { 7, 25m, false, 1, 1, 4, null },
                    { 8, 20m, false, 2, 2, 4, null },
                    { 9, 23m, false, 3, 1, 4, null },
                    { 10, 21m, false, 4, 1, 5, null },
                    { 11, 19m, false, 5, 1, 6, null },
                    { 12, 18m, false, 6, 1, 6, null },
                    { 13, 17m, false, 7, 2, 7, null },
                    { 14, 24m, false, 8, 1, 7, null },
                    { 15, 26m, false, 9, 1, 8, null },
                    { 16, 19m, false, 10, 1, 9, null },
                    { 17, 22m, false, 11, 2, 10, null },
                    { 18, 16m, false, 12, 1, 10, null },
                    { 19, 30m, false, 13, 1, 11, null },
                    { 20, 30m, false, 14, 2, 12, null },
                    { 21, 27m, false, 15, 1, 13, null },
                    { 22, 26m, false, 16, 1, 13, null },
                    { 23, 20m, false, 17, 1, 13, null },
                    { 24, 21m, false, 18, 2, 14, null },
                    { 25, 28m, false, 19, 1, 15, null },
                    { 26, 16m, false, 20, 1, 15, null },
                    { 27, 25m, false, 1, 1, 16, null },
                    { 28, 20m, false, 2, 1, 17, null }
                });

            migrationBuilder.InsertData(
                table: "RecenzijaOdgovor",
                columns: new[] { "RecenzijaOdgovorId", "BrojDislajkova", "BrojLajkova", "DatumDodavanja", "IsDeleted", "Komentar", "KorisnikId", "RecenzijaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, 0, 0, new DateTime(2025, 1, 6, 15, 0, 0, 0, DateTimeKind.Unspecified), false, "Da, i meni se stvarno dopala.", 3, 6, null },
                    { 2, 0, 0, new DateTime(2025, 1, 7, 15, 0, 0, 0, DateTimeKind.Unspecified), false, "Slažem se, meni je super.", 3, 7, null },
                    { 3, 0, 0, new DateTime(2025, 1, 8, 15, 0, 0, 0, DateTimeKind.Unspecified), false, "Stvarno? Nisam gledao filmove, da li je bolje prvo pročitati knjige?", 3, 8, null },
                    { 4, 0, 1, new DateTime(2025, 1, 14, 15, 0, 0, 0, DateTimeKind.Unspecified), false, "Jesi li čitao sve knjige redom ili mogu odmah čitati ovu?", 3, 9, null },
                    { 5, 0, 0, new DateTime(2025, 1, 1, 16, 0, 0, 0, DateTimeKind.Unspecified), false, "Baš je odlična i meni.", 4, 1, null },
                    { 6, 0, 1, new DateTime(2025, 1, 6, 16, 0, 0, 0, DateTimeKind.Unspecified), false, "Da li onda bolje da je ne čitam? Planirao sam.", 4, 4, null },
                    { 7, 0, 1, new DateTime(2025, 1, 8, 13, 30, 0, 0, DateTimeKind.Unspecified), false, "Baš je želim čitati.", 4, 5, null },
                    { 8, 0, 1, new DateTime(2025, 1, 6, 17, 0, 0, 0, DateTimeKind.Unspecified), false, "Nije toliko loša ali nećeš ništa propustiti.", 3, 4, null },
                    { 9, 0, 1, new DateTime(2025, 1, 8, 14, 0, 0, 0, DateTimeKind.Unspecified), false, "Definitivno nećeš požaliti.", 3, 5, null },
                    { 10, 0, 1, new DateTime(2025, 1, 8, 16, 0, 0, 0, DateTimeKind.Unspecified), false, "I filmovi i knjige su super. Ja sam prvo gledao filmove i opet su mi knjige bile zanimljive.", 4, 8, null },
                    { 11, 0, 1, new DateTime(2025, 1, 14, 16, 0, 0, 0, DateTimeKind.Unspecified), false, "Preporučujem da ih čitaš redom.", 4, 9, null },
                    { 12, 0, 1, new DateTime(2025, 1, 8, 17, 0, 0, 0, DateTimeKind.Unspecified), false, "Onda ću i ja tako.", 3, 8, null }
                });


            migrationBuilder.InsertData(
                table: "RecenzijaReakcija",
                columns: new[] { "RecenzijaReakcijaId", "DatumReakcije", "IsDeleted", "JeLajk", "KorisnikId", "RecenzijaId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 6, 14, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 6, null },
                    { 2, new DateTime(2025, 1, 7, 14, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 7, null },
                    { 3, new DateTime(2025, 1, 8, 14, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 8, null },
                    { 4, new DateTime(2025, 1, 11, 14, 0, 0, 0, DateTimeKind.Unspecified), false, false, 3, 11, null },
                    { 5, new DateTime(2025, 1, 1, 15, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 1, null },
                    { 6, new DateTime(2025, 1, 2, 15, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 2, null },
                    { 7, new DateTime(2025, 1, 3, 15, 0, 0, 0, DateTimeKind.Unspecified), false, false, 4, 3, null },
                    { 8, new DateTime(2025, 1, 5, 15, 0, 0, 0, DateTimeKind.Unspecified), false, false, 4, 5, null }
                });

            migrationBuilder.InsertData(
                table: "RecenzijaOdgovorReakcija",
                columns: new[] { "RecenzijaOdgovorReakcijaId", "DatumReakcije", "IsDeleted", "JeLajk", "KorisnikId", "RecenzijaOdgovorId", "VrijemeBrisanja" },
                values: new object[,]
                {
                    { 1, new DateTime(2025, 1, 7, 10, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 6, null },
                    { 2, new DateTime(2025, 1, 8, 10, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 7, null },
                    { 3, new DateTime(2025, 1, 8, 17, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 10, null },
                    { 4, new DateTime(2025, 1, 14, 17, 0, 0, 0, DateTimeKind.Unspecified), false, true, 3, 11, null },
                    { 5, new DateTime(2025, 1, 8, 16, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 3, null },
                    { 6, new DateTime(2025, 1, 14, 16, 30, 0, 0, DateTimeKind.Unspecified), false, true, 4, 4, null },
                    { 7, new DateTime(2025, 1, 6, 18, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 8, null },
                    { 8, new DateTime(2025, 1, 8, 15, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 9, null },
                    { 9, new DateTime(2025, 1, 8, 18, 0, 0, 0, DateTimeKind.Unspecified), false, true, 4, 12, null }
                });

        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Arhiva",
                keyColumn: "ArhivaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 27);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 28);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 29);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 30);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 31);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 32);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 33);

            migrationBuilder.DeleteData(
                table: "KnjigaCiljnaGrupa",
                keyColumn: "KnjigaCiljnaGrupaId",
                keyValue: 34);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 27);

            migrationBuilder.DeleteData(
                table: "KnjigaZanr",
                keyColumn: "KnjigaZanrId",
                keyValue: 28);

            migrationBuilder.DeleteData(
                table: "KorisnikUloga",
                keyColumn: "KorisnikUlogaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "KorisnikUloga",
                keyColumn: "KorisnikUlogaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "KorisnikUloga",
                keyColumn: "KorisnikUlogaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "KorisnikUloga",
                keyColumn: "KorisnikUlogaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "LicnaPreporukaKnjiga",
                keyColumn: "LicnaPreporukaKnjigaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "MojaLista",
                keyColumn: "MojaListaId",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Obavijest",
                keyColumn: "ObavijestId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Ocjena",
                keyColumn: "OcjenaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Preporuka",
                keyColumn: "PreporukaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovorReakcija",
                keyColumn: "RecenzijaOdgovorReakcijaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "RecenzijaReakcija",
                keyColumn: "RecenzijaReakcijaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "RecenzijaReakcija",
                keyColumn: "RecenzijaReakcijaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "RecenzijaReakcija",
                keyColumn: "RecenzijaReakcijaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "RecenzijaReakcija",
                keyColumn: "RecenzijaReakcijaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "RecenzijaReakcija",
                keyColumn: "RecenzijaReakcijaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "RecenzijaReakcija",
                keyColumn: "RecenzijaReakcijaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "RecenzijaReakcija",
                keyColumn: "RecenzijaReakcijaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "RecenzijaReakcija",
                keyColumn: "RecenzijaReakcijaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 21);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 22);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 23);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 24);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 25);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 26);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 27);

            migrationBuilder.DeleteData(
                table: "StavkaNarudzbe",
                keyColumn: "StavkaNarudzbeId",
                keyValue: 28);

            migrationBuilder.DeleteData(
                table: "CiljnaGrupa",
                keyColumn: "CiljnaGrupaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "CiljnaGrupa",
                keyColumn: "CiljnaGrupaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "CiljnaGrupa",
                keyColumn: "CiljnaGrupaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "CiljnaGrupa",
                keyColumn: "CiljnaGrupaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "CiljnaGrupa",
                keyColumn: "CiljnaGrupaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "CiljnaGrupa",
                keyColumn: "CiljnaGrupaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 18);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 20);

            migrationBuilder.DeleteData(
                table: "Korisnik",
                keyColumn: "KorisnikId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Korisnik",
                keyColumn: "KorisnikId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "LicnaPreporuka",
                keyColumn: "LicnaPreporukaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 14);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 15);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 16);

            migrationBuilder.DeleteData(
                table: "Narudzba",
                keyColumn: "NarudzbaId",
                keyValue: 17);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 11);

            migrationBuilder.DeleteData(
                table: "RecenzijaOdgovor",
                keyColumn: "RecenzijaOdgovorId",
                keyValue: 12);

            migrationBuilder.DeleteData(
                table: "Uloga",
                keyColumn: "UlogaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Uloga",
                keyColumn: "UlogaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Uloga",
                keyColumn: "UlogaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Zanr",
                keyColumn: "ZanrId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 6);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 10);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 19);

            migrationBuilder.DeleteData(
                table: "NacinPlacanja",
                keyColumn: "NacinPlacanjaId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "NacinPlacanja",
                keyColumn: "NacinPlacanjaId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Recenzija",
                keyColumn: "RecenzijaId",
                keyValue: 8);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 1);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 2);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 9);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 5);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 7);

            migrationBuilder.DeleteData(
                table: "Knjiga",
                keyColumn: "KnjigaId",
                keyValue: 13);

            migrationBuilder.DeleteData(
                table: "Korisnik",
                keyColumn: "KorisnikId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Korisnik",
                keyColumn: "KorisnikId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 3);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 4);

            migrationBuilder.DeleteData(
                table: "Autor",
                keyColumn: "AutorId",
                keyValue: 8);
        }
    }
}
