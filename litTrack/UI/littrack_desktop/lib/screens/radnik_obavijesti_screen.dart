import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';

class RadnikObavijestiScreen extends StatefulWidget {
  const RadnikObavijestiScreen({super.key});

  @override
  State<RadnikObavijestiScreen> createState() => _RadnikObavijestiScreenState();
}

class _RadnikObavijestiScreenState extends State<RadnikObavijestiScreen> {
  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Obavijesti',
      child: Center(
        child: Text(
          "Ovo je Obavijesti screen",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}