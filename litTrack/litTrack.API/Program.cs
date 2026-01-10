using litTrack.API.Filters;
using litTrack.Services.Auth;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.ServicesImplementation;
using litTrack.Services.Validators.Interfaces;
using litTrack.Services.Validators.Implementation;
using Mapster;
using Microsoft.EntityFrameworkCore;
using litTrack.Services.NarudzbaStateMachine;
using Microsoft.OpenApi.Models;
using litTrack.API.Auth;
using Microsoft.AspNetCore.Authentication;
using litTrack.Services.Recommender;
using QuestPDF.Infrastructure;
using litTrack.Services.RabbitMQ;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.

QuestPDF.Settings.License = LicenseType.Community;

builder.Services.AddTransient<IAutorService, AutorService>();
builder.Services.AddTransient<IZanrService, ZanrService>();
builder.Services.AddTransient<IUlogaService, UlogaService>();
builder.Services.AddTransient<ICiljnaGrupaService, CiljnaGrupaService>();
builder.Services.AddTransient<IKnjigaService, KnjigaService>();
builder.Services.AddTransient<IKorisnikService, KorisnikService>();
builder.Services.AddTransient<IArhivaService, ArhivaService>();
builder.Services.AddTransient<IOcjenaService, OcjenaService>();
builder.Services.AddTransient<IObavijestService, ObavijestService>();
builder.Services.AddTransient<INacinPlacanjaService, NacinPlacanjaService>();
builder.Services.AddTransient<IPreporukaService, PreporukaService>();
builder.Services.AddTransient<IMojaListumService, MojaListumService>();
builder.Services.AddTransient<ILicnaPreporukaService, LicnaPreporukaService>();
builder.Services.AddTransient<IRecenzijaService, RecenzijaService>();
builder.Services.AddTransient<IRecenzijaOdgovorService, RecenzijaOdgovorService>();
builder.Services.AddTransient<INarudzbaService, NarudzbaService>();
builder.Services.AddTransient<IStavkaNarudzbeService, StavkaNarudzbeService>();


builder.Services.AddTransient<BaseNarudzbaState>();
builder.Services.AddTransient<InitialNarudzbaState>();
builder.Services.AddTransient<KreiranaNarudzbaState>();
builder.Services.AddTransient<PreuzetaNarudzbaState>();
builder.Services.AddTransient<PonistenaNarudzbaState>();
builder.Services.AddTransient<UTokuNarudzbaState>();
builder.Services.AddTransient<ZavrsenaNarudzbaState>();

builder.Services.AddTransient<IAutorValidator, AutorValidator>();
builder.Services.AddTransient<ICiljnaGrupaValidator, CiljnaGrupaValidator>();
builder.Services.AddTransient<IUlogaValidator, UlogaValidator>();
builder.Services.AddTransient<IZanrValidator, ZanrValidator>();
builder.Services.AddTransient<IKnjigaValidator, KnjigaValidator>();
builder.Services.AddTransient<IKorisnikValidator, KorisnikValidator>();
builder.Services.AddTransient<ILicnaPreporukaValidator, LicnaPreporukaValidator>();
builder.Services.AddTransient<IRecenzijaValidator, RecenzijaValidator>();
builder.Services.AddTransient<INarudzbaValidator, NarudzbaValidator>();
builder.Services.AddTransient<IStavkaNarudzbeValidator, StavkaNarudzbeValidator>();

builder.Services.AddTransient<IPasswordService, PasswordService>();
builder.Services.AddTransient<IActiveUserServiceAsync, ActiveUserServiceAsync>();
builder.Services.AddTransient<IRabbitMQService, RabbitMQService>();
builder.Services.AddScoped<IKnjigaRecommenderService, KnjigaRecommenderService>();
builder.Services.AddScoped<IReportService, ReportService>();

builder.Services.AddControllers(x=>
{
    x.Filters.Add<ExceptionFilter>();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(c =>
{
    c.AddSecurityDefinition("BasicAuthentication", new OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        Scheme = "basic",
        In = ParameterLocation.Header,
        Description = "Basic auth preko Authorization header-a."
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type = ReferenceType.SecurityScheme,
                    Id = "BasicAuthentication"
                }
            },
            new string[] { }
        }
    });
});

var connectionString = builder.Configuration.GetConnectionString("litTrackConnection");
builder.Services.AddDbContext<_210078Context>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();
builder.Services.AddAuthentication("BasicAuthentication")
    .AddScheme<AuthenticationSchemeOptions, BasicAuthenticationHandler>("BasicAuthentication", null);
builder.Services.AddHttpContextAccessor();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.UseAuthorization();

app.MapControllers();

app.Run();
