using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace litTrack.Services.Migrations
{
    /// <inheritdoc />
    public partial class DodanSoftDeleteZaRecenziju : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "RecenzijaReakcija",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "RecenzijaReakcija",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsDeleted",
                table: "RecenzijaOdgovorReakcija",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<DateTime>(
                name: "VrijemeBrisanja",
                table: "RecenzijaOdgovorReakcija",
                type: "datetime2",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "RecenzijaReakcija");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "RecenzijaReakcija");

            migrationBuilder.DropColumn(
                name: "IsDeleted",
                table: "RecenzijaOdgovorReakcija");

            migrationBuilder.DropColumn(
                name: "VrijemeBrisanja",
                table: "RecenzijaOdgovorReakcija");
        }
    }
}
