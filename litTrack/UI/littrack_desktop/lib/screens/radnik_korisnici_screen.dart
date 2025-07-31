import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class RadnikKorisniciScreen extends StatefulWidget {
  const RadnikKorisniciScreen({super.key});

  @override
  State<RadnikKorisniciScreen> createState() => _RadnikKorisniciScreenState();
}

class _RadnikKorisniciScreenState extends State<RadnikKorisniciScreen> {
  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Korisnici',
      child: Center(
        child: Text(
          "Ovo je Korisnici screen",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}