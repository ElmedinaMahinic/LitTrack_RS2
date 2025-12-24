using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.Auth;
using litTrack.Services.BaseServicesImplementation;
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

namespace litTrack.Services.ServicesImplementation
{
    public class RecenzijaService : BaseCRUDServiceAsync<Model.DTOs.RecenzijaDTO, RecenzijaSearchObject, Database.Recenzija, RecenzijaInsertRequest, RecenzijaUpdateRequest>, IRecenzijaService
    {
        private readonly IKorisnikValidator _korisnikValidator;
        private readonly IKnjigaValidator _knjigaValidator;
        private readonly IRecenzijaOdgovorService _recenzijaOdgovorService;
        private readonly IActiveUserServiceAsync _activeUserService;
        public RecenzijaService(_210078Context context, IMapper mapper, IKorisnikValidator korisnikValidator,
            IKnjigaValidator knjigaValidator, IRecenzijaOdgovorService recenzijaOdgovorService,
            IActiveUserServiceAsync activeUserService)
            : base(context, mapper)
        {
            _korisnikValidator = korisnikValidator;
            _knjigaValidator = knjigaValidator;
            _recenzijaOdgovorService = recenzijaOdgovorService;
            _activeUserService = activeUserService;
        }

        public override IQueryable<Database.Recenzija> AddFilter(RecenzijaSearchObject searchObject, IQueryable<Database.Recenzija> query)
        {
            query = base.AddFilter(searchObject, query);


            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }


            if (searchObject.KnjigaId != null)
            {
                query = query.Where(x => x.KnjigaId == searchObject.KnjigaId);
            }


            if (searchObject.DatumDodavanjaGTE != null)
            {
                query = query.Where(x => x.DatumDodavanja >= searchObject.DatumDodavanjaGTE);
            }

            if (searchObject.DatumDodavanjaLTE != null)
            {
                query = query.Where(x => x.DatumDodavanja <= searchObject.DatumDodavanjaLTE);
            }


            if (searchObject.BrojLajkovaGTE != null)
            {
                query = query.Where(x => x.BrojLajkova >= searchObject.BrojLajkovaGTE);
            }

            if (searchObject.BrojLajkovaLTE != null)
            {
                query = query.Where(x => x.BrojLajkova <= searchObject.BrojLajkovaLTE);
            }


            if (searchObject.BrojDislajkovaGTE != null)
            {
                query = query.Where(x => x.BrojDislajkova >= searchObject.BrojDislajkovaGTE);
            }

            if (searchObject.BrojDislajkovaLTE != null)
            {
                query = query.Where(x => x.BrojDislajkova <= searchObject.BrojDislajkovaLTE);
            }

            if (!string.IsNullOrWhiteSpace(searchObject.KorisnickoIme))
            {
                var korisnickoImeLower = searchObject.KorisnickoIme.ToLower();
                query = query
                    .Include(x => x.Korisnik)
                    .Where(x => x.Korisnik.KorisnickoIme.ToLower().Contains(korisnickoImeLower));
            }

            return query;
        }

