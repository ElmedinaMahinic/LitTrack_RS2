import 'package:flutter/material.dart';

class PreporukaScreen extends StatefulWidget {
  const PreporukaScreen({super.key});

  @override
  State<PreporukaScreen> createState() => _PreporukaScreenState();
}

class _PreporukaScreenState extends State<PreporukaScreen> {
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
                'Ovo je ekran Preporuka',
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
