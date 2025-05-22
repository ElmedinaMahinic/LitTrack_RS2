using Azure.Core;
using litTrack.Model.Exceptions;
using litTrack.Model.Requests;
using litTrack.Services.Database;
using litTrack.Services.Validators.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Dynamic.Core.Tokenizer;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Implementation
{
    public class KnjigaValidator : BaseValidatorService<Knjiga>, IKnjigaValidator
    {
        private readonly _210078Context _context;

        public KnjigaValidator(_210078Context context) : base(context)
        {
            _context = context;
        }

        public async Task ValidateInsertAsync(KnjigaInsertRequest knjiga, CancellationToken cancellationToken = default)
        {
            bool postoji = await _context.Knjigas.AnyAsync(
            x => x.Naziv == knjiga.Naziv &&
            x.AutorId == knjiga.AutorId &&
                 x.GodinaIzdavanja == knjiga.GodinaIzdavanja &&
                 !x.IsDeleted,
            cancellationToken);

            if (postoji)
                throw new UserException($"Knjiga „{knjiga.Naziv}“ autora #{knjiga.AutorId} iz {knjiga.GodinaIzdavanja}. već postoji!");

            if (knjiga.GodinaIzdavanja > DateTime.Today.Year)
                throw new UserException("Godina izdavanja ne može biti u budućnosti.");

            if (knjiga.GodinaIzdavanja < 1450)
                throw new UserException("Godina izdavanja ne može biti manja od 1450.");

            if (knjiga.Zanrovi is null || knjiga.Zanrovi.Count == 0)
                throw new UserException("Potrebno je odabrati barem jedan žanr.");

            if (knjiga.CiljneGrupe is null || knjiga.CiljneGrupe.Count == 0)
                throw new UserException("Potrebno je odabrati barem jednu ciljnu grupu.");

        }

        public async Task ValidateUpdateAsync(int id, KnjigaUpdateRequest knjiga, CancellationToken cancellationToken = default)
        {
            bool postoji = await _context.Knjigas.AnyAsync(
           x => x.KnjigaId != id &&
                x.Naziv == knjiga.Naziv &&
                x.AutorId == knjiga.AutorId &&
                x.GodinaIzdavanja == knjiga.GodinaIzdavanja &&
                !x.IsDeleted,
           cancellationToken);

            if (postoji)
                throw new UserException(
                    $"Druga knjiga „{knjiga.Naziv}“ istog autora i godine već postoji!");

            if (knjiga.GodinaIzdavanja > DateTime.Today.Year)
                throw new UserException("Godina izdavanja ne može biti u budućnosti.");

            if (knjiga.GodinaIzdavanja < 1450)
                throw new UserException("Godina izdavanja ne može biti manja od 1450.");

            if (knjiga.Zanrovi != null)
            {
                if (knjiga.Zanrovi.Count == 0)
                    throw new UserException("Potrebno je odabrati barem jedan žanr.");
            }

            if (knjiga.CiljneGrupe != null)
            {
                if (knjiga.CiljneGrupe.Count == 0)
                    throw new UserException("Potrebno je odabrati barem jednu ciljnu grupu.");
            }

        }

        public override void ValidateNoDuplicates(List<int> array)
        {
            if (array == null)
                throw new UserException("Lista knjiga ne smije biti prazna!");

            if (array.Count != array.Distinct().Count())
                throw new UserException("Ne možete unijeti istu knjigu više puta!");
        }
    }
}