        public override async Task<PagedResult<RecenzijaDTO>> GetPagedAsync(RecenzijaSearchObject search, CancellationToken cancellationToken = default)
        {
            var currentUserId = await _activeUserService.GetActiveUserIdAsync(cancellationToken);

            var query = Context.Recenzijas
                .Include(r => r.Korisnik)
                .Include(r => r.RecenzijaReakcijas)
                .Where(r => !r.IsDeleted);

            query = AddFilter(search, query);

            int count = await query.CountAsync(cancellationToken);

            if (!string.IsNullOrEmpty(search?.OrderBy) && !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync(cancellationToken);
            var result = Mapper.Map<List<RecenzijaDTO>>(list);

            for (int i = 0; i < result.Count; i++)
            {
                var entity = list[i];

                var korisnik = entity.Korisnik;
                if (korisnik != null)
                    result[i].KorisnickoIme = korisnik.KorisnickoIme;

                if (currentUserId == null)
                {
                    result[i].JeLajkovao = false;
                    result[i].JeDislajkovao = false;
                    continue;
                }

                var reakcija = entity.RecenzijaReakcijas
                    .FirstOrDefault(x => x.KorisnikId == currentUserId && !x.IsDeleted);

                result[i].JeLajkovao = reakcija != null && reakcija.JeLajk;
                result[i].JeDislajkovao = reakcija != null && !reakcija.JeLajk;
            }

            return new PagedResult<RecenzijaDTO>
            {
                ResultList = result,
                Count = count
            };
        }



        public override async Task BeforeInsertAsync(RecenzijaInsertRequest request, Database.Recenzija entity, CancellationToken cancellationToken = default)
        {

            var postojiRecenzija = await Context.Recenzijas
                .AnyAsync(x => x.KorisnikId == request.KorisnikId && x.KnjigaId == request.KnjigaId 
                && !x.IsDeleted, cancellationToken);

            if (postojiRecenzija)
            {
                throw new UserException("Već ste ostavili recenziju za ovu knjigu.");
            }

            var jeProcitana = await Context.MojaLista
            .AnyAsync(x => x.KorisnikId == request.KorisnikId && x.KnjigaId == request.KnjigaId 
            && x.JeProcitana == true && !x.IsDeleted,
            cancellationToken);

            if (!jeProcitana)
            {
                throw new UserException("Možete recenzirati samo knjige koje ste pročitali.");
            }

            await _korisnikValidator.ValidateEntityExistsAsync(request.KorisnikId, cancellationToken);
            await _knjigaValidator.ValidateEntityExistsAsync(request.KnjigaId, cancellationToken);

            entity.BrojLajkova = 0;
            entity.BrojDislajkova = 0;
            entity.IsDeleted= false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public async Task ToggleLikeAsync(int recenzijaId, int korisnikId, CancellationToken cancellationToken = default)
        {
            var recenzija = await Context.Recenzijas
                .FirstOrDefaultAsync(x => x.RecenzijaId == recenzijaId && !x.IsDeleted, cancellationToken);

            if (recenzija == null)
                throw new UserException("Recenzija ne postoji.");

            if (recenzija.KorisnikId == korisnikId)
                throw new UserException("Ne možete lajkovati vlastitu recenziju.");

            var reakcija = await Context.RecenzijaReakcijas
                .FirstOrDefaultAsync(x => x.RecenzijaId == recenzijaId && x.KorisnikId == korisnikId && !x.IsDeleted, cancellationToken);

            if (reakcija == null)
            {
                await Context.RecenzijaReakcijas.AddAsync(new RecenzijaReakcija
                {
                    RecenzijaId = recenzijaId,
                    KorisnikId = korisnikId,
                    JeLajk = true,
                    IsDeleted= false
                }, cancellationToken);

                recenzija.BrojLajkova++;
            }
            else if (reakcija.JeLajk)
            {
                reakcija.IsDeleted = true;
                reakcija.VrijemeBrisanja = DateTime.Now;
                recenzija.BrojLajkova--;
            }
            else
            {
                reakcija.JeLajk = true;
                reakcija.DatumReakcije = DateTime.Now;
                recenzija.BrojLajkova++;
                recenzija.BrojDislajkova--;
            }

            if (recenzija.BrojLajkova < 0 || recenzija.BrojDislajkova < 0)
            {
                throw new UserException("Broj lajkova ili dislajkova ne može biti negativan.");
            }

            await Context.SaveChangesAsync(cancellationToken);
            
        }

        public async Task ToggleDislikeAsync(int recenzijaId, int korisnikId, CancellationToken cancellationToken = default)
        {
            var recenzija = await Context.Recenzijas
                .FirstOrDefaultAsync(x => x.RecenzijaId == recenzijaId && !x.IsDeleted, cancellationToken);

            if (recenzija == null)
                throw new UserException("Recenzija ne postoji.");

            if (recenzija.KorisnikId == korisnikId)
            {
                throw new UserException("Ne možete dislajkovati vlastitu recenziju.");
            }


            var reakcija = await Context.RecenzijaReakcijas
                .FirstOrDefaultAsync(x => x.RecenzijaId == recenzijaId && x.KorisnikId == korisnikId && !x.IsDeleted, cancellationToken);

            if (reakcija == null)
            {
                await Context.RecenzijaReakcijas.AddAsync(new RecenzijaReakcija
                {
                    RecenzijaId = recenzijaId,
                    KorisnikId = korisnikId,
                    JeLajk = false,
                    IsDeleted= false
                }, cancellationToken);

                recenzija.BrojDislajkova++;
            }
            else if (!reakcija.JeLajk)
            {
                reakcija.IsDeleted = true;
                reakcija.VrijemeBrisanja = DateTime.Now;
                recenzija.BrojDislajkova--;
            }
            else
            {
                reakcija.JeLajk = false;
                reakcija.DatumReakcije = DateTime.Now;
                recenzija.BrojDislajkova++;
                recenzija.BrojLajkova--;
            }

            if (recenzija.BrojLajkova < 0 || recenzija.BrojDislajkova < 0)
            {
                throw new UserException("Broj lajkova ili dislajkova ne može biti negativan.");
            }


            await Context.SaveChangesAsync(cancellationToken);
            
        }

        public override async Task BeforeDeleteAsync(Database.Recenzija entity, CancellationToken cancellationToken)
        {
            var odgovori = await Context.RecenzijaOdgovors
                .Where(x => x.RecenzijaId == entity.RecenzijaId)
                .ToListAsync(cancellationToken);

            foreach (var odgovor in odgovori)
            {
                await _recenzijaOdgovorService.DeleteAsync(odgovor.RecenzijaOdgovorId, cancellationToken);
            }

            await base.BeforeDeleteAsync(entity, cancellationToken);
        }
    }
}
