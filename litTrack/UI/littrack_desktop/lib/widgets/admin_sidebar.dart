import 'package:flutter/material.dart';
import 'package:littrack_desktop/main.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/screens/admin_dashboard_screen.dart';
import 'package:littrack_desktop/screens/admin_knjige_screen.dart';
import 'package:littrack_desktop/screens/admin_autori_screen.dart';
import 'package:littrack_desktop/screens/admin_zanrovi_screen.dart';
import 'package:littrack_desktop/screens/admin_korisnici_screen.dart';
import 'package:littrack_desktop/screens/admin_uloge_screen.dart';
import 'package:littrack_desktop/screens/admin_ciljne_grupe_screen.dart';
import 'package:littrack_desktop/screens/admin_recenzije_screen.dart';
import 'package:littrack_desktop/screens/uredi_profil_screen.dart';

class AdminSidebar extends StatefulWidget {
  const AdminSidebar({super.key});

  @override
  State<AdminSidebar> createState() => _AdminSidebarState();
}

class _AdminSidebarState extends State<AdminSidebar> {
  Widget _buildMenuItem(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0), // smanjen razmak
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
      color: const Color(0xFF3C6E71), // tamno zelena
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
                          'Admin panel',
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
                                  const AdminDashboardScreen()));
                        }),
                        _buildMenuItem(Icons.menu_book, "Knjige", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AdminKnjigeScreen()));
                        }),
                        _buildMenuItem(Icons.person, "Autori", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AdminAutoriScreen()));
                        }),
                        _buildMenuItem(Icons.category, "Žanrovi", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const AdminZanroviScreen()));
                        }),
                        _buildMenuItem(Icons.people, "Korisnici", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const AdminKorisniciScreen()));
                        }),
                        _buildMenuItem(Icons.verified_user, "Uloge", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const AdminUlogeScreen()));
                        }),
                        _buildMenuItem(Icons.groups, "Ciljne grupe", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const AdminCiljneGrupeScreen()));
                        }),
                        _buildMenuItem(Icons.rate_review, "Recenzije", () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  const AdminRecenzijeScreen()));
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
