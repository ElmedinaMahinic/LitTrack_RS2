import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_desktop/models/korisnik.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class KorisniciDetailsScreen extends StatelessWidget {
  final Korisnik korisnik;

  const KorisniciDetailsScreen({super.key, required this.korisnik});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Detalji korisnika",
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 30),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    final ulogeText = korisnik.uloge != null && korisnik.uloge!.isNotEmpty
        ? korisnik.uloge!.join(', ')
        : '/';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Ime:", korisnik.ime ?? "/"),
        _buildInfoRow("Prezime:", korisnik.prezime ?? "/"),
        _buildInfoRow("Korisničko ime:", korisnik.korisnickoIme ?? "/"),
        _buildInfoRow("Email:", korisnik.email ?? "/"),
        _buildInfoRow("Telefon:", korisnik.telefon ?? "/"),
        _buildInfoRow("Datum registracije:", korisnik.datumRegistracije != null
            ? DateFormat('dd.MM.yyyy. HH:mm').format(korisnik.datumRegistracije!.toLocal())
            : "/"),
        _buildInfoRow("Status:", korisnik.jeAktivan == true ? "Aktivan" : "Deaktiviran"),
        _buildInfoRow("Uloge:", ulogeText),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 120,
          height: 45,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Nazad",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}