import 'package:flutter/material.dart';
import 'package:littrack_mobile/screens/registracija_screen_2.dart';
import 'package:littrack_mobile/screens/login_screen.dart';

class RegistracijaScreen1 extends StatefulWidget {
  const RegistracijaScreen1({super.key});

  @override
  State<RegistracijaScreen1> createState() => _RegistracijaScreen1State();
}

class _RegistracijaScreen1State extends State<RegistracijaScreen1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset("assets/images/login_top.png", width: 150),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/login_bottom.png", width: 150),
          ),
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/logo.png",
                          width: 45, height: 45),
                      const SizedBox(width: 10),
                      const Text(
                        "LitTrack",
                        style: TextStyle(
                          fontSize: 29,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Image.asset("assets/images/login_middle_mobile.png",
                      width: 220),
                  const SizedBox(height: 20),
                  const Text(
                    "Nemate korisnički račun?",
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "Kreirajte ga!",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF43675E),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: 180,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegistracijaScreen2(),
                          ),
                        );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.resolveWith<Color>((states) {
                          if (states.contains(WidgetState.pressed)) {
                            return const Color(0xFF33585B);
                          }
                          return const Color(0xFF43675E);
                        }),
                        foregroundColor:
                            WidgetStateProperty.all(Colors.white),
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        shadowColor: WidgetStateProperty.all(
                            Colors.black.withAlpha(77)),
                        elevation: WidgetStateProperty.all(6),
                      ),
                      child: const Text(
                        "NASTAVI",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Imate račun?",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          "Prijavite se!",
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF43675E),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
