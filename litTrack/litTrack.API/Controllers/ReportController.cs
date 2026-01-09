using litTrack.Services.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.Data;

namespace litTrack.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ReportController : ControllerBase
    {
        private readonly IReportService _reportService;

        public ReportController(IReportService reportService)
        {
            _reportService = reportService;
        }

        [Authorize(Roles = "Radnik")]
        [HttpGet("radnik-statistika-pdf")]
        public async Task<IActionResult> RadnikStatistikaPdf([FromQuery] string? stateMachine)
        {
            try
            {
                var pdf = await _reportService.RadnikStatistikaPdf(stateMachine);

                return File(
                    pdf,
                    "application/pdf",
                    $"RadnikStatistika_{DateTime.Now:yyyyMMdd}.pdf"
                );
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Došlo je do greške pri generisanju PDF-a: {ex.Message}" });
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("admin-statistika-pdf")]
        public async Task<IActionResult> AdminStatistikaPdf([FromQuery] string? stateMachine)
        {
            try
            {
                var pdf = await _reportService.AdminStatistikaPdf(stateMachine);

                return File(
                    pdf,
                    "application/pdf",
                    $"AdminStatistika_{DateTime.Now:yyyyMMdd}.pdf"
                );
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = $"Greška: {ex.Message}" });
            }
        }

        [Authorize(Roles = "Admin")]
        [HttpGet("radnik-kreiran-pdf")]
        public async Task<IActionResult> RadnikKreiranPdf([FromQuery] int radnikId, [FromQuery] string plainPassword)
        {
            try
            {
                var pdf = await _reportService.RadnikKreiranPdf(radnikId, plainPassword);

                return File(pdf, "application/pdf",
                    $"Radnik_{radnikId}_{DateTime.Now:yyyyMMddHHmm}.pdf");
            }
            catch (Exception ex)
            {
                return BadRequest(new { message = ex.Message });
            }
        }


    }
}
