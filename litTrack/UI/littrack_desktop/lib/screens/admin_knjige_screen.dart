import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class AdminKnjigeScreen extends StatefulWidget {
  const AdminKnjigeScreen({super.key});

  @override
  State<AdminKnjigeScreen> createState() => _AdminKnjigeScreenState();
}

class _AdminKnjigeScreenState extends State<AdminKnjigeScreen> {
  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Knjige',
      child: Center(
        child: Text(
          "Ovo je screen za knjige",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}