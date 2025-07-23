using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Helpers;
using litTrack.Model.Requests;
using litTrack.Model.SearchObjects;
using litTrack.Services.BaseServicesImplementation;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.Validators.Interfaces;
using MapsterMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.ServicesImplementation
{
    public class KnjigaService : BaseCRUDServiceAsync<KnjigaDTO, KnjigaSearchObject, Knjiga, KnjigaInsertRequest, KnjigaUpdateRequest>, IKnjigaService
    {
        private readonly IZanrValidator _zanrValidator;
        private readonly ICiljnaGrupaValidator _ciljnaGrupaValidator;
        private readonly IAutorValidator _autorValidator;
        private readonly IKnjigaValidator _knjigaValidator;
        public KnjigaService(_210078Context context, IMapper mapper, IZanrValidator zanrValidator,
            ICiljnaGrupaValidator ciljnaGrupaValidator, IKnjigaValidator knjigaValidator,
            IAutorValidator autorValidator
         )
            : base(context, mapper)
        {
            _zanrValidator = zanrValidator;
            _ciljnaGrupaValidator = ciljnaGrupaValidator;
            _knjigaValidator = knjigaValidator;
            _autorValidator = autorValidator;
        }

        public override IQueryable<Knjiga> AddFilter(KnjigaSearchObject searchObject, IQueryable<Knjiga> query)
        {
            query = base.AddFilter(searchObject, query);

            if (!string.IsNullOrWhiteSpace(searchObject.Naziv))
            {
                var lower = searchObject.Naziv.ToLower();
                query = query.Where(k => k.Naziv.ToLower().Contains(lower));
            }

            if (searchObject.GodinaIzdavanjaGTE != null)
            {
                query = query.Where(x => x.GodinaIzdavanja >= searchObject.GodinaIzdavanjaGTE);
            }

            if (searchObject.GodinaIzdavanjaLTE != null)
            {
                query = query.Where(x => x.GodinaIzdavanja <= searchObject.GodinaIzdavanjaLTE);
            }

            if (searchObject.CijenaGTE != null)
            {
                query = query.Where(x => x.Cijena >= searchObject.CijenaGTE);
            }

            if (searchObject.CijenaLTE != null)
            {
                query = query.Where(x => x.Cijena <= searchObject.CijenaLTE);
            }


            if (searchObject.AutorId != null)
            {
                query = query.Where(x => x.AutorId == searchObject.AutorId);
            }

            if (!string.IsNullOrWhiteSpace(searchObject.AutorNaziv))
            {
                var autorNaziv = searchObject.AutorNaziv.ToLower();

                query = query.Include(k => k.Autor)
                             .Where(k =>
                                 (k.Autor.Ime + " " + k.Autor.Prezime).ToLower().Contains(autorNaziv) ||
                                 k.Autor.Ime.ToLower().Contains(autorNaziv) ||
                                 k.Autor.Prezime.ToLower().Contains(autorNaziv));
            }



            if (searchObject.ZanrId != null)
            {
                query = query.Where(k => k.KnjigaZanrs.Any(kz => kz.ZanrId == searchObject.ZanrId))
                             .Include(k => k.KnjigaZanrs).ThenInclude(kz => kz.Zanr);
            }

            if (searchObject.CiljnaGrupaId != null)
            {
                query = query.Where(k => k.KnjigaCiljnaGrupas.Any(kcg => kcg.CiljnaGrupaId == searchObject.CiljnaGrupaId))
                             .Include(k => k.KnjigaCiljnaGrupas).ThenInclude(kcg => kcg.CiljnaGrupa);
            }


            return query;
        }

        public override async Task<PagedResult<KnjigaDTO>> GetPagedAsync(KnjigaSearchObject search, CancellationToken cancellationToken = default)
        {
            var query = Context.Knjigas
                .Include(k => k.Autor)
                .Where(k => !k.IsDeleted);

            query = AddFilter(search, query);

            var count = await query.CountAsync(cancellationToken);

            if (!string.IsNullOrEmpty(search?.OrderBy) &&
                !string.IsNullOrEmpty(search?.SortDirection))
            {
                query = ApplySorting(query, search.OrderBy, search.SortDirection);
            }

            if (search?.Page.HasValue == true && search.PageSize.HasValue)
            {
                query = query.Skip((search.Page.Value - 1) * search.PageSize.Value)
                             .Take(search.PageSize.Value);
            }

            var list = await query.ToListAsync(cancellationToken);

            var result = Mapper.Map<List<KnjigaDTO>>(list);

            for (int i = 0; i < result.Count; i++)
            {
                var knjiga = list[i];

                result[i].AutorNaziv = knjiga.Autor != null
                    ? $"{knjiga.Autor.Ime} {knjiga.Autor.Prezime}"
                    : null;

            }

            return new PagedResult<KnjigaDTO>
            {
                ResultList = result,
                Count = count
            };
        }

        public override async Task<KnjigaDTO> GetByIdAsync(int id, CancellationToken cancellationToken = default)
        {
            var knjiga = await Context.Knjigas
                .Include(k => k.Autor)
                .Include(k => k.KnjigaZanrs).ThenInclude(kz => kz.Zanr)
                .Include(k => k.KnjigaCiljnaGrupas).ThenInclude(kcg => kcg.CiljnaGrupa)
                .FirstOrDefaultAsync(k => k.KnjigaId == id && !k.IsDeleted, cancellationToken);

            if (knjiga == null)
                throw new UserException("Uneseni ID ne postoji.");

            var dto = Mapper.Map<KnjigaDTO>(knjiga);


            dto.AutorNaziv = $"{knjiga.Autor.Ime} {knjiga.Autor.Prezime}";

            dto.Zanrovi = knjiga.KnjigaZanrs
                .Where(kz => !kz.IsDeleted && !kz.Zanr.IsDeleted)
                .Select(kz => kz.Zanr.Naziv)
                .Distinct()
                .ToList();

            dto.CiljneGrupe = knjiga.KnjigaCiljnaGrupas
                .Where(kcg => !kcg.IsDeleted && !kcg.CiljnaGrupa.IsDeleted)
                .Select(kcg => kcg.CiljnaGrupa.Naziv)
                .Distinct()
                .ToList();

            return dto;
        }



        public override async Task BeforeInsertAsync(KnjigaInsertRequest request, Knjiga entity, CancellationToken cancellationToken = default)
        {
            await _knjigaValidator.ValidateInsertAsync(request, cancellationToken);

            _zanrValidator.ValidateNoDuplicates(request.Zanrovi);

            foreach (var zanrId in request.Zanrovi)
                await _zanrValidator.ValidateEntityExistsAsync(zanrId, cancellationToken);

            
            _ciljnaGrupaValidator.ValidateNoDuplicates(request.CiljneGrupe);

            foreach (var cgId in request.CiljneGrupe)
                await _ciljnaGrupaValidator.ValidateEntityExistsAsync(cgId, cancellationToken);

            await _autorValidator.ValidateEntityExistsAsync(request.AutorId, cancellationToken);


            entity.IsDeleted = false;

            await base.BeforeInsertAsync(request, entity, cancellationToken);
        }

        public override async Task AfterInsertAsync(KnjigaInsertRequest request, Knjiga entity, CancellationToken cancellationToken = default)
        {
            if (request?.Zanrovi != null && request.Zanrovi.Count > 0)
            {
                foreach (var zanrId in request.Zanrovi)
                {
                    Context.KnjigaZanrs.Add(new KnjigaZanr
                    {
                        ZanrId = zanrId,
                        KnjigaId = entity.KnjigaId,
                        IsDeleted= false
                    });
                }
            }

            if (request?.CiljneGrupe != null && request.CiljneGrupe.Count > 0)
            {
                foreach (var ciljnaGrupaId in request.CiljneGrupe)
                {
                    Context.KnjigaCiljnaGrupas.Add(new KnjigaCiljnaGrupa
                    {
                        CiljnaGrupaId = ciljnaGrupaId,
                        KnjigaId = entity.KnjigaId,
                        IsDeleted= false
                    });
                }
            }

            await Context.SaveChangesAsync(cancellationToken);

        }

        public override async Task BeforeUpdateAsync(KnjigaUpdateRequest request, Knjiga entity, CancellationToken cancellationToken = default)
        {
            await _knjigaValidator.ValidateUpdateAsync(entity.KnjigaId, request, cancellationToken);

            await _autorValidator.ValidateEntityExistsAsync(request.AutorId, cancellationToken);

            if (request.Zanrovi != null)
            {
                
                _zanrValidator.ValidateNoDuplicates(request.Zanrovi);
                foreach (var zanrId in request.Zanrovi)
                    await _zanrValidator.ValidateEntityExistsAsync(zanrId, cancellationToken);

                
                var postojeciZanrovi = await Context.KnjigaZanrs
                    .Where(kz => kz.KnjigaId == entity.KnjigaId)
                    .ToListAsync(cancellationToken);

                
                var zanroviZaDodati = request.Zanrovi
                    .Except(postojeciZanrovi
                        .Where(kz => !kz.IsDeleted)
                        .Select(kz => kz.ZanrId))
                    .ToList();

                foreach (var zanrId in zanroviZaDodati)
                {
                    var softDeleted = postojeciZanrovi
                        .FirstOrDefault(kz => kz.ZanrId == zanrId && kz.IsDeleted);

                    if (softDeleted != null)
                    {
                        softDeleted.IsDeleted = false;
                        softDeleted.VrijemeBrisanja = null;
                       
                    }
                    else
                    {
                        Context.KnjigaZanrs.Add(new KnjigaZanr
                        {
                            KnjigaId = entity.KnjigaId,
                            ZanrId = zanrId,
                            IsDeleted = false
                        });
                    }
                }

                
                var zanroviZaObrisati = postojeciZanrovi
                    .Where(kz => !kz.IsDeleted && !request.Zanrovi.Contains(kz.ZanrId))
                    .ToList();

                foreach (var kz in zanroviZaObrisati)
                {
                    kz.IsDeleted = true;
                    kz.VrijemeBrisanja = DateTime.Now;
                }
            }


            if (request.CiljneGrupe != null)
            {
                _ciljnaGrupaValidator.ValidateNoDuplicates(request.CiljneGrupe);
                foreach (var cgId in request.CiljneGrupe)
                    await _ciljnaGrupaValidator.ValidateEntityExistsAsync(cgId, cancellationToken);

                var postojeceCg = await Context.KnjigaCiljnaGrupas
                    .Where(kcg => kcg.KnjigaId == entity.KnjigaId)
                    .ToListAsync(cancellationToken);

                
                var cgZaDodati = request.CiljneGrupe
                    .Except(postojeceCg
                        .Where(kcg => !kcg.IsDeleted)
                        .Select(kcg => kcg.CiljnaGrupaId))
                    .ToList();

                foreach (var cgId in cgZaDodati)
                {
                    var softDeleted = postojeceCg
                        .FirstOrDefault(kcg => kcg.CiljnaGrupaId == cgId && kcg.IsDeleted);

                    if (softDeleted != null)
                    {
                        softDeleted.IsDeleted = false;
                        softDeleted.VrijemeBrisanja = null;
                    }
                    else
                    {
                        Context.KnjigaCiljnaGrupas.Add(new KnjigaCiljnaGrupa
                        {
                            KnjigaId = entity.KnjigaId,
                            CiljnaGrupaId = cgId,
                            IsDeleted = false
                        });
                    }
                }

                
                var cgZaObrisati = postojeceCg
                    .Where(kcg => !kcg.IsDeleted && !request.CiljneGrupe.Contains(kcg.CiljnaGrupaId))
                    .ToList();

                foreach (var kcg in cgZaObrisati)
                {
                    kcg.IsDeleted = true;
                    kcg.VrijemeBrisanja = DateTime.Now;
                }
            }
        }

        public override async Task BeforeDeleteAsync(Knjiga entity, CancellationToken cancellationToken = default)
        {
            bool uUpotrebi =
                await Context.Arhivas.AnyAsync(x => x.KnjigaId == entity.KnjigaId && !x.IsDeleted, cancellationToken) ||
                await Context.Preporukas.AnyAsync(x => x.KnjigaId == entity.KnjigaId && !x.IsDeleted, cancellationToken) ||
                await Context.MojaLista.AnyAsync(x => x.KnjigaId == entity.KnjigaId && !x.IsDeleted, cancellationToken) ||
                await Context.LicnaPreporukaKnjigas.AnyAsync(x => x.KnjigaId == entity.KnjigaId && !x.IsDeleted, cancellationToken) ||
                await Context.StavkaNarudzbes.AnyAsync(x => x.KnjigaId == entity.KnjigaId && !x.IsDeleted, cancellationToken) ||
                await Context.Recenzijas.AnyAsync(x => x.KnjigaId == entity.KnjigaId && !x.IsDeleted, cancellationToken);

            if (uUpotrebi)
            {
                throw new UserException("Knjiga je u upotrebi i ne može biti obrisana.");
            }

            await base.BeforeDeleteAsync(entity, cancellationToken);
        }
    }
}
