import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_mobile/models/narudzba.dart';
import 'package:littrack_mobile/models/stavka_narudzbe.dart';
import 'package:littrack_mobile/providers/narudzba_provider.dart';
import 'package:littrack_mobile/providers/stavka_narudzbe_provider.dart';
import 'package:littrack_mobile/screens/korpa_screen.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class NarudzbeDetailsScreen extends StatefulWidget {
  final Narudzba narudzba;

  const NarudzbeDetailsScreen({super.key, required this.narudzba});

  @override
  State<NarudzbeDetailsScreen> createState() => _NarudzbeDetailsScreenState();
}

class _NarudzbeDetailsScreenState extends State<NarudzbeDetailsScreen> {
  late final String sifra;
  late final DateTime datumNarudzbe;
  late final double ukupnaCijena;
  late String status;
  late final String imePrezime;
  late final String nacinPlacanja;
  late final int brojStavki;
  late final int ukupanBrojKnjiga;
  late final String? adresa;

  late StavkaNarudzbeProvider _stavkaProvider;
  late NarudzbaProvider _narudzbaProvider;

  bool showStavke = false;
  bool isLoadingStavke = false;
  bool isActionDisabled = false;
  List<StavkaNarudzbe> stavke = [];

  @override
  void initState() {
    super.initState();
    final narudzba = widget.narudzba;
    sifra = narudzba.sifra;
    datumNarudzbe = narudzba.datumNarudzbe;
    ukupnaCijena = narudzba.ukupnaCijena;
    status = narudzba.stateMachine ?? "/";
    imePrezime = narudzba.imePrezime ?? "/";
    nacinPlacanja = narudzba.nacinPlacanja ?? "/";
    brojStavki = narudzba.brojStavki ?? 0;
    ukupanBrojKnjiga = narudzba.ukupanBrojKnjiga ?? 0;
    adresa = narudzba.adresa ?? "/";

    _stavkaProvider = context.read<StavkaNarudzbeProvider>();
    _narudzbaProvider = context.read<NarudzbaProvider>();
  }

  Future<void> loadStavke() async {
    if (!mounted) return;
    setState(() => isLoadingStavke = true);

    try {
      final result = await _stavkaProvider.get(filter: {
        "NarudzbaId": widget.narudzba.narudzbaId,
      });

      if (!mounted) return;
      setState(() {
        stavke = result.resultList;
      });
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => isLoadingStavke = false);
      }
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
        surfaceTintColor: Colors.transparent,
        forceMaterialTransparency: false,
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 30,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KorpaScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                _buildInfoSection(),
                const SizedBox(height: 24),
                _buildStavkeToggleButton(),
                if (showStavke) ...[
                  const SizedBox(height: 20),
                  _buildStavkeSection(),
                ],
                const SizedBox(height: 30),
                _buildActionButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
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
      child: const Center(
        child: Text(
          "Detalji narudžbe",
          style: TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Šifra:", sifra, Icons.confirmation_number_outlined),
          _buildInfoRow(
            "Datum kreiranja:",
            DateFormat('dd.MM.yyyy.').format(datumNarudzbe.toLocal()),
            Icons.calendar_today_outlined,
          ),
          _buildInfoRow("Ukupna cijena:",
              "${ukupnaCijena.toStringAsFixed(2)} KM", Icons.attach_money),
          _buildInfoRow("Status:", status, Icons.info_outline),
          _buildInfoRow("Naručilac:", imePrezime, Icons.person_outline),
          _buildInfoRow("Adresa:", adresa ?? "/", Icons.location_on_outlined),
          _buildInfoRow(
              "Način plaćanja:", nacinPlacanja, Icons.payment_outlined),
          _buildInfoRow("Broj stavki:", brojStavki.toString(),
              Icons.format_list_numbered_outlined),
          _buildInfoRow("Ukupan broj knjiga:", ukupanBrojKnjiga.toString(),
              Icons.library_books_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: const Color(0xFF3C6E71), size: 22),
          const SizedBox(width: 10),
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xFF3C6E71),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStavkeToggleButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () async {
          if (!showStavke) await loadStavke();
          if (!mounted) return;
          setState(() => showStavke = !showStavke);
        },
        icon: Icon(
          showStavke ? Icons.hide_source : Icons.shopping_basket,
          color: const Color(0xFF3C6E71),
        ),
        label: Text(
          showStavke ? "Sakrij stavke" : "Prikaži stavke",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF3C6E71),
          ),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          overlayColor: const Color(0xFF3C6E71).withAlpha(26),
        ),
      ),
    );
  }

  Widget _buildStavkeSection() {
    if (isLoadingStavke) {
      return const Center(child: CircularProgressIndicator());
    } else if (stavke.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.shopping_basket,
              color: Color(0xFF3C6E71),
              size: 50,
            ),
            SizedBox(height: 10),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Nema stavki za ovu narudžbu.",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3C6E71),
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: stavke.map((stavka) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(51),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const SizedBox(width: 4),
                _buildImage(stavka.slika),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        stavka.nazivKnjige ?? "-",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${stavka.cijena.toStringAsFixed(2)} KM",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF3C6E71),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "${stavka.kolicina} kom",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF3C6E71),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    }
  }

  Widget _buildActionButtons() {
    final bool canOtkazi = nacinPlacanja.toLowerCase() == "gotovina" &&
        status.toLowerCase() == "kreirana";

    final bool canZavrsi = status.toLowerCase() == "utoku";

    ButtonStyle buttonStyle(bool enabled) {
      return ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (!enabled) return Colors.grey;
          if (states.contains(WidgetState.pressed)) {
            return const Color(0xFF33585B);
          }
          return const Color(0xFF3C6E71);
        }),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        shadowColor: WidgetStateProperty.all(Colors.black.withAlpha(77)),
        elevation: WidgetStateProperty.all(6),
      );
    }

    void showInfo(String message) {
      showCustomSnackBar(
        context: context,
        message: message,
      );
    }

    Widget buildButtonWithInfo({
      required bool enabled,
      required IconData icon,
      required String label,
      required VoidCallback? onPressed,
      required String infoMessage,
    }) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 220,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: enabled ? onPressed : null,
              icon: Icon(icon, color: Colors.white),
              label: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              style: buttonStyle(enabled),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => showInfo(infoMessage),
            child: const Icon(Icons.info_outline, size: 22, color: Colors.grey),
          ),
        ],
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 22),
      child: Column(
        children: [
          buildButtonWithInfo(
            enabled: canOtkazi && !isActionDisabled,
            icon: Icons.cancel_outlined,
            label:
                status.toLowerCase() == "ponistena" ? "Poništena" : "Poništi",
            onPressed: () {
              showConfirmDialog(
                context: context,
                title: "Poništavanje narudžbe",
                message: "Da li ste sigurni da želite poništiti narudžbu?",
                icon: Icons.cancel_outlined,
                iconColor: const Color(0xFF3C6E71),
                onConfirm: _otkaziNarudzbu,
              );
            },
            infoMessage:
                "Narudžbu možete poništiti ako plaćate gotovinom i ako još nije preuzeta za obradu.",
          ),
          const SizedBox(height: 12),
          buildButtonWithInfo(
            enabled: canZavrsi && !isActionDisabled,
            icon: Icons.check_circle_outline,
            label: status.toLowerCase() == "zavrsena" ? "Završena" : "Završi",
            onPressed: () {
              showConfirmDialog(
                context: context,
                title: "Završavanje narudžbe",
                message: "Da li ste sigurni da želite završiti narudžbu?",
                icon: Icons.check_circle_outline,
                iconColor: const Color(0xFF3C6E71),
                onConfirm: _zavrsiNarudzbu,
              );
            },
            infoMessage: "Kliknite dugme Završi kada primite narudžbu.",
          ),
        ],
      ),
    );
  }

  Future<void> _otkaziNarudzbu() async {
    try {
      await _narudzbaProvider.ponisti(widget.narudzba.narudzbaId!);

      if (!mounted) return;
      setState(() {
        status = "ponistena";
        isActionDisabled = true;
      });
      await showCustomDialog(
        context: context,
        title: "Uspjeh",
        message: "Narudžba je uspješno poništena.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Future<void> _zavrsiNarudzbu() async {
    try {
      await _narudzbaProvider.zavrsi(widget.narudzba.narudzbaId!);
      if (!mounted) return;
      setState(() {
        status = "zavrsena";
        isActionDisabled = true;
      });
      await showCustomDialog(
        context: context,
        title: "Uspjeh",
        message: "Narudžba je uspješno završena.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Widget _buildImage(String? slikaBase64) {
    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return Image.asset(
        "assets/images/placeholder.png",
        width: 81,
        height: 115,
        fit: BoxFit.fill,
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 81,
          height: 115,
          child: imageFromString(slikaBase64),
        ),
      );
    } catch (_) {
      return const Icon(Icons.broken_image, size: 80);
    }
  }
}
