using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace litTrack.Services.Interfaces
{
    public interface IReportService
    {
        Task<byte[]> RadnikStatistikaPdf(string? stateMachine);

        Task<byte[]> AdminStatistikaPdf(string? stateMachine);

        Task<byte[]> RadnikKreiranPdf(int radnikId, string plainPassword);

    }
}
