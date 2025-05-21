using litTrack.API.Filters;
using litTrack.Services.Auth;
using litTrack.Services.Database;
using litTrack.Services.Interfaces;
using litTrack.Services.ServicesImplementation;
using litTrack.Services.Validators.Interfaces;
using litTrack.Services.Validators.Implementation;
using Mapster;
using Microsoft.EntityFrameworkCore;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.


builder.Services.AddTransient<IAutorService, AutorService>();
builder.Services.AddTransient<IZanrService, ZanrService>();
builder.Services.AddTransient<IUlogaService, UlogaService>();
builder.Services.AddTransient<ICiljnaGrupaService, CiljnaGrupaService>();
builder.Services.AddTransient<IKnjigaService, KnjigaService>();

builder.Services.AddTransient<IAutorValidator, AutorValidator>();
builder.Services.AddTransient<ICiljnaGrupaValidator, CiljnaGrupaValidator>();
builder.Services.AddTransient<IUlogaValidator, UlogaValidator>();
builder.Services.AddTransient<IZanrValidator, ZanrValidator>();
builder.Services.AddTransient<IKnjigaValidator, KnjigaValidator>();

builder.Services.AddTransient<IPasswordService, PasswordService>();

builder.Services.AddControllers(x=>
{
    x.Filters.Add<ExceptionFilter>();
});
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var connectionString = builder.Configuration.GetConnectionString("litTrackConnection");
builder.Services.AddDbContext<_210078Context>(options =>
    options.UseSqlServer(connectionString));

builder.Services.AddMapster();

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
