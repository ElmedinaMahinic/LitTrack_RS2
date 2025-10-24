import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/providers/korisnik_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/main.dart';
import 'package:littrack_mobile/screens/uredi_profil_screen.dart';

class KorisnickiProfilScreen extends StatefulWidget {
  const KorisnickiProfilScreen({super.key});

  @override
  State<KorisnickiProfilScreen> createState() => _KorisnickiProfilScreenState();
}

class _KorisnickiProfilScreenState extends State<KorisnickiProfilScreen> {
  late KorisnikProvider _provider;
  bool _isLoading = true;

  Map<String, String> _korisnikPodaci = {
    'korisnickoIme': '',
    'ime': '',
    'prezime': '',
    'email': '',
    'telefon': '',
    'datumRegistracije': '',
  };

  @override
  void initState() {
    super.initState();
    _provider = context.read<KorisnikProvider>();
    _loadKorisnik();
  }

  Future<void> _loadKorisnik() async {
    setState(() => _isLoading = true);

    try {
      final korisnik = await _provider.getById(AuthProvider.korisnikId!);
      setState(() {
        _korisnikPodaci = {
          'korisnickoIme': korisnik.korisnickoIme ?? '',
          'ime': korisnik.ime ?? '',
          'prezime': korisnik.prezime ?? '',
          'email': korisnik.email ?? '',
          'telefon': korisnik.telefon ?? '',
          'datumRegistracije': korisnik.datumRegistracije?.toString() ?? '',
        };
      });
    } catch (e) {
      await showCustomDialog(
        context: context,
        title: 'Greška',
        message: 'Neuspješno učitavanje podataka o korisniku.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
      Navigator.pop(context);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 28),
                  _buildInfoSection(),
                  const SizedBox(height: 48),
                  _buildActionButtons(),
                ],
              ),
            ),
          );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3C6E71),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Center(
        child: Text(
          "Moj korisnički profil",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
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
          Icon(icon, color: iconColor ?? const Color(0xFF3C6E71), size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.5,
                color: Color(0xFF3C6E71),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
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
          _buildInfoRow("Ime:", _korisnikPodaci['ime'] ?? "/", Icons.person),
          _buildInfoRow("Prezime:", _korisnikPodaci['prezime'] ?? "/",
              Icons.person_outline),
          _buildInfoRow(
              "Korisničko ime:",
              _korisnikPodaci['korisnickoIme'] ?? "/",
              Icons.account_circle_outlined),
          _buildInfoRow(
              "Email:", _korisnikPodaci['email'] ?? "/", Icons.email_outlined),
          _buildInfoRow("Telefon:", _korisnikPodaci['telefon'] ?? "/",
              Icons.phone_outlined),
          _buildInfoRow(
            "Datum registracije:",
            (() {
              final datumString = _korisnikPodaci['datumRegistracije'];
              if (datumString == null || datumString.isEmpty) return "/";
              try {
                final parsedDate = DateTime.parse(datumString).toLocal();
                return DateFormat('dd.MM.yyyy. HH:mm').format(parsedDate);
              } catch (_) {
                return "/";
              }
            })(),
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: 220,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () async {
              final refresh = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const UrediProfilScreen()),
              );

              if (refresh == true) {
                await _loadKorisnik();
              }
            },
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text(
              'Uredi profil',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF3C6E71)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
        const SizedBox(height: 18),
        SizedBox(
          width: 220,
          height: 48,
          child: ElevatedButton.icon(
            onPressed: () {
              showConfirmDialog(
                context: context,
                title: 'Odjava',
                message: 'Da li ste sigurni da želite da se odjavite?',
                icon: Icons.logout,
                iconColor: Colors.red,
                onConfirm: () async {
                  AuthProvider.username = null;
                  AuthProvider.password = null;
                  AuthProvider.korisnikId = null;
                  AuthProvider.ime = null;
                  AuthProvider.prezime = null;
                  AuthProvider.email = null;
                  AuthProvider.telefon = null;
                  AuthProvider.uloge = null;
                  AuthProvider.isSignedIn = false;

                  await showCustomDialog(
                    context: context,
                    title: "Odjava uspješna",
                    message: "Uspješno ste se odjavili.",
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  );

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const MyApp()),
                  );
                },
              );
            },
            icon: const Icon(Icons.logout, color: Colors.white),
            label: const Text(
              'Odjavi se',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(const Color(0xFF3C6E71)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
