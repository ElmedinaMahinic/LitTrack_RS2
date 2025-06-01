using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.Validators.Implementation;
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
    public class RecenzijaOdgovorService : BaseCRUDServiceAsync<Model.DTOs.RecenzijaOdgovorDTO, RecenzijaOdgovorSearchObject, Database.RecenzijaOdgovor, RecenzijaOdgovorInsertRequest, RecenzijaOdgovorUpdateRequest>, IRecenzijaOdgovorService
    {
        private readonly IKorisnikValidator _korisnikValidator;
        private readonly IRecenzijaValidator _recenzijaValidator;
        public RecenzijaOdgovorService(_210078Context context, IMapper mapper, IKorisnikValidator korisnikValidator,
            IRecenzijaValidator recenzijaValidator)
            : base(context, mapper)
        {
            _korisnikValidator = korisnikValidator;
            _recenzijaValidator = recenzijaValidator;
        }

        public override IQueryable<Database.RecenzijaOdgovor> AddFilter(RecenzijaOdgovorSearchObject searchObject, IQueryable<Database.RecenzijaOdgovor> query)
        {
            query = base.AddFilter(searchObject, query);


            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }


            if (searchObject.RecenzijaId != null)
            {
                query = query.Where(x => x.RecenzijaId == searchObject.RecenzijaId);
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

            return query;
        }

        public override async Task<PagedResult<RecenzijaOdgovorDTO>> GetPagedAsync(RecenzijaOdgovorSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.RecenzijaOdgovors.Include(o => o.Korisnik).Where(o => !o.IsDeleted);

            query = AddFilter(search, query);

            int count = await query.CountAsync(cancellationToken);

            if (!string.IsNullOrEmpty(search?.OrderBy) &&
                !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query
                    .Skip((search.Page.Value - 1) * search.PageSize.Value)
                    .Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync(cancellationToken);
            var result = Mapper.Map<List<RecenzijaOdgovorDTO>>(list);

            for (int i = 0; i < result.Count; i++)
            {
                var korisnik = list[i].Korisnik;
                if (korisnik is null) continue;

                result[i].KorisnickoIme = korisnik.KorisnickoIme;
            }

            return new PagedResult<RecenzijaOdgovorDTO>
            {
                ResultList = result,
                Count = count
            };
        }


        public override async Task BeforeInsertAsync(RecenzijaOdgovorInsertRequest request, Database.RecenzijaOdgovor entity, CancellationToken cancellationToken = default)
        {
            await _korisnikValidator.ValidateEntityExistsAsync(request.KorisnikId, cancellationToken);
            await _recenzijaValidator.ValidateEntityExistsAsync(request.RecenzijaId, cancellationToken);

            entity.BrojLajkova = 0;
            entity.BrojDislajkova = 0;
            entity.IsDeleted= false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public async Task ToggleLikeAsync(int recenzijaOdgovorId, int korisnikId, CancellationToken cancellationToken = default)
        {
            var odgovor = await Context.RecenzijaOdgovors
                .FirstOrDefaultAsync(x => x.RecenzijaOdgovorId == recenzijaOdgovorId && !x.IsDeleted, cancellationToken);

            if (odgovor == null)
                throw new UserException("Odgovor na recenziju ne postoji.");

            var reakcija = await Context.RecenzijaOdgovorReakcijas
                .FirstOrDefaultAsync(x => x.RecenzijaOdgovorId == recenzijaOdgovorId &&
                                           x.KorisnikId == korisnikId &&
                                           !x.IsDeleted, cancellationToken);

            if (reakcija == null)
            {
                await Context.RecenzijaOdgovorReakcijas.AddAsync(new RecenzijaOdgovorReakcija
                {
                    RecenzijaOdgovorId = recenzijaOdgovorId,
                    KorisnikId = korisnikId,
                    JeLajk = true,
                    IsDeleted = false
                }, cancellationToken);

                odgovor.BrojLajkova++;
            }
            else if (reakcija.JeLajk)
            {
                reakcija.IsDeleted = true;
                reakcija.VrijemeBrisanja = DateTime.Now;
                odgovor.BrojLajkova--;
            }
            else
            {
                reakcija.JeLajk = true;
                reakcija.DatumReakcije = DateTime.Now;
                odgovor.BrojLajkova++;
                odgovor.BrojDislajkova--;
            }

            if (odgovor.BrojLajkova < 0 || odgovor.BrojDislajkova < 0)
                throw new UserException("Broj lajkova ili dislajkova ne može biti negativan.");

            await Context.SaveChangesAsync(cancellationToken);
        }

        public async Task ToggleDislikeAsync(int recenzijaOdgovorId, int korisnikId, CancellationToken cancellationToken = default)
        {
            var odgovor = await Context.RecenzijaOdgovors
                .FirstOrDefaultAsync(x => x.RecenzijaOdgovorId == recenzijaOdgovorId && !x.IsDeleted, cancellationToken);

            if (odgovor == null)
                throw new UserException("Odgovor na recenziju ne postoji.");

            var reakcija = await Context.RecenzijaOdgovorReakcijas
                .FirstOrDefaultAsync(x => x.RecenzijaOdgovorId == recenzijaOdgovorId &&
                                           x.KorisnikId == korisnikId &&
                                           !x.IsDeleted, cancellationToken);

            if (reakcija == null)
            {
                await Context.RecenzijaOdgovorReakcijas.AddAsync(new RecenzijaOdgovorReakcija
                {
                    RecenzijaOdgovorId = recenzijaOdgovorId,
                    KorisnikId = korisnikId,
                    JeLajk = false,
                    IsDeleted = false
                }, cancellationToken);

                odgovor.BrojDislajkova++;
            }
            else if (!reakcija.JeLajk)
            {
                reakcija.IsDeleted = true;
                reakcija.VrijemeBrisanja = DateTime.Now;
                odgovor.BrojDislajkova--;
            }
            else
            {
                reakcija.JeLajk = false;
                reakcija.DatumReakcije = DateTime.Now;
                odgovor.BrojDislajkova++;
                odgovor.BrojLajkova--;
            }

            if (odgovor.BrojLajkova < 0 || odgovor.BrojDislajkova < 0)
                throw new UserException("Broj lajkova ili dislajkova ne može biti negativan.");

            await Context.SaveChangesAsync(cancellationToken);
        }
    }
}
