import 'package:flutter/material.dart';
import 'package:littrack_desktop/main.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/screens/uredi_profil_screen.dart';
import 'package:littrack_desktop/screens/radnik_dashboard_screen.dart';
import 'package:littrack_desktop/screens/radnik_narudzbe_screen.dart';
import 'package:littrack_desktop/screens/radnik_korisnici_screen.dart';
import 'package:littrack_desktop/screens/radnik_obavijesti_screen.dart';

class RadnikSidebar extends StatefulWidget {
  const RadnikSidebar({super.key});

  @override
  State<RadnikSidebar> createState() => _RadnikSidebarState();
}

class _RadnikSidebarState extends State<RadnikSidebar> {
  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white, size: 25),
        title: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 17.0,
          ),
        ),
        onTap: onTap,
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                        _buildMenuItem(Icons.notifications, "Obavijesti", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const RadnikObavijestiScreen()));
                        }),
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