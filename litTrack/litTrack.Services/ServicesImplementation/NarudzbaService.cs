using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.NarudzbaStateMachine;
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
    public class NarudzbaService : BaseCRUDServiceAsync<Model.DTOs.NarudzbaDTO, NarudzbaSearchObject, Database.Narudzba, NarudzbaInsertRequest, NarudzbaUpdateRequest>, INarudzbaService
    {
        private readonly BaseNarudzbaState _baseNarudzbaState;
        public NarudzbaService(_210078Context context, IMapper mapper
            ,BaseNarudzbaState baseNarudzbaState)
            : base(context, mapper)
        {
            _baseNarudzbaState = baseNarudzbaState;
        }

        public override IQueryable<Narudzba> AddFilter(NarudzbaSearchObject searchObject, IQueryable<Narudzba> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.Sifra))
            {
                query = query.Where(x => x.Sifra.ToLower().StartsWith(searchObject.Sifra.ToLower()));

            }


            if (searchObject.UkupnaCijena != null)
            {
                query = query.Where(x => x.UkupnaCijena == searchObject.UkupnaCijena);
            }

            if (searchObject.DatumNarudzbe != null)
            {
                query = query.Where(x => x.DatumNarudzbe.Date == searchObject.DatumNarudzbe.Value.Date);
            }

            if (searchObject.DatumNarudzbeGTE != null)
            {
                query = query.Where(x => x.DatumNarudzbe >= searchObject.DatumNarudzbeGTE);
            }

            if (searchObject.DatumNarudzbeLTE != null)
            {
                query = query.Where(x => x.DatumNarudzbe <= searchObject.DatumNarudzbeLTE);
            }

            if (searchObject.StateMachine != null && searchObject.StateMachine.Any())
            {
                query = query.Where(x => x.StateMachine != null && searchObject.StateMachine.Contains(x.StateMachine));
            }


            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (searchObject.NacinPlacanjaId != null)
            {
                query = query.Where(x => x.NacinPlacanjaId == searchObject.NacinPlacanjaId);
            }

            return query;
        }

        public override async Task<PagedResult<NarudzbaDTO>> GetPagedAsync(NarudzbaSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.Narudzbas
                .Include(n => n.Korisnik)
                .Include(n => n.NacinPlacanja)
                .Include(n => n.StavkaNarudzbes)
                .AsQueryable();

            query = AddFilter(search, query);

            int count = await query.CountAsync(cancellationToken);

            if (!string.IsNullOrEmpty(search?.OrderBy) && !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if (search?.Page.HasValue == true && search?.PageSize.HasValue == true)
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value).Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync(cancellationToken);

            var result = Mapper.Map<List<NarudzbaDTO>>(list);

            for (int i = 0; i < result.Count; i++)
            {
                var narudzba = list[i];

                if (narudzba.Korisnik != null)
                    result[i].ImePrezime = $"{narudzba.Korisnik.Ime} {narudzba.Korisnik.Prezime}";

                if (narudzba.NacinPlacanja != null)
                    result[i].NacinPlacanja = narudzba.NacinPlacanja.Naziv;

                result[i].BrojStavki = narudzba.StavkaNarudzbes?.Count ?? 0;
            }

            return new PagedResult<NarudzbaDTO>
            {
                ResultList = result,
                Count = count
            };
        }

        public override async Task<NarudzbaDTO> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas
                .Include(n => n.Korisnik)
                .Include(n => n.NacinPlacanja)
                .Include(n => n.StavkaNarudzbes)
                .FirstOrDefaultAsync(n => n.NarudzbaId == id, cancellationToken);

            if (narudzba == null)
                throw new UserException("Uneseni ID ne postoji.");

            var dto = Mapper.Map<NarudzbaDTO>(narudzba);

            if (narudzba.Korisnik != null)
                dto.ImePrezime = $"{narudzba.Korisnik.Ime} {narudzba.Korisnik.Prezime}";

            if (narudzba.NacinPlacanja != null)
                dto.NacinPlacanja = narudzba.NacinPlacanja.Naziv;

            dto.BrojStavki = narudzba.StavkaNarudzbes?.Count ?? 0;

            return dto;
        }


        public override async Task<NarudzbaDTO> InsertAsync(NarudzbaInsertRequest narudzba, CancellationToken cancellationToken = default)
        {
            var state = _baseNarudzbaState.CreateState("initial");
            return await state.Insert(narudzba, cancellationToken);
        }

        public override async Task<NarudzbaDTO> UpdateAsync(int narudzbaId, NarudzbaUpdateRequest narudzba, CancellationToken cancellationToken = default)
        {
            var entity = await Context.Narudzbas.FindAsync(new object[] { narudzbaId }, cancellationToken)
                ?? throw new UserException("Pogrešan ID narudžbe.");

            if (string.IsNullOrEmpty(entity.StateMachine))
                throw new UserException("State nije definiran za ovu narudžbu.");

            var state = _baseNarudzbaState.CreateState(entity.StateMachine);
            return await state.Update(narudzbaId, narudzba, cancellationToken);
        }

        public async Task<NarudzbaDTO> PreuzmiAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(new object[] { narudzbaId }, cancellationToken)
                ?? throw new UserException("Pogrešan ID narudžbe.");

            if (string.IsNullOrEmpty(narudzba.StateMachine))
                throw new UserException("State nije definiran za ovu narudžbu.");

            var state = _baseNarudzbaState.CreateState(narudzba.StateMachine);
            return await state.Preuzeta(narudzbaId, cancellationToken);
        }

        public async Task<NarudzbaDTO> UTokuAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(new object[] { narudzbaId }, cancellationToken)
                ?? throw new UserException("Pogrešan ID narudžbe.");

            if (string.IsNullOrEmpty(narudzba.StateMachine))
                throw new UserException("State nije definiran za ovu narudžbu.");

            var state = _baseNarudzbaState.CreateState(narudzba.StateMachine);
            return await state.UToku(narudzbaId, cancellationToken);
        }

        public async Task<NarudzbaDTO> ZavrsiAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(new object[] { narudzbaId }, cancellationToken)
                ?? throw new UserException("Pogrešan ID narudžbe.");

            if (string.IsNullOrEmpty(narudzba.StateMachine))
                throw new UserException("State nije definiran za ovu narudžbu.");

            var state = _baseNarudzbaState.CreateState(narudzba.StateMachine);
            return await state.Zavrsena(narudzbaId, cancellationToken);
        }

        public async Task<NarudzbaDTO> PonistiAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(new object[] { narudzbaId }, cancellationToken)
                ?? throw new UserException("Pogrešan ID narudžbe.");

            if (string.IsNullOrEmpty(narudzba.StateMachine))
                throw new UserException("State nije definiran za ovu narudžbu.");

            var state = _baseNarudzbaState.CreateState(narudzba.StateMachine);
            return await state.Ponistena(narudzbaId, cancellationToken);
        }

        public async Task<List<string>> AllowedActionsAsync(int narudzbaId, CancellationToken cancellationToken = default)
        {
            var narudzba = await Context.Narudzbas.FindAsync(new object[] { narudzbaId }, cancellationToken)
                ?? throw new UserException("Pogrešan ID narudžbe.");

            if (string.IsNullOrEmpty(narudzba.StateMachine))
                throw new UserException("State nije definiran za ovu narudžbu.");

            var state = _baseNarudzbaState.CreateState(narudzba.StateMachine);
            return state.AllowedActions(narudzba);
        }

    }
}
