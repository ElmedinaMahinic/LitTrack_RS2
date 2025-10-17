import 'package:flutter/material.dart';

class AutoriScreen extends StatefulWidget {
  const AutoriScreen({super.key});

  @override
  State<AutoriScreen> createState() => _AutoriScreenState();
}

class _AutoriScreenState extends State<AutoriScreen> {
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
                'Ovo je ekran Autori',
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
