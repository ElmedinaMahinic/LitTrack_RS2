import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littrack_mobile/providers/cart_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/screens/kreiranje_narudzbe_screen.dart';

class KorpaScreen extends StatefulWidget {
  const KorpaScreen({super.key});

  @override
  State<KorpaScreen> createState() => _KorpaScreenState();
}

class _KorpaScreenState extends State<KorpaScreen> {
  CartProvider? _cartProvider;
  Map<String, dynamic> cartItems = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    if (AuthProvider.korisnikId != null) {
      _cartProvider = CartProvider(AuthProvider.korisnikId!);
      _loadCart();
    }
  }

  Future<void> _loadCart() async {
    if (_cartProvider == null) return;
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final data = await _cartProvider!.getCart();
      if (!mounted) return;
      setState(() {
        cartItems = Map<String, dynamic>.from(data);
      });
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String formatNumber(num value) {
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF6F4F3),
        toolbarHeight: kToolbarHeight + 15,
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 30),
                  onPressed: () => Navigator.pop(context, true),
                ),
                Row(
                  children: [
                    Image.asset("assets/images/logo.png",
                        height: 40, width: 40),
                    const SizedBox(width: 8),
                    const Text(
                      "LitTrack",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 48),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildHeader(),
                      const SizedBox(height: 24),
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (cartItems.isEmpty)
                        const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.shopping_cart_outlined,
                                  color: Color(0xFF3C6E71), size: 50),
                              SizedBox(height: 10),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text(
                                  "Vaša korpa je prazna.",
                                  style: TextStyle(
                                      fontSize: 16, color: Color(0xFF3C6E71)),
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
                              itemCount: cartItems.length,
                              itemBuilder: (context, index) {
                                final key = cartItems.keys.elementAt(index);
                                final knjiga = cartItems[key]!;
                                return _buildKnjigaCard(knjiga, key);
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
            if (!_isLoading && cartItems.isNotEmpty) _buildFooter(),
            const SizedBox(height: 20),
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
        color: const Color(0xFF3C6E71),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Moja korpa",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.shopping_cart, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildKnjigaCard(Map<String, dynamic> knjigaDetails, String key) {
    return Container(
      width: double.infinity,
      height: 120,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Slidable(
        key: ValueKey(key),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) async {
                try {
                  await _cartProvider?.deleteFromCart(knjigaDetails['id']);
                  if (!context.mounted) return;

                  showCustomSnackBar(
                    context: context,
                    message: "Knjiga je uklonjena iz korpe.",
                    icon: Icons.delete,
                  );

                  await _loadCart();
                } catch (e) {
                  if (!context.mounted) return;
                  showCustomDialog(
                    context: context,
                    title: "Greška",
                    message: "Nije moguće ukloniti knjigu: $e",
                    icon: Icons.error,
                  );
                }
              },
              backgroundColor: Colors.black,
              icon: Icons.delete,
              label: 'Obriši',
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 10),
            SizedBox(
              width: 81,
              height: 115,
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(12)),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: knjigaDetails['slika'] != null &&
                          knjigaDetails['slika'] is String
                      ? imageFromString(knjigaDetails['slika'])
                      : Image.asset(
                          "assets/images/placeholder.png",
                          fit: BoxFit.fill,
                        ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      knjigaDetails['naziv'] ?? '',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      knjigaDetails['autorNaziv'] ?? '-',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${formatNumber(knjigaDetails['cijena'])} KM',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF3C6E71),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 12, bottom: 6),
                          child: Row(
                            children: [
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: knjigaDetails['kolicina'] > 1
                                      ? () async {
                                          try {
                                            knjigaDetails['kolicina']--;
                                            await _cartProvider!.updateCart(
                                              knjigaDetails['id'],
                                              knjigaDetails['kolicina'],
                                            );
                                            if (!mounted) return;
                                            setState(() {});
                                          } catch (e) {
                                            if (!mounted) return;
                                            showCustomDialog(
                                              context: context,
                                              title: "Greška",
                                              message:
                                                  "Ažuriranje količine nije uspjelo: $e",
                                              icon: Icons.error,
                                            );
                                          }
                                        }
                                      : null,
                                  child: _circleBtn(
                                    icon: Icons.remove,
                                    enabled: knjigaDetails['kolicina'] > 1,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  '${knjigaDetails['kolicina']}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  onTap: knjigaDetails['kolicina'] < 10
                                      ? () async {
                                          try {
                                            knjigaDetails['kolicina']++;
                                            await _cartProvider!.updateCart(
                                              knjigaDetails['id'],
                                              knjigaDetails['kolicina'],
                                            );
                                            if (!mounted) return;
                                            setState(() {});
                                          } catch (e) {
                                            if (!mounted) return;
                                            showCustomDialog(
                                              context: context,
                                              title: "Greška",
                                              message:
                                                  "Ažuriranje količine nije uspjelo: $e",
                                              icon: Icons.error,
                                            );
                                          }
                                        }
                                      : null,
                                  child: _circleBtn(
                                    icon: Icons.add,
                                    enabled: knjigaDetails['kolicina'] < 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleBtn({required IconData icon, required bool enabled}) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: enabled ? const Color(0xFFD55B91) : Colors.grey.shade600,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white, size: 18),
    );
  }

  Widget _buildFooter() {
    final ukupno =
        formatNumber(_cartProvider!.izracunajUkupnuCijenu(cartItems));
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4F3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26),
            offset: const Offset(0, -3),
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(color: Color(0xFF3C6E71), height: 1.0, thickness: 2),
          const SizedBox(height: 15),
          const Text(
            "Ukupna cijena:",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF3C6E71),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 45,
                width: 180,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "$ukupno KM",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF3C6E71),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 140,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    if (cartItems.isEmpty) {
                      showCustomSnackBar(
                        context: context,
                        message: "Korpa je prazna.",
                        icon: Icons.info,
                      );
                      return;
                    }

                    final odabraneKnjige = cartItems.entries.toList();
                    final ukupnaCijena =
                        _cartProvider!.izracunajUkupnuCijenu(cartItems);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => KreiranjeNarudzbeScreen(
                          odabraneKnjige: odabraneKnjige,
                          ukupnaCijena: ukupnaCijena,
                        ),
                      ),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.pressed)) {
                        return const Color(0xFF33585B);
                      }
                      return const Color(0xFF3C6E71);
                    }),
                    shape: WidgetStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    shadowColor:
                        WidgetStateProperty.all(Colors.black.withAlpha(77)),
                    elevation: WidgetStateProperty.all(6),
                  ),
                  child: const Text(
                    "Naruči",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
