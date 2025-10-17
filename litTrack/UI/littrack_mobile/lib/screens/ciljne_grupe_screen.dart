import 'package:flutter/material.dart';

class CiljneGrupeScreen extends StatefulWidget {
  const CiljneGrupeScreen({super.key});

  @override
  State<CiljneGrupeScreen> createState() => _CiljneGrupeScreenState();
}

class _CiljneGrupeScreenState extends State<CiljneGrupeScreen> {
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
                'Ovo je ekran Ciljne grupe',
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
