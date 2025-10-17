import 'package:flutter/material.dart';

class PreporukeFavoritiScreen extends StatefulWidget {
  const PreporukeFavoritiScreen({super.key});

  @override
  State<PreporukeFavoritiScreen> createState() => _PreporukeFavoritiScreenState();
}

class _PreporukeFavoritiScreenState extends State<PreporukeFavoritiScreen> {
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
                'Ovo je ekran Preporuke i favoriti',
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
