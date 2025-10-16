import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/providers/korisnik_provider.dart';
import 'package:littrack_mobile/providers/autor_provider.dart';
import 'package:littrack_mobile/providers/ciljna_grupa_provider.dart';
import 'package:littrack_mobile/providers/knjiga_provider.dart';
import 'package:littrack_mobile/providers/recenzija_provider.dart';
import 'package:littrack_mobile/providers/recenzija_odgovor_provider.dart';
import 'package:littrack_mobile/providers/uloga_provider.dart';
import 'package:littrack_mobile/providers/zanr_provider.dart';
import 'package:littrack_mobile/providers/arhiva_provider.dart';
import 'package:littrack_mobile/providers/preporuka_provider.dart';
import 'package:littrack_mobile/providers/licna_preporuka_provider.dart';
import 'package:littrack_mobile/providers/moja_listum_provider.dart';
import 'package:littrack_mobile/providers/narudzba_provider.dart';
import 'package:littrack_mobile/providers/stavka_narudzbe_provider.dart';
import 'package:littrack_mobile/providers/obavijest_provider.dart';
import 'package:littrack_mobile/screens/login_screen.dart';
import 'package:littrack_mobile/screens/registracija_screen_1.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KorisnikProvider()),
        ChangeNotifierProvider(create: (_) => AutorProvider()),
        ChangeNotifierProvider(create: (_) => CiljnaGrupaProvider()),
        ChangeNotifierProvider(create: (_) => KnjigaProvider()),
        ChangeNotifierProvider(create: (_) => RecenzijaProvider()),
        ChangeNotifierProvider(create: (_) => RecenzijaOdgovorProvider()),
        ChangeNotifierProvider(create: (_) => UlogaProvider()),
        ChangeNotifierProvider(create: (_) => ZanrProvider()),
        ChangeNotifierProvider(create: (_) => ArhivaProvider()),
        ChangeNotifierProvider(create: (_) => MojaListumProvider()),
        ChangeNotifierProvider(create: (_) => PreporukaProvider()),
        ChangeNotifierProvider(create: (_) => LicnaPreporukaProvider()),
        ChangeNotifierProvider(create: (_) => NarudzbaProvider()),
        ChangeNotifierProvider(create: (_) => StavkaNarudzbeProvider()),
        ChangeNotifierProvider(create: (_) => ObavijestProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LitTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF43675E)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const StartPage(),
    );
  }
}

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/login_top.png", width: 150),
          ),
          // DONJA SLIKA
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/login_bottom.png", width: 150),
          ),
          // GLAVNI SADRŽAJ
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/logo.png",
                          width: 45, height: 45),
                      const SizedBox(width: 10),
                      const Text(
                        "LitTrack",
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Image.asset("assets/images/login_middle.png", width: 130),
                  const SizedBox(height: 40),
                  const Text(
                    "Dobrodošli na LitTrack!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF43675E),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "PRIJAVA",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const RegistracijaScreen1()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB2D9CF),
                        foregroundColor: Colors.black87,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: const Text(
                        "REGISTRACIJA",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
