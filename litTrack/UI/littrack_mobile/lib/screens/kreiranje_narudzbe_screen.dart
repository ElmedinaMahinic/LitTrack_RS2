import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:littrack_mobile/providers/narudzba_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/cart_provider.dart';
import 'package:littrack_mobile/providers/nacin_placanja_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/layouts/master_screen.dart';

class KreiranjeNarudzbeScreen extends StatefulWidget {
  final List<MapEntry<String, dynamic>> odabraneKnjige;
  final double ukupnaCijena;

  const KreiranjeNarudzbeScreen({
    super.key,
    required this.odabraneKnjige,
    required this.ukupnaCijena,
  });

  @override
  State<KreiranjeNarudzbeScreen> createState() =>
      _KreiranjeNarudzbeScreenState();
}

class _KreiranjeNarudzbeScreenState extends State<KreiranjeNarudzbeScreen> {
  CartProvider? _cartProvider;
  late NarudzbaProvider narudzbaProvider;
  late NacinPlacanjaProvider _nacinPlacanjaProvider;

  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  late int brojStavki;
  late int ukupnoKnjiga;
  List<dynamic> _naciniPlacanja = [];
  int? _odabraniNacinPlacanja;
  bool _isLoading = false;
  bool _isCreatingOrder = false;

  @override
  void initState() {
    super.initState();
    brojStavki = widget.odabraneKnjige.length;

    ukupnoKnjiga = widget.odabraneKnjige.fold<int>(
      0,
      (sum, element) => sum + (element.value['kolicina'] as int),
    );

    if (AuthProvider.korisnikId != null) {
      _cartProvider = CartProvider(AuthProvider.korisnikId!);
    }

    narudzbaProvider = context.read<NarudzbaProvider>();
    _nacinPlacanjaProvider = context.read<NacinPlacanjaProvider>();

    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final result = await _nacinPlacanjaProvider.get();
      if (!mounted) return;
      setState(() => _naciniPlacanja = result.resultList);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 15,
        backgroundColor: const Color(0xFFF6F4F3),
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 40,
                      width: 40,
                    ),
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
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            const SizedBox(height: 24),
                            _buildOrderOverview(),
                            const SizedBox(height: 28),
                            _buildAdresaInput(),
                            const SizedBox(height: 25),
                            _buildNacinPlacanja(),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _buildFooter(),
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
        color: const Color(0xFFD55B91),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Pregled narudžbe",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.shopping_bag, color: Colors.white, size: 22),
        ],
      ),
    );
  }

  Widget _buildOrderOverview() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Broj stavki:", brojStavki.toString(),
              Icons.format_list_numbered),
          _buildInfoRow("Ukupan broj knjiga:", ukupnoKnjiga.toString(),
              Icons.library_books),
          _buildInfoRow(
              "Ukupna cijena:",
              "${widget.ukupnaCijena.toStringAsFixed(2)} KM",
              Icons.attach_money),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? const Color(0xFF3C6E71), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              "$label $value",
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF3C6E71),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdresaInput() {
    return FormBuilder(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.home, color: Color(0xFF3C6E71), size: 22),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Unesite vašu adresu u ovom formatu:',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              child: Text(
                'Grad, adresa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF3C6E71),
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          FormBuilderTextField(
            name: 'adresa',
            validator: FormBuilderValidators.compose([
              FormBuilderValidators.required(
                errorText: "Adresa je obavezna.",
              ),
              FormBuilderValidators.maxLength(
                200,
                errorText: "Adresa može imati maksimalno 200 karaktera.",
              ),
              (value) {
                if (value == null || !value.contains(",")) {
                  return "Format mora biti: Grad, adresa";
                }
                final parts = value.split(",");
                if (parts.length < 2 ||
                    parts[0].trim().isEmpty ||
                    parts[1].trim().isEmpty) {
                  return "Format mora biti: Grad, adresa";
                }
                return null;
              },
            ]),
            decoration: InputDecoration(
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              labelText: "Adresa dostave",
              floatingLabelBehavior: FloatingLabelBehavior.always,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNacinPlacanja() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Odaberite način plaćanja",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 15.5,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 13),
        Center(
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: _naciniPlacanja.map((np) {
              IconData ikonica;
              final naziv = np.naziv.toString().toLowerCase();
              if (naziv == "gotovina") {
                ikonica = Icons.attach_money;
              } else if (naziv == "paypal") {
                ikonica = Icons.credit_card;
              } else {
                ikonica = Icons.payment;
              }
              final isSelected = _odabraniNacinPlacanja == np.nacinPlacanjaId;
              return SizedBox(
                width: 140,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() => _odabraniNacinPlacanja = np.nacinPlacanjaId);
                  },
                  icon: Icon(
                    ikonica,
                    color: isSelected ? Colors.white : const Color(0xFF3C6E71),
                  ),
                  label: Text(
                    np.naziv,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xFF3C6E71),
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (isSelected) return const Color(0xFF3C6E71);
                      if (states.contains(MaterialState.pressed)) {
                        return const Color(0xFFE0E0E0);
                      }
                      return const Color(0xFFFFFFFF);
                    }),
                    surfaceTintColor:
                        MaterialStateProperty.all(Colors.transparent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                        side: BorderSide(
                          color: isSelected
                              ? const Color(0xFF3C6E71)
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(3),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4F3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, -3),
            blurRadius: 6,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Divider(
            color: Color(0xFF3C6E71),
            height: 1.0,
            thickness: 2,
          ),
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
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    "${widget.ukupnaCijena.toStringAsFixed(2)} KM",
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
                width: 160,
                height: 45,
                child: ElevatedButton(
                  onPressed: _isCreatingOrder
                      ? null
                      : () {
                          showConfirmDialog(
                            context: context,
                            title: "Kreiranje narudžbe",
                            message:
                                "Da li ste sigurni da želite kreirati narudžbu?",
                            icon: Icons.shopping_bag,
                            iconColor: Colors.red,
                            onConfirm: _onKreirajPressed,
                          );
                        },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.resolveWith<Color>((states) {
                      if (_isCreatingOrder) return Colors.grey;
                      if (states.contains(MaterialState.pressed)) {
                        return const Color(0xFF33585B);
                      }
                      return const Color(0xFF3C6E71);
                    }),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    shadowColor: MaterialStateProperty.all(
                      Colors.black.withOpacity(0.3),
                    ),
                    elevation: MaterialStateProperty.all(6),
                  ),
                  child: _isCreatingOrder
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          "Kreiraj",
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

  Future<void> _onKreirajPressed() async {
    final isValid = _formKey.currentState?.saveAndValidate();
    if (isValid != true) return;

    if (_odabraniNacinPlacanja == null) {
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: "Molimo odaberite način plaćanja.",
        icon: Icons.error,
        iconColor: Colors.red,
      );
      return;
    }

    final formValues = Map<String, dynamic>.from(_formKey.currentState!.value);
    final adresa = (formValues['adresa'] as String).trim();

    final odabraniObjekat = _naciniPlacanja
        .firstWhere((np) => np.nacinPlacanjaId == _odabraniNacinPlacanja);
    final nazivPlacanja = odabraniObjekat.naziv.toString().toLowerCase();

    if (nazivPlacanja == "gotovina") {
      await _kreirajNarudzbuGotovina(adresa);
    } else {}
  }

  Future<void> _kreirajNarudzbuGotovina(String adresa) async {
    if (!mounted) return;
    setState(() => _isCreatingOrder = true);

    try {
      final narudzbaRequest = {
        "korisnikId": AuthProvider.korisnikId!,
        "nacinPlacanjaId": _odabraniNacinPlacanja!,
        "adresa": adresa,
        "stavkeNarudzbe": widget.odabraneKnjige.map((entry) {
          final knjiga = entry.value;
          return {
            "knjigaId": knjiga['id'],
            "kolicina": knjiga['kolicina'],
          };
        }).toList(),
      };

      await narudzbaProvider.insert(narudzbaRequest);
      _cartProvider?.clearCart();

      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Uspješno kreirana narudžba",
        message: "Vaša narudžba je uspješno kreirana.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );

      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MasterScreen()),
      );
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
      );
    } finally {
      if (mounted) setState(() => _isCreatingOrder = false);
    }
  }
}
