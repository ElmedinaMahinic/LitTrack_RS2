import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class AdminKorisniciScreen extends StatefulWidget {
  const AdminKorisniciScreen({super.key});

  @override
  State<AdminKorisniciScreen> createState() => _AdminKorisniciScreenState();
}

class _AdminKorisniciScreenState extends State<AdminKorisniciScreen> {
  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Korisnici',
      child: Center(
        child: Text(
          "Ovo je screen za korisnike",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}