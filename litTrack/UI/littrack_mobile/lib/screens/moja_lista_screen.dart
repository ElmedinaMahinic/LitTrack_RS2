import 'package:flutter/material.dart';

class MojaListaScreen extends StatefulWidget {
  const MojaListaScreen({super.key});

  @override
  State<MojaListaScreen> createState() => _MojaListaScreenState();
}

class _MojaListaScreenState extends State<MojaListaScreen> {
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
                'Ovo je ekran Moja lista',
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

