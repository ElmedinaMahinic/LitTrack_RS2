using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Auth
{
    public interface IPasswordService
    {
        string GenerateSalt();
        string GenerateHash(string salt, string password);
    }
}
