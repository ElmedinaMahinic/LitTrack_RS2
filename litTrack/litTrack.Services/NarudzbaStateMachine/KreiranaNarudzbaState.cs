using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Requests;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.NarudzbaStateMachine
{
    public class KreiranaNarudzbaState : BaseNarudzbaState
    {
        private readonly IObavijestService _obavijestService;
        public KreiranaNarudzbaState(_210078Context context, IMapper mapper, IServiceProvider serviceProvider,
            IObavijestService obavijestService)
       : base(context, mapper, serviceProvider)
        {
            _obavijestService = obavijestService;
        }

        public override async Task<NarudzbaDTO> Update(int narudzbaId, NarudzbaUpdateRequest request, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = await set.FindAsync(new object[] { narudzbaId }, cancellationToken);

            if (entity == null)
                throw new UserException("Narudžba nije pronađena");

            Mapper.Map(request, entity);
            await Context.SaveChangesAsync(cancellationToken);

            return Mapper.Map<NarudzbaDTO>(entity);
        }

        public override async Task<NarudzbaDTO> Preuzeta(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = await set.FindAsync(new object[] { narudzbaId }, cancellationToken);

            if (entity == null)
                throw new UserException("Narudžba nije pronađena");

            entity.StateMachine = "preuzeta";
            await Context.SaveChangesAsync(cancellationToken);

            var kupac = await Context.Korisniks
        .FirstOrDefaultAsync(k => k.KorisnikId == entity.KorisnikId && !k.IsDeleted, cancellationToken);

            if (kupac != null)
            {
                var obavijest = new ObavijestInsertRequest
                {
                    KorisnikId = kupac.KorisnikId,
                    Naslov = "Narudžba je zaprimljena",
                    Sadrzaj =
                        $"Poštovanje {kupac.Ime},\n\n" +
                        $"Vaša narudžba #{entity.Sifra} je uspješno zaprimljena {DateTime.Now:dd.MM.yyyy}. Trenutno je u obradi.\n\n" +
                        $"Detalji narudžbe:\n" +
                        $"- Broj narudžbe: {entity.Sifra}\n" +
                        $"- Kupac: {kupac.Ime} {kupac.Prezime}\n" +
                        $"- Datum narudžbe: {entity.DatumNarudzbe:dd.MM.yyyy HH:mm}\n" +
                        $"- Ukupan iznos: {entity.UkupnaCijena} KM\n\n" +
                        $"Dalji status narudžbe možete pratiti u sekciji Obavijesti.\n\n" +
                        $"Hvala Vam na narudžbi,\n" +
                        $"Vaš LitTrack tim"
                };


                await _obavijestService.InsertAsync(obavijest, cancellationToken);
            }

            return Mapper.Map<NarudzbaDTO>(entity);
        }

        public override async Task<NarudzbaDTO> Ponistena(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = await set.FindAsync(new object[] { narudzbaId }, cancellationToken);

            if (entity == null)
                throw new UserException("Narudžba nije pronađena");

            entity.StateMachine = "ponistena";
            await Context.SaveChangesAsync(cancellationToken);

            var radnici = await Context.Korisniks
                .Where(k => !k.IsDeleted && k.KorisnikUlogas.Any(u => u.Uloga.Naziv == "Radnik"))
                .ToListAsync(cancellationToken);

            foreach (var radnik in radnici)
            {
                var obavijest = new ObavijestInsertRequest
                {
                    KorisnikId = radnik.KorisnikId,
                    Naslov = "Poništena narudžba",
                    Sadrzaj = $"Poštovani, narudžba {entity.Sifra} je poništena."
                };

                await _obavijestService.InsertAsync(obavijest, cancellationToken);
            }

            return Mapper.Map<NarudzbaDTO>(entity);
        }


        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string>() { nameof(Update), nameof(Preuzeta), nameof(Ponistena) };
        }
    }
}
