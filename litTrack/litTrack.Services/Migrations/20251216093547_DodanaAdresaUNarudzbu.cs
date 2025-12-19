using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace litTrack.Services.Migrations
{
    /// <inheritdoc />
    public partial class DodanaAdresaUNarudzbu : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Adresa",
                table: "Narudzba",
                type: "nvarchar(max)",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Adresa",
                table: "Narudzba");
        }
    }
}
