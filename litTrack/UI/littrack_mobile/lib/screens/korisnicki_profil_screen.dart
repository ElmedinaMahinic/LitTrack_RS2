import 'package:flutter/material.dart';

class KorisnickiProfilScreen extends StatefulWidget {
  const KorisnickiProfilScreen({super.key});

  @override
  State<KorisnickiProfilScreen> createState() => _KorisnickiProfilScreenState();
}

class _KorisnickiProfilScreenState extends State<KorisnickiProfilScreen> {
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            Center(
              child: Text(
                'Ovo je ekran Korisnički profil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
