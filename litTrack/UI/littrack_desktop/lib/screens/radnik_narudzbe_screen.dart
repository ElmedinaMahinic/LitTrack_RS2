import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class RadnikNarudzbeScreen extends StatefulWidget {
  const RadnikNarudzbeScreen({super.key});

  @override
  State<RadnikNarudzbeScreen> createState() => _RadnikNarudzbeScreenState();
}

class _RadnikNarudzbeScreenState extends State<RadnikNarudzbeScreen> {
  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Narudžbe',
      child: Center(
        child: Text(
          "Ovo je Narudžbe screen",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
