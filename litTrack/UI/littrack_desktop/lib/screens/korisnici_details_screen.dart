import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_desktop/models/korisnik.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class KorisniciDetailsScreen extends StatelessWidget {
  final Korisnik korisnik;

  const KorisniciDetailsScreen({super.key, required this.korisnik});

  static const Color zelenaBoja = Color(0xFF3C6E71);

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

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Ime:", korisnik.ime ?? "/", Icons.person),
          _buildInfoRow(
              "Prezime:", korisnik.prezime ?? "/", Icons.person_outline),
          _buildInfoRow("Korisničko ime:", korisnik.korisnickoIme ?? "/",
              Icons.account_circle_outlined),
          _buildInfoRow("Email:", korisnik.email ?? "/", Icons.email_outlined),
          _buildInfoRow(
              "Telefon:", korisnik.telefon ?? "/", Icons.phone_outlined),
          _buildInfoRow(
            "Datum registracije:",
            korisnik.datumRegistracije != null
                ? DateFormat('dd.MM.yyyy. HH:mm')
                    .format(korisnik.datumRegistracije!.toLocal())
                : "/",
            Icons.calendar_today_outlined,
          ),
          _buildInfoRow(
            "Status:",
            korisnik.jeAktivan == true ? "Aktivan" : "Deaktiviran",
            Icons.circle,
            iconColor: korisnik.jeAktivan == true ? Colors.green : Colors.red,
          ),
          _buildInfoRow("Uloge:", ulogeText, Icons.badge_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor ?? zelenaBoja, size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: zelenaBoja,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16.5,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(
            width: 140,
            height: 45,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back_ios_new,
                  color: Colors.white, size: 18),
              label: const Text(
                "Nazad",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.resolveWith<Color>((states) {
                  if (states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.selected)) {
                    return const Color.fromARGB(255, 100, 100, 100);
                  }
                  if (states.contains(MaterialState.hovered)) {
                    return const Color.fromARGB(255, 150, 150, 150);
                  }
                  return const Color.fromARGB(255, 120, 120, 120);
                }),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                elevation: MaterialStateProperty.all(4),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 16),
                ),
                shadowColor: MaterialStateProperty.all(Colors.black54),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
