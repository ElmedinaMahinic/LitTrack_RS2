import 'package:flutter/material.dart';
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
  };

  @override
  void initState() {
    super.initState();
    _provider = context.read<KorisnikProvider>();
    _loadKorisnik();
  }

  Future<void> _loadKorisnik() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final korisnik = await _provider.getById(AuthProvider.korisnikId!);
      if (!mounted) return;
      setState(() {
        _korisnikPodaci = {
          'korisnickoIme': korisnik.korisnickoIme ?? '',
          'ime': korisnik.ime ?? '',
          'prezime': korisnik.prezime ?? '',
          'email': korisnik.email ?? '',
          'telefon': korisnik.telefon ?? '',
        };
      });
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: 'Greška',
        message: 'Neuspješno učitavanje podataka o korisniku.',
        icon: Icons.error,
        iconColor: Colors.red,
      );
      if (!mounted) return;
      Navigator.pop(context);
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? const Color(0xFF3C6E71), size: 22),
          const SizedBox(width: 10),
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
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
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
        if (states.contains(WidgetState.pressed)) {
          return const Color(0xFF33585B);
        }
        return const Color(0xFF3C6E71);
      }),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      shadowColor: WidgetStateProperty.all(Colors.black.withAlpha(77)),
      elevation: WidgetStateProperty.all(6),
    );

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
                  builder: (context) => const UrediProfilScreen(),
                ),
              );
              if (!mounted) return;

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
            style: buttonStyle,
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

                  if (!mounted) return;

                  await showCustomDialog(
                    context: context,
                    title: "Odjava uspješna",
                    message: "Uspješno ste se odjavili.",
                    icon: Icons.check_circle,
                    iconColor: Colors.green,
                  );
                  if (!mounted) return;

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const MyApp()),
                    (route) => false,
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
            style: buttonStyle,
          ),
        ),
      ],
    );
  }
}
