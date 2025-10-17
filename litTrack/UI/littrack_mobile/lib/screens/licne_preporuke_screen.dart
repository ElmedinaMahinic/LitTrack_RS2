import 'package:flutter/material.dart';

class LicnePreporukeScreen extends StatefulWidget {
  const LicnePreporukeScreen({super.key});

  @override
  State<LicnePreporukeScreen> createState() => _LicnePreporukeScreenState();
}

class _LicnePreporukeScreenState extends State<LicnePreporukeScreen> {
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
                'Ovo je ekran Lične preporuke',
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
