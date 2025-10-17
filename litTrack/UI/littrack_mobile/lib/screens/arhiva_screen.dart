import 'package:flutter/material.dart';

class ArhivaScreen extends StatefulWidget {
  const ArhivaScreen({super.key});

  @override
  State<ArhivaScreen> createState() => _ArhivaScreenState();
}

class _ArhivaScreenState extends State<ArhivaScreen> {
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
                'Ovo je ekran Arhiva',
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
