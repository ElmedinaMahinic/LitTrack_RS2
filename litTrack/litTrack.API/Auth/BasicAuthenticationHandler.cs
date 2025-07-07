using litTrack.Model.DTOs;
using litTrack.Model.Requests;
using litTrack.Services.Interfaces;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;
using System.Text.Encodings.Web;

namespace litTrack.API.Auth
{
    public class BasicAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
    {
        private readonly IKorisnikService _korisnikService;

        public BasicAuthenticationHandler(
            IOptionsMonitor<AuthenticationSchemeOptions> options,
            ILoggerFactory logger,
            UrlEncoder encoder,
            ISystemClock clock,
            IKorisnikService korisnikService)
            : base(options, logger, encoder, clock)
        {
            _korisnikService = korisnikService;
        }

        protected override async Task<AuthenticateResult> HandleAuthenticateAsync()
        {
            if (!Request.Headers.ContainsKey("Authorization"))
                return AuthenticateResult.Fail("Nedostaje Authorization header.");

            KorisnikDTO? korisnik;

            try
            {
                var authHeader = AuthenticationHeaderValue.Parse(Request.Headers["Authorization"]);
                var credentialBytes = Convert.FromBase64String(authHeader.Parameter!);
                var credentials = Encoding.UTF8.GetString(credentialBytes).Split(':', 2);

                if (credentials.Length != 2)
                    return AuthenticateResult.Fail("Neispravan Authorization header format.");

                var username = credentials[0];
                var password = credentials[1];

                korisnik = await _korisnikService.LoginAsync(
                    new KorisnikLoginRequest { KorisnickoIme = username, Lozinka = password });

                if (korisnik == null)
                    return AuthenticateResult.Fail("Neispravni korisnički podaci.");
            }
            catch
            {
                return AuthenticateResult.Fail("Greška pri parsiranju autorizacije.");
            }

            // Claims
            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.NameIdentifier, korisnik.KorisnikId.ToString()),
                new Claim(ClaimTypes.Name, korisnik.KorisnickoIme),
                new Claim(ClaimTypes.GivenName, korisnik.Ime ?? ""),
                new Claim(ClaimTypes.Surname, korisnik.Prezime ?? "")
            };

            if (korisnik.Uloge != null)
            {
                foreach (var uloga in korisnik.Uloge)
                {
                    claims.Add(new Claim(ClaimTypes.Role, uloga));
                }
            }

            var identity = new ClaimsIdentity(claims, Scheme.Name);
            var principal = new ClaimsPrincipal(identity);
            var ticket = new AuthenticationTicket(principal, Scheme.Name);

            return AuthenticateResult.Success(ticket);
        }
    }
}
