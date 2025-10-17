import 'package:flutter/material.dart';

class ObavijestiScreen extends StatefulWidget {
  const ObavijestiScreen({super.key});

  @override
  State<ObavijestiScreen> createState() => _ObavijestiScreenState();
}

class _ObavijestiScreenState extends State<ObavijestiScreen> {
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
                'Ovo je ekran Obavijesti',
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
