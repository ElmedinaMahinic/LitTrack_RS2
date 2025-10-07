import 'package:flutter/material.dart';
import 'package:littrack_desktop/main.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/providers/obavijest_provider.dart';
import 'package:littrack_desktop/screens/uredi_profil_screen.dart';
import 'package:littrack_desktop/screens/radnik_dashboard_screen.dart';
import 'package:littrack_desktop/screens/radnik_narudzbe_screen.dart';
import 'package:littrack_desktop/screens/radnik_korisnici_screen.dart';
import 'package:littrack_desktop/screens/radnik_obavijesti_screen.dart';
import 'package:provider/provider.dart';

class RadnikSidebar extends StatefulWidget {
  const RadnikSidebar({super.key});

  @override
  State<RadnikSidebar> createState() => _RadnikSidebarState();
}

class _RadnikSidebarState extends State<RadnikSidebar> {
  late ObavijestProvider _obavijestProvider;
  int _unreadCount = 0;

  @override
  void initState() {
    super.initState();
    _obavijestProvider = context.read<ObavijestProvider>();
    _loadUnreadCount();
  }

  Future<void> _loadUnreadCount() async {
    final korisnikId = AuthProvider.korisnikId;
    if (korisnikId == null) {
      setState(() => _unreadCount = 0);
      return;
    }

    try {
      final result = await _obavijestProvider.get(filter: {
        'KorisnikId': korisnikId,
        'JePogledana': false,
      });

      setState(() {
        _unreadCount = result.count;
      });
    } catch (e) {
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap,
      {Widget? badge}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 25),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 17.0,
              ),
            ),
            if (badge != null) ...[
              const SizedBox(width: 7),
              badge,
            ],
          ],
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildUnreadBadge(int count) {
    final displayText = count > 99 ? '99+' : count.toString();
    final isSingleDigit = count < 10;

    const double height = 24;
    const double singleDigitWidth = 24;
    const double multiDigitWidth = 35;

    final double badgeWidth =
        isSingleDigit ? singleDigitWidth : multiDigitWidth;

    return Container(
      height: height,
      width: badgeWidth,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 215, 228, 228),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      alignment: Alignment.center,
      child: Text(
        displayText,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFF3C6E71),
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      color: const Color(0xFF3C6E71),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Radnik panel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Divider(color: Colors.white54, thickness: 1),
                        const SizedBox(height: 10),
                        _buildMenuItem(Icons.bar_chart, "Statistika", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const RadnikDashboardScreen()));
                        }),
                        _buildMenuItem(Icons.shopping_cart, "Narudžbe", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const RadnikNarudzbeScreen()));
                        }),
                        _buildMenuItem(Icons.people, "Korisnici", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const RadnikKorisniciScreen()));
                        }),
                        _buildMenuItem(
                          Icons.notifications,
                          "Obavijesti",
                          () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const RadnikObavijestiScreen(),
                              ),
                            );
                            await _loadUnreadCount();
                          },
                          badge: _unreadCount > 0
                              ? _buildUnreadBadge(_unreadCount)
                              : null,
                        ),
                        const Spacer(),
                        const Divider(color: Colors.white54, thickness: 1),
                        _buildMenuItem(Icons.logout, "Odjavi se", () {
                          showConfirmDialog(
                            context: context,
                            title: 'Odjava',
                            message:
                                'Da li ste sigurni da želite da se odjavite?',
                            icon: Icons.logout,
                            iconColor: Colors.red,
                            onConfirm: () {
                              AuthProvider.username = null;
                              AuthProvider.password = null;
                              AuthProvider.korisnikId = null;
                              AuthProvider.ime = null;
                              AuthProvider.prezime = null;
                              AuthProvider.email = null;
                              AuthProvider.telefon = null;
                              AuthProvider.uloge = null;
                              AuthProvider.isSignedIn = false;

                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) => const MyApp()),
                              );
                            },
                          );
                          setState(() {});
                        }),
                        _buildMenuItem(Icons.settings, "Uredi profil", () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                const UrediKorisnikProfilScreen(),
                          ));
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
