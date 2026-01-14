using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using QuestPDF.Fluent;
using QuestPDF.Helpers;
using QuestPDF.Infrastructure;
using Microsoft.EntityFrameworkCore;
using litTrack.Model.Exceptions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.ServicesImplementation
{
    public class ReportService : IReportService
    {
        private readonly _210078Context _context;
        private readonly INarudzbaService _narudzbaService;
        private readonly IArhivaService _arhivaService;

        public ReportService(_210078Context context, INarudzbaService narudzbaService, IArhivaService arhivaService)
        {
            _context = context;
            _narudzbaService = narudzbaService;
            _arhivaService = arhivaService;
        }

        public async Task<byte[]> RadnikStatistikaPdf(string? stateMachine)
        {

            var sveNarudzbe = _context.Narudzbas.Where(n => !n.IsDeleted);

            var brojKreiranih = await sveNarudzbe.CountAsync(n => n.StateMachine == "kreirana");
            var brojPreuzetih = await sveNarudzbe.CountAsync(n => n.StateMachine == "preuzeta");
            var brojUToku = await sveNarudzbe.CountAsync(n => n.StateMachine == "uToku");
            var brojZavrsenih = await sveNarudzbe.CountAsync(n => n.StateMachine == "zavrsena");
            var brojPonistenih = await sveNarudzbe.CountAsync(n => n.StateMachine == "ponistena");


            var filterQuery = sveNarudzbe;

            if (!string.IsNullOrWhiteSpace(stateMachine))
                filterQuery = filterQuery.Where(n => n.StateMachine == stateMachine);

            var ukupno = await filterQuery.CountAsync();


            var poMjesecima = await _narudzbaService
                .GetBrojNarudzbiPoMjesecimaAsync(stateMachine);


            var document = Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Margin(40);

                    page.Header()
                        .PaddingBottom(15)
                        .AlignCenter()
                        .Text("Izvještaj o narudžbama")
                        .FontSize(22)
                        .SemiBold()
                        .FontColor(Colors.Teal.Darken2);

                    

                    page.Content().Column(col =>
                    {
                        col.Spacing(12);

                        col.Item()
                           .Text($"Filter: {stateMachine ?? "Sve narudžbe"}")
                           .FontSize(12)
                           .FontColor(Colors.Grey.Darken2);

                        col.Item().LineHorizontal(1).LineColor(Colors.Grey.Lighten2);

                        col.Item().Row(row =>
                        {
                            row.Spacing(10);

                            void Card(Action<IContainer> build) =>
                                row.RelativeItem()
                                   .Padding(12)
                                   .Background(Colors.Grey.Lighten4)
                                   .MinHeight(80)
                                   .AlignMiddle()
                                   .AlignCenter()
                                   .Element(build);

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Ukupno").FontSize(11).AlignCenter();
                                col.Item().Text(ukupno.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Kreirane").FontSize(11).AlignCenter();
                                col.Item().Text(brojKreiranih.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Preuzete").FontSize(11).AlignCenter();
                                col.Item().Text(brojPreuzetih.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));
                        });

                        col.Item().Row(row =>
                        {
                            row.Spacing(10);

                            void Card(Action<IContainer> build) =>
                                row.RelativeItem()
                                   .Padding(12)
                                   .Background(Colors.Grey.Lighten4)
                                   .MinHeight(80)
                                   .AlignMiddle()
                                   .AlignCenter()
                                   .Element(build);

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("U toku").FontSize(11).AlignCenter();
                                col.Item().Text(brojUToku.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Završene").FontSize(11).AlignCenter();
                                col.Item().Text(brojZavrsenih.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Poništene").FontSize(11).AlignCenter();
                                col.Item().Text(brojPonistenih.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));
                        });


                        col.Item().PaddingTop(20);

                        col.Item()
                           .Text("Narudžbe po mjesecima")
                           .FontSize(15)
                           .Bold();

                        col.Item().Table(table =>
                        {
                            table.ColumnsDefinition(cd =>
                            {
                                cd.RelativeColumn(2);
                                cd.RelativeColumn();
                            });

                            table.Header(header =>
                            {
                                header.Cell().Background(Colors.Teal.Medium).Padding(6)
                                      .Text("Mjesec").FontColor(Colors.White);

                                header.Cell().Background(Colors.Teal.Medium).Padding(6)
                                      .AlignRight().Text("Broj narudžbi").FontColor(Colors.White);
                            });

                            string[] mjeseciNazivi =
                            {
                    "Jan","Feb","Mar","Apr","Maj","Jun",
                    "Jul","Avg","Sep","Okt","Nov","Dec"
                };

                            for (int i = 0; i < 12; i++)
                            {
                                table.Cell().Padding(6).Text(mjeseciNazivi[i]);
                                table.Cell().Padding(6).AlignRight().Text(poMjesecima[i].ToString());
                            }
                        });
                    });

                    page.Footer().AlignCenter().Text(text =>
                    {
                        text.CurrentPageNumber();
                        text.Span(" / ");
                        text.TotalPages()
                        .FontSize(10)
                        .FontColor(Colors.Grey.Darken1);
                    });
                });
            });

            return document.GeneratePdf();

        }

        public async Task<byte[]> AdminStatistikaPdf(string? stateMachine)
        {

            var ukupnoProcitanih = await _context.MojaLista
                .Where(x => !x.IsDeleted && x.JeProcitana)
                .CountAsync();

            var ukupnoArhiviranih = await _context.Arhivas
                .Where(x => !x.IsDeleted)
                .CountAsync();

            var ukupnoRecenzija =
                await _context.Recenzijas.Where(x => !x.IsDeleted).CountAsync() +
                await _context.RecenzijaOdgovors.Where(x => !x.IsDeleted).CountAsync();

            var ukupnoPreporuka =
                await _context.Preporukas.Where(x => !x.IsDeleted).CountAsync() +
                await _context.LicnaPreporukas.Where(x => !x.IsDeleted).CountAsync();

            var planiranaCitanja = await _context.MojaLista
                .Where(x => !x.IsDeleted && !x.JeProcitana)
                .CountAsync();

            var najdrazaKnjiga = await _arhivaService.GetNajdrazaKnjigaNazivAsync();



            var sveNarudzbe = _context.Narudzbas.Where(n => !n.IsDeleted);

            var filterQuery = sveNarudzbe;

            if (!string.IsNullOrWhiteSpace(stateMachine))
                filterQuery = filterQuery.Where(n => n.StateMachine == stateMachine);

            var ukupnoNarudzbi = await filterQuery.CountAsync();

            var poMjesecima = await _narudzbaService.GetBrojNarudzbiPoMjesecimaAsync(stateMachine);


            var document = Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Margin(40);

                    page.Header().AlignCenter()
                        .PaddingBottom(15)
                        .Text("Admin izvještaj sistema")
                        .FontSize(22)
                        .SemiBold()
                        .FontColor(Colors.Teal.Darken2);

                    page.Content().Column(col =>
                    {
                        col.Spacing(12);

                        col.Item().Text("Statistika korisnika").FontSize(16).Bold();
                        col.Item().LineHorizontal(1);

                        col.Item().Row(row =>
                        {
                            row.Spacing(10);

                            void Card(Action<IContainer> build) =>
                                row.RelativeItem()
                                   .Padding(12)
                                   .Background(Colors.Grey.Lighten4)
                                   .MinHeight(80)
                                   .AlignMiddle()
                                   .AlignCenter()
                                   .Element(build);

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Ukupno čitanja").FontSize(11).AlignCenter();
                                col.Item().Text(ukupnoProcitanih.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Arhiviranja").FontSize(11).AlignCenter();
                                col.Item().Text(ukupnoArhiviranih.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Recenzije").FontSize(11).AlignCenter();
                                col.Item().Text(ukupnoRecenzija.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));
                        });

                        col.Item().Row(row =>
                        {
                            row.Spacing(10);

                            void Card(Action<IContainer> build) =>
                                row.RelativeItem()
                                   .Padding(12)
                                   .Background(Colors.Grey.Lighten4)
                                   .MinHeight(80)
                                   .AlignMiddle()
                                   .AlignCenter()
                                   .Element(build);

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Preporuke").FontSize(11).AlignCenter();
                                col.Item().Text(ukupnoPreporuka.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Planirana čitanja").FontSize(11).AlignCenter();
                                col.Item().Text(planiranaCitanja.ToString())
                                    .FontSize(18).SemiBold()
                                    .AlignCenter()
                                    .FontColor(Colors.Teal.Darken2);
                            }));

                            Card(c => c.Column(col =>
                            {
                                col.Item().Text("Najdraža knjiga").FontSize(11).AlignCenter();
                                col.Item().Element(e =>
                                    e.MaxWidth(140)
                                     .Text(najdrazaKnjiga)
                                     .FontSize(12)
                                     .SemiBold()
                                     .AlignCenter()
                                     .FontColor(Colors.Teal.Darken2)
                                );
                            }));
                        });


                        col.Item().PaddingTop(20);

                        col.Item().Text("Statistika narudžbi").FontSize(16).Bold();
                        col.Item().Text($"Filter: {stateMachine ?? "Sve narudžbe"}").FontSize(12);

                        col.Item().PaddingTop(5);

                        col.Item().Text("Narudžbe po mjesecima").Bold();

                        col.Item().Table(table =>
                        {
                            table.ColumnsDefinition(cd =>
                            {
                                cd.RelativeColumn(2);
                                cd.RelativeColumn();
                            });

                            table.Header(h =>
                            {
                                h.Cell().Background(Colors.Teal.Medium).Padding(6).Text("Mjesec").FontColor(Colors.White);
                                h.Cell().Background(Colors.Teal.Medium).Padding(6).AlignRight().Text("Broj").FontColor(Colors.White);
                            });

                            string[] mjeseci = { "Jan", "Feb", "Mar", "Apr", "Maj", "Jun", "Jul", "Avg", "Sep", "Okt", "Nov", "Dec" };

                            for (int i = 0; i < 12; i++)
                            {
                                table.Cell().Padding(6).Text(mjeseci[i]);
                                table.Cell().Padding(6).AlignRight().Text(poMjesecima[i].ToString());
                            }
                        });
                    });

                    page.Footer().AlignCenter().Text(t =>
                    {
                        t.CurrentPageNumber(); t.Span(" / "); t.TotalPages();
                    });
                });
            });

            return document.GeneratePdf();
        }


        public async Task<byte[]> RadnikKreiranPdf(int radnikId, string plainPassword)
        {
            var radnik = await _context.Korisniks
                .Where(x => x.KorisnikId == radnikId && !x.IsDeleted)
                .Select(x => new
                {
                    x.Ime,
                    x.Prezime,
                    x.Email,
                    x.KorisnickoIme,
                    x.DatumRegistracije
                })
                .FirstOrDefaultAsync();

            if (radnik == null)
                throw new UserException("Radnik nije pronađen.");

            var document = Document.Create(container =>
            {
                container.Page(page =>
                {
                    page.Margin(40);

                    page.Header().AlignCenter()
                        .Text("Podaci o novom radniku")
                        .FontSize(22)
                        .SemiBold()
                        .FontColor(Colors.Teal.Darken2);

                    page.Content().Column(col =>
                    {
                        col.Spacing(10);

                        void Line(string label, string value)
                        {
                            col.Item().Row(row =>
                            {
                                row.RelativeItem(1).Text(label).SemiBold();
                                row.RelativeItem(2).Text(value);
                            });
                        }

                        col.Item().PaddingBottom(10);

                        Line("Ime:", radnik.Ime);
                        Line("Prezime:", radnik.Prezime);
                        Line("Email:", radnik.Email);
                        Line("Korisničko ime:", radnik.KorisnickoIme);
                        Line("Lozinka:", plainPassword);

                        col.Item().PaddingTop(15).Text(
                            "Ova lozinka je privremena i mora se promijeniti prilikom prve prijave.")
                            .FontColor(Colors.Red.Darken1);

                        col.Item().PaddingTop(20)
                            .LineHorizontal(1)
                            .LineColor(Colors.Grey.Lighten2);

                        col.Item().Text($"Datum kreiranja: {radnik.DatumRegistracije:dd.MM.yyyy HH:mm}")
                            .FontSize(10)
                            .FontColor(Colors.Grey.Darken1);
                    });

                    page.Footer().AlignCenter().Text(text =>
                    {
                        text.CurrentPageNumber();
                        text.Span(" / ");
                        text.TotalPages()
                        .FontSize(10);
                    });
                });
            });

            return document.GeneratePdf();
        }


    }
}
