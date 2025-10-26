import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_mobile/models/licna_preporuka.dart';
import 'package:littrack_mobile/providers/licna_preporuka_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';

class LicnePreporukeDetailsScreen extends StatefulWidget {
  final LicnaPreporuka licnaPreporuka;

  const LicnePreporukeDetailsScreen({
    super.key,
    required this.licnaPreporuka,
  });

  @override
  State<LicnePreporukeDetailsScreen> createState() =>
      _LicnePreporukeDetailsScreenState();
}

class _LicnePreporukeDetailsScreenState
    extends State<LicnePreporukeDetailsScreen> {
  late final String posiljalac;
  late final String primalac;
  late final String naslov;
  late final String poruka;
  late final DateTime datumPreporuke;
  late final List<String> knjige;

  late LicnaPreporukaProvider _licnaPreporukaProvider;

  @override
  void initState() {
    super.initState();

    posiljalac = widget.licnaPreporuka.posiljalacKorisnickoIme ?? "/";
    primalac = widget.licnaPreporuka.primalacKorisnickoIme ?? "/";
    naslov = widget.licnaPreporuka.naslov ?? "/";
    poruka = widget.licnaPreporuka.poruka ?? "/";
    datumPreporuke = widget.licnaPreporuka.datumPreporuke;
    knjige = widget.licnaPreporuka.knjige;

    _licnaPreporukaProvider = context.read<LicnaPreporukaProvider>();
    _oznaciKaoPogledanu();
  }

  Future<void> _oznaciKaoPogledanu() async {
    try {
      if (widget.licnaPreporuka.korisnikPrimalacId == AuthProvider.korisnikId) {
        if (widget.licnaPreporuka.licnaPreporukaId != null) {
          await _licnaPreporukaProvider
              .oznaciKaoPogledanu(widget.licnaPreporuka.licnaPreporukaId!);
        }
      }
    } catch (e) {
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 25,
        backgroundColor: const Color(0xFFF6F4F3),
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
                    size: 35,
                  ),
                  onPressed: () => Navigator.pop(context, true),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 45,
                      width: 45,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "LitTrack",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {},
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
                const SizedBox(height: 20),
                _buildPorukaBox(),
                if (knjige.isNotEmpty) ...[
                  const SizedBox(height: 20),
                  _buildKnjigeBox(),
                ],
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
      ),
      child: const Center(
        child: Text(
          "Detalji preporuke",
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
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Pošiljalac:", posiljalac, Icons.person_outline),
          _buildInfoRow("Primalac:", primalac, Icons.person_outline),
          _buildInfoRow("Naslov:", naslov, Icons.title),
          _buildInfoRow(
            "Datum preporuke:",
            DateFormat('dd.MM.yyyy. HH:mm').format(datumPreporuke.toLocal()),
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor ?? const Color(0xFF3C6E71), size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF3C6E71),
                ),
                children: [
                  TextSpan(
                    text: "$label ",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPorukaBox() {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Poruka",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF3C6E71),
            ),
          ),
          const Divider(height: 20, thickness: 1),
          Text(
            poruka,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKnjigeBox() {
    final naslovTekst =
        knjige.length == 1 ? "Preporučena knjiga" : "Preporučene knjige";

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            naslovTekst,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Color(0xFF3C6E71),
            ),
          ),
          const Divider(height: 20, thickness: 1),
          ...knjige.map((knjiga) => GestureDetector(
                onTap: () {
                  // TODO: implementiraj navigaciju na details screen za knjigu
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text(
                    knjiga,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
