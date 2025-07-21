import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class AdminRecenzijeScreen extends StatefulWidget {
  const AdminRecenzijeScreen({super.key});

  @override
  State<AdminRecenzijeScreen> createState() => _AdminRecenzijeScreenState();
}

class _AdminRecenzijeScreenState extends State<AdminRecenzijeScreen> {
  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Recenzije',
      child: Center(
        child: Text(
          "Ovo je screen za recenzije",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}