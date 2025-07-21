import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/providers/korisnik_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/screens/admin_dashboard_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => KorisnikProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LitTrack',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF43675E)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _isHidden = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    AuthProvider.isSignedIn = false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    double formWidth = screenWidth * 0.4;
    if (formWidth > 320) formWidth = 320;

    double inputHeight = screenHeight * 0.05;
    if (inputHeight > 48) inputHeight = 48;

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
                  // LOGO + TEXT
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/logo.png",
                          width: 45, height: 45),
                      const SizedBox(width: 10),
                      const Text(
                        "LitTrack",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 45),

                  // MAIN MIDDLE IMAGE
                  Image.asset("assets/images/login_middle.png", width: 130),
                  const SizedBox(height: 45),

                  // LOGIN FORM
                  Form(
                    key: _formKey,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: formWidth),
                      child: Column(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: screenHeight * 0.045,
                            ),
                            child: TextFormField(
                              controller: _usernameController,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Korisničko ime",
                                hintStyle: const TextStyle(
                                    color: Color(0xFF344743), fontSize: 14),
                                filled: true,
                                fillColor: const Color(0xFFB2D9CF),
                                prefixIcon: const Icon(Icons.person, size: 20),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Unesite korisničko ime';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: screenHeight * 0.045,
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _isHidden,
                              decoration: InputDecoration(
                                isDense: true,
                                hintText: "Lozinka",
                                hintStyle: const TextStyle(
                                    color: Color(0xFF344743), fontSize: 14),
                                filled: true,
                                fillColor: const Color(0xFFB2D9CF),
                                prefixIcon: const Icon(Icons.lock, size: 20),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isHidden = !_isHidden;
                                    });
                                  },
                                  child: Icon(
                                    _isHidden
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 12),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Unesite lozinku';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: inputHeight,
                            child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final korisnikProvider = KorisnikProvider();
                                    final korisnik =
                                        await korisnikProvider.login(
                                      _usernameController.text,
                                      _passwordController.text,
                                    );

                                    // Provjera da li je deaktiviran
                                    if (korisnik.jeAktivan == false) {
                                      await showCustomDialog(
                                        context: context,
                                        title: 'Račun deaktiviran',
                                        message:
                                            'Vaš korisnički račun je deaktiviran!',
                                        icon: Icons.block,
                                        iconColor: Colors.red,
                                        buttonColor: const Color(0xFF43675E),
                                      );
                                      return;
                                    }

                                    // Postavi isSignedIn na true nakon uspješne prijave
                                    AuthProvider.isSignedIn = true;

                                    // Provjera uloge
                                    if (AuthProvider.uloge != null &&
                                        AuthProvider.uloge!.contains("Admin")) {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const AdminDashboardScreen(),
                                        ),
                                      );
                                    } else {
                                      await showCustomDialog(
                                        context: context,
                                        title: 'Pristup odbijen',
                                        message:
                                            'Nemate pristup ovom interfejsu.',
                                        icon: Icons.lock_outline,
                                        iconColor: Colors.red,
                                        buttonColor: const Color(0xFF43675E),
                                      );
                                    }
                                  } catch (e) {
                                    await showCustomDialog(
                                      context: context,
                                      title: 'Greška',
                                      message: e.toString(),
                                      icon: Icons.error_outline,
                                      iconColor: Colors.red,
                                      buttonColor: const Color(0xFF43675E),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF43675E),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text(
                                "PRIJAVA",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
