import 'package:flutter/material.dart';
import 'package:littrack_mobile/main.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/screens/homepage_screen.dart';
import 'package:littrack_mobile/screens/moja_lista_screen.dart';
import 'package:littrack_mobile/screens/navike_screen.dart';
import 'package:littrack_mobile/screens/preporuka_screen.dart';
import 'package:littrack_mobile/screens/korisnicki_profil_screen.dart';
import 'package:littrack_mobile/screens/arhiva_screen.dart';
import 'package:littrack_mobile/screens/zanrovi_screen.dart';
import 'package:littrack_mobile/screens/autori_screen.dart';
import 'package:littrack_mobile/screens/ciljne_grupe_screen.dart';
import 'package:littrack_mobile/screens/preporuke_favoriti_screen.dart';
import 'package:littrack_mobile/screens/licne_preporuke_screen.dart';
import 'package:littrack_mobile/screens/moje_narudzbe_screen.dart';
import 'package:littrack_mobile/screens/obavijesti_screen.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  int _selectedIndex = 2;

  final List<Widget> _screens = const [
    MojaListaScreen(),
    NavikeScreen(),
    HomepageScreen(),
    PreporukaScreen(),
    KorisnickiProfilScreen(),
    ArhivaScreen(),
    ZanroviScreen(),
    AutoriScreen(),
    CiljneGrupeScreen(),
    PreporukeFavoritiScreen(),
    LicnePreporukeScreen(),
    MojeNarudzbeScreen(),
    ObavijestiScreen(),
  ];

  void _navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _navigateDrawer(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF6F4F3),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 25),
          child: AppBar(
            elevation: 0,
            automaticallyImplyLeading: false,
            centerTitle: false,
            toolbarHeight: kToolbarHeight + 25,
            backgroundColor: const Color(0xFFF6F4F3),
            title: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Builder(
                      builder: (context) {
                        return IconButton(
                          icon: const Icon(
                            Icons.menu,
                            color: Colors.black,
                            size: 35,
                          ),
                          onPressed: () {
                            Scaffold.of(context).openDrawer();
                          },
                        );
                      },
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/logo.png",
                          height: 45,
                          width: 45,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "LitTrack",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.shopping_cart,
                        color: Colors.black,
                        size: 35,
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        drawer: Drawer(
          backgroundColor: const Color(0xFFEAE7E6),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Color(0xFFEAE7E6),
                ),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Meni",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.archive, color: Colors.black),
                title: const Text("Arhiva"),
                onTap: () => _navigateDrawer(5),
              ),
              ListTile(
                leading: const Icon(Icons.library_books, color: Colors.black),
                title: const Text("Žanrovi"),
                onTap: () => _navigateDrawer(6),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.black),
                title: const Text("Autori"),
                onTap: () => _navigateDrawer(7),
              ),
              ListTile(
                leading: const Icon(Icons.groups, color: Colors.black),
                title: const Text("Ciljne grupe"),
                onTap: () => _navigateDrawer(8),
              ),
              ListTile(
                leading: const Icon(Icons.favorite, color: Colors.black),
                title: const Text("Preporuke i favoriti"),
                onTap: () => _navigateDrawer(9),
              ),
              ListTile(
                leading: const Icon(Icons.mail, color: Colors.black),
                title: const Text("Lične preporuke"),
                onTap: () => _navigateDrawer(10),
              ),
              ListTile(
                leading: const Icon(Icons.shopping_cart, color: Colors.black),
                title: const Text("Moje narudžbe"),
                onTap: () => _navigateDrawer(11),
              ),
              ListTile(
                leading: const Icon(Icons.notifications, color: Colors.black),
                title: const Text("Obavijesti"),
                onTap: () => _navigateDrawer(12),
              ),
              const Divider(color: Colors.black),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.black),
                title: const Text("Odjava"),
                onTap: () {
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
                        MaterialPageRoute(
                          builder: (context) => const MyApp(),
                        ),
                      );
                    },
                  );

                  setState(() {});
                },
              ),
            ],
          ),
        ),
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex > 4 ? 2 : _selectedIndex,
          onTap: _navigateBottomBar,
          type: BottomNavigationBarType.fixed,
          backgroundColor: const Color(0xFF3C6E71),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          selectedFontSize: 15,
          unselectedFontSize: 14,
          iconSize: 30,
          items: const [
            BottomNavigationBarItem(
              label: 'Moja lista',
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
            ),
            BottomNavigationBarItem(
              label: 'Navike',
              icon: Icon(Icons.bar_chart_outlined),
              activeIcon: Icon(Icons.bar_chart),
            ),
            BottomNavigationBarItem(
              label: 'Početna',
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Preporuka',
              icon: Icon(Icons.mail_outlined),
              activeIcon: Icon(Icons.mail),
            ),
            BottomNavigationBarItem(
              label: 'Profil',
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}
