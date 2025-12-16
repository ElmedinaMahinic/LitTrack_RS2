using litTrack.Model.DTOs;
using litTrack.Model.Requests;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.Validators.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.NarudzbaStateMachine
{
    public class InitialNarudzbaState : BaseNarudzbaState
    {
        private readonly INarudzbaValidator _narudzbaValidator;
        private readonly IStavkaNarudzbeValidator _stavkaNarudzbeValidator;
        private readonly IKnjigaValidator _knjigaValidator;
        private readonly IObavijestService _obavijestService;
        public InitialNarudzbaState(_210078Context context, IMapper mapper,
            IServiceProvider serviceProvider, 
            INarudzbaValidator narudzbaValidator, IStavkaNarudzbeValidator stavkaNarudzbeValidator,
            IKnjigaValidator knjigaValidator, IObavijestService obavijestService)
            : base(context, mapper, serviceProvider)
        {
            _narudzbaValidator = narudzbaValidator;
            _stavkaNarudzbeValidator = stavkaNarudzbeValidator;
            _knjigaValidator = knjigaValidator;
            _obavijestService = obavijestService;
        }

        public override async Task<NarudzbaDTO> Insert(NarudzbaInsertRequest narudzba, CancellationToken cancellationToken = default)
        {
            await _narudzbaValidator.ValidateInsertAsync(narudzba, cancellationToken);

            var entity = Mapper.Map<Database.Narudzba>(narudzba);

            entity.Sifra = $"NAR-{DateTime.UtcNow:yyyyMMddHHmmss}-{Random.Shared.Next(1000, 9999)}";
            entity.StateMachine = "kreirana";
            entity.IsDeleted = false;
            entity.UkupnaCijena = 0m;

            Context.Narudzbas.Add(entity);
            await Context.SaveChangesAsync(cancellationToken); 

            decimal ukupno = 0;

            foreach (var stavka in narudzba.StavkeNarudzbe)
            {
                await _stavkaNarudzbeValidator.ValidateInsertAsync(stavka, cancellationToken);
                await _knjigaValidator.ValidateEntityExistsAsync(stavka.KnjigaId, cancellationToken);

                var knjiga = await Context.Knjigas
                    .AsNoTracking()
                    .FirstAsync(k => k.KnjigaId == stavka.KnjigaId && !k.IsDeleted, cancellationToken);

                var stavkaEnt = new Database.StavkaNarudzbe
                {
                    NarudzbaId = entity.NarudzbaId,  
                    KnjigaId = stavka.KnjigaId,
                    Kolicina = stavka.Kolicina,
                    Cijena = knjiga.Cijena,
                    IsDeleted = false
                };

                Context.StavkaNarudzbes.Add(stavkaEnt);

                ukupno += knjiga.Cijena * stavka.Kolicina;
            }

            entity.UkupnaCijena = ukupno;
            await Context.SaveChangesAsync(cancellationToken);

            var radnici = await Context.Korisniks
                .Where(k => !k.IsDeleted && k.KorisnikUlogas.Any(u => u.Uloga.Naziv == "Radnik"))
                .ToListAsync(cancellationToken);

            foreach (var radnik in radnici)
            {
                var obavijest = new ObavijestInsertRequest
                {
                    KorisnikId = radnik.KorisnikId,
                    Naslov = "Nova narudžba",
                    Sadrzaj = $"Poštovani, kreirana je nova narudžba broj {entity.Sifra}. Molimo vas da preuzmete narudžbu i krenete sa obradom."
                };

                await _obavijestService.InsertAsync(obavijest, cancellationToken);
            }

            return Mapper.Map<NarudzbaDTO>(entity);
        }

        public override List<string> AllowedActions(Database.Narudzba entity)
        {
            return new List<string> { nameof(Insert) };
        }


    }
}
