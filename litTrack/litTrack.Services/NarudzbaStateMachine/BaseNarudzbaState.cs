using litTrack.Model.DTOs;
using litTrack.Model.Exceptions;
using litTrack.Model.Requests;
using litTrack.Services.Database;
using MapsterMapper;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.NarudzbaStateMachine
{
    public class BaseNarudzbaState
    {
        public _210078Context Context { get; set; }
        public IMapper Mapper { get; set; }
        public IServiceProvider ServiceProvider { get; set; }

        public BaseNarudzbaState(_210078Context context, IMapper mapper, IServiceProvider serviceProvider)
        {
            Context = context;
            Mapper = mapper;
            ServiceProvider = serviceProvider;
        }

        public virtual async Task<NarudzbaDTO> Insert(NarudzbaInsertRequest narudzba, CancellationToken cancellationToken = default)
        {
            await Task.CompletedTask;
            throw new UserException("Metoda nije dozvoljena.");
        }

        public virtual async Task<NarudzbaDTO> Update(int narudzbaId, NarudzbaUpdateRequest narudzba, CancellationToken cancellationToken = default)
        {
            await Task.CompletedTask;
            throw new UserException("Metoda nije dozvoljena.");
        }

        public virtual async Task<NarudzbaDTO> Kreirana(int narudzbaId, CancellationToken cancellationToken = default)
        {
            await Task.CompletedTask;
            throw new UserException("Metoda nije dozvoljena.");
        }

        public virtual async Task<NarudzbaDTO> Ponistena(int narudzbaId, CancellationToken cancellationToken = default)
        {
            await Task.CompletedTask;
            throw new UserException("Metoda nije dozvoljena.");
        }

        public virtual async Task<NarudzbaDTO> Preuzeta(int narudzbaId, CancellationToken cancellationToken = default)
        {
            await Task.CompletedTask;
            throw new UserException("Metoda nije dozvoljena.");
        }

        public virtual async Task<NarudzbaDTO> UToku(int narudzbaId, CancellationToken cancellationToken = default)
        {
            await Task.CompletedTask;
            throw new UserException("Metoda nije dozvoljena.");
        }

        public virtual async Task<NarudzbaDTO> Zavrsena(int narudzbaId, CancellationToken cancellationToken = default)
        {
            await Task.CompletedTask;
            throw new UserException("Metoda nije dozvoljena.");
        }

        public virtual List<string> AllowedActions(Database.Narudzba entity)
        {
            throw new UserException("Metoda nije dozvoljena.");
        }


        public BaseNarudzbaState CreateState(string stateName)
        {
            BaseNarudzbaState? state = stateName switch
            {
                "initial" => ServiceProvider.GetService<InitialNarudzbaState>(),
                "kreirana" => ServiceProvider.GetService<KreiranaNarudzbaState>(),
                "preuzeta" => ServiceProvider.GetService<PreuzetaNarudzbaState>(),
                "uToku" => ServiceProvider.GetService<UTokuNarudzbaState>(),
                "ponistena" => ServiceProvider.GetService<PonistenaNarudzbaState>(),
                "zavrsena" => ServiceProvider.GetService<ZavrsenaNarudzbaState>(),
                _ => null
            };

            if (state == null)
                throw new UserException("Greška prilikom prepoznavanja stanja narudžbe.");

            return state;
        }

    }
}
