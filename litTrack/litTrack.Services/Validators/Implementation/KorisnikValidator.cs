using litTrack.Model.Exceptions;
using litTrack.Model.Requests;
using litTrack.Services.Database;
using litTrack.Services.Validators.Interfaces;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Validators.Implementation
{
    public class KorisnikValidator : BaseValidatorService<Korisnik>, IKorisnikValidator
    {
        private readonly _210078Context _context;

        public KorisnikValidator(_210078Context context) : base(context)
        {
            _context = context;
        }

        public async Task ValidateInsertAsync(KorisnikInsertRequest korisnik, CancellationToken cancellationToken = default)
        {
            if (await _context.Korisniks.AnyAsync(x => x.KorisnickoIme == korisnik.KorisnickoIme && !x.IsDeleted, cancellationToken))
                throw new UserException($"Korisničko ime „{korisnik.KorisnickoIme}“ je zauzeto.");

            if (await _context.Korisniks.AnyAsync(x => x.Email == korisnik.Email && !x.IsDeleted, cancellationToken))
                throw new UserException($"E-mail „{korisnik.Email}“ je već registrovan.");

            if (korisnik.Lozinka != korisnik.LozinkaPotvrda)
                throw new UserException("Lozinka i potvrda lozinke nisu identične.");

            if (korisnik.Uloge is null || korisnik.Uloge.Count == 0)
                throw new UserException("Potrebno je odabrati barem jednu ulogu.");
        }


        public async Task ValidateUpdateAsync(int id, KorisnikUpdateRequest korisnik, CancellationToken cancellationToken = default)
        {
            if (!string.IsNullOrWhiteSpace(korisnik.Email))
            {
                bool zauzet = await _context.Korisniks
                    .AnyAsync(x => x.KorisnikId != id && x.Email == korisnik.Email && !x.IsDeleted, cancellationToken);

                if (zauzet)
                    throw new UserException($"Drugi korisnik već koristi e-mail „{korisnik.Email}“.");
            }
            
        }
    }
}
