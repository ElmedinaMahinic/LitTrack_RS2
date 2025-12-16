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
    public class PreuzetaNarudzbaState : BaseNarudzbaState
    {
        private readonly IObavijestService _obavijestService;
        public PreuzetaNarudzbaState(_210078Context context, IMapper mapper, IServiceProvider serviceProvider,
             IObavijestService obavijestService)
        : base(context, mapper, serviceProvider)
        {
            _obavijestService = obavijestService;
        }

        public override async Task<NarudzbaDTO> UToku(int narudzbaId, CancellationToken cancellationToken)
        {
            var set = Context.Set<Database.Narudzba>();
            var entity = await set.FindAsync(new object[] { narudzbaId }, cancellationToken);

            if (entity == null)
                throw new UserException("Narudžba nije pronađena.");

            entity.StateMachine = "uToku";
            await Context.SaveChangesAsync(cancellationToken);

            var kupac = await Context.Korisniks
        .FirstOrDefaultAsync(k => k.KorisnikId == entity.KorisnikId && !k.IsDeleted, cancellationToken);

            if (kupac != null)
            {
                var obavijest = new ObavijestInsertRequest
                {
                    KorisnikId = kupac.KorisnikId,
                    Naslov = "Narudžba je poslana",
                    Sadrzaj =
                        $"Poštovanje {kupac.Ime},\n\n" +
                        $"Vaša narudžba #{entity.Sifra} je uspješno zapakovana i poslana.\n\n" +
                        $"Detalji narudžbe:\n" +
                        $"- Broj narudžbe: {entity.Sifra}\n" +
                        $"- Kupac: {kupac.Ime} {kupac.Prezime}\n" +
                        $"- Datum narudžbe: {entity.DatumNarudzbe:dd.MM.yyyy HH:mm}\n" +
                        $"- Ukupan iznos: {entity.UkupnaCijena} KM\n\n" +
                        $"Hvala Vam na narudžbi,\nVaš LitTrack tim"
                };

                await _obavijestService.InsertAsync(obavijest, cancellationToken);
            }

            return Mapper.Map<NarudzbaDTO>(entity);
        }

        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string> { nameof(UToku) };
        }
    }
}
