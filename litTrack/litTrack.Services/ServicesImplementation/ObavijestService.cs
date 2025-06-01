using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.ServicesImplementation
{
    public class ObavijestService : BaseCRUDServiceAsync<Model.DTOs.ObavijestDTO, ObavijestSearchObject, Database.Obavijest, ObavijestInsertRequest, ObavijestUpdateRequest>, IObavijestService
    {
        public ObavijestService(_210078Context context, IMapper mapper)
            : base(context, mapper)
        {

        }

        public override IQueryable<Database.Obavijest> AddFilter(ObavijestSearchObject searchObject, IQueryable<Database.Obavijest> query)
        {
            query = base.AddFilter(searchObject, query);

            if (searchObject.KorisnikId != null)
            {
                query = query.Where(x => x.KorisnikId == searchObject.KorisnikId);
            }

            if (!string.IsNullOrWhiteSpace(searchObject.Naslov))
            {
                query = query.Where(x => x.Naslov.ToLower().Contains(searchObject.Naslov.ToLower()));
            }

            if (searchObject.DatumObavijestiGTE != null)
            {
                query = query.Where(x => x.DatumObavijesti >= searchObject.DatumObavijestiGTE);
            }

            if (searchObject.DatumObavijestiLTE != null)
            {
                query = query.Where(x => x.DatumObavijesti <= searchObject.DatumObavijestiLTE);
            }

            if (searchObject.JePogledana != null)
            {
                query = query.Where(x => x.JePogledana == searchObject.JePogledana);
            }

            return query;
        }

        public override async Task<PagedResult<ObavijestDTO>> GetPagedAsync(ObavijestSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.Obavijests.Include(o => o.Korisnik).Where(o => !o.IsDeleted);

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
            var result = Mapper.Map<List<ObavijestDTO>>(list);

            for (int i = 0; i < result.Count; i++)
            {
                var korisnik = list[i].Korisnik;
                if (korisnik is null) continue;

                result[i].ImePrezime = $"{korisnik.Ime} {korisnik.Prezime}";
            }

            return new PagedResult<ObavijestDTO>
            {
                ResultList = result,
                Count = count
            };
        }

        public override async Task<ObavijestDTO> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var obavijest = await Context.Obavijests
                .Include(o => o.Korisnik)
                .FirstOrDefaultAsync(o => o.ObavijestId == id && !o.IsDeleted, cancellationToken);

            if (obavijest == null)
                throw new UserException("Uneseni ID ne postoji.");

            var dto = Mapper.Map<ObavijestDTO>(obavijest);

            if (obavijest.Korisnik != null)
                dto.ImePrezime = $"{obavijest.Korisnik.Ime} {obavijest.Korisnik.Prezime}";

            return dto;
        }



        public override Task BeforeInsertAsync(ObavijestInsertRequest request, Database.Obavijest entity, CancellationToken cancellationToken = default)
        {

            entity.IsDeleted = false;
            entity.JePogledana = false;

            return base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public async Task OznaciKaoProcitanuAsync(int obavijestId, CancellationToken cancellationToken = default)
        {
            var obavijest = await Context.Obavijests
        .FirstOrDefaultAsync(o => o.ObavijestId == obavijestId && !o.IsDeleted, cancellationToken);

            if (obavijest == null)
                throw new UserException("Obavijest nije pronađena.");

            if (!obavijest.JePogledana)
            {
                obavijest.JePogledana = true;
                await Context.SaveChangesAsync(cancellationToken);
            }
        }

    }
}
