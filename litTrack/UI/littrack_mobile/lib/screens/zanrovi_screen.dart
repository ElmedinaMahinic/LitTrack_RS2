import 'package:flutter/material.dart';

class ZanroviScreen extends StatefulWidget {
  const ZanroviScreen({super.key});

  @override
  State<ZanroviScreen> createState() => _ZanroviScreenState();
}

class _ZanroviScreenState extends State<ZanroviScreen> {
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
                'Ovo je ekran Žanrovi',
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
