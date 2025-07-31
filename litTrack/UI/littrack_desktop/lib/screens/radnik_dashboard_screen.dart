import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class RadnikDashboardScreen extends StatefulWidget {
  const RadnikDashboardScreen({super.key});

  @override
  State<RadnikDashboardScreen> createState() => _RadnikDashboardScreenState();
}

class _RadnikDashboardScreenState extends State<RadnikDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Statistika radnika',
      child: Center(
        child: Text(
          "Dobrodošli, Radnik!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}