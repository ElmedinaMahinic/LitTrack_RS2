import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/providers/preporuka_cart_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/screens/preporuka_user_screen.dart';

class PreporukaScreen extends StatefulWidget {
  const PreporukaScreen({super.key});

  @override
  State<PreporukaScreen> createState() => _PreporukaScreenState();
}

class _PreporukaScreenState extends State<PreporukaScreen> {
  PreporukaCartProvider? _cartProvider;
  List<Map<String, dynamic>> _knjige = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (AuthProvider.korisnikId != null) {
      _cartProvider = PreporukaCartProvider(AuthProvider.korisnikId!);
      _fetchData();
    }
  }

  Future<void> _fetchData() async {
    if (_cartProvider == null) return;

    if (!mounted) return;
    setState(() => _isLoading = true);

    final data = await _cartProvider!.getPreporukaList();

    if (!mounted) return;
    setState(() {
      _knjige = data.values.map((e) => Map<String, dynamic>.from(e)).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            const Text(
              "Ne želite knjige preporučiti svima? Preporučite ih određenom čitatelju!",
              style: TextStyle(fontSize: 14, color: Color(0xFF3C6E71)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_knjige.isEmpty)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      color: Color(0xFF3C6E71),
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Nema dodanih knjiga u listu preporuka.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3C6E71),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _knjige.length,
                    itemBuilder: (context, index) {
                      final knjiga = _knjige[index];
                      return _buildKnjigaCard(knjiga);
                    },
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Ukupno knjiga: ",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '${_knjige.length}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3C6E71),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDaljeButton(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.pink,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Lična preporuka",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.mail_outline, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildKnjigaCard(Map<String, dynamic> knjiga) {
    return Container(
      width: double.infinity,
      height: 110,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Slidable(
        startActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                await _cartProvider?.removeKnjiga(knjiga['id']);
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFFD5E0DB),
                    duration: Duration(seconds: 2),
                    content: Center(
                      child: Text(
                        "Knjiga je uklonjena iz liste.",
                        style: TextStyle(color: Color(0xFF3C6E71)),
                      ),
                    ),
                  ),
                );
                await _fetchData();
              },
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Obriši',
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 120,
              height: 100,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: FittedBox(
                  fit: BoxFit.fill,
                  child: knjiga['slika'] != null && knjiga['slika'] is String
                      ? imageFromString(knjiga['slika'])
                      : Image.asset(
                          "assets/images/placeholder.png",
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  knjiga['naziv'] ?? "-",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDaljeButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: SizedBox(
          width: 220,
          height: 48,
          child: ElevatedButton(
            onPressed: () {
              if (_knjige.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Color(0xFFD5E0DB),
                    duration: Duration(seconds: 2),
                    content: Center(
                      child: Text(
                        "Niste dodali nijednu knjigu.",
                        style: TextStyle(color: Color(0xFF3C6E71)),
                      ),
                    ),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const PreporukaUserScreen()),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.pressed)) {
                  return const Color(0xFF33585B);
                }
                return const Color(0xFF3C6E71);
              }),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              ),
              shadowColor:
                  MaterialStateProperty.all(Colors.black.withOpacity(0.15)),
              elevation: MaterialStateProperty.all(6),
            ),
            child: const Text(
              "Dalje",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
