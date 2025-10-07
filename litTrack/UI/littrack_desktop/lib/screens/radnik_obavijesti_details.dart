import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/obavijest.dart';
import 'package:littrack_desktop/providers/obavijest_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:provider/provider.dart';

class RadnikObavijestiDetailsScreen extends StatefulWidget {
  final Obavijest obavijest;

  const RadnikObavijestiDetailsScreen({
    super.key,
    required this.obavijest,
  });

  @override
  State<RadnikObavijestiDetailsScreen> createState() =>
      _RadnikObavijestiDetailsScreenState();
}

class _RadnikObavijestiDetailsScreenState
    extends State<RadnikObavijestiDetailsScreen> {
  late final String primalac;
  late final String naslov;
  late final String sadrzaj;
  late final DateTime datumObavijesti;

  late ObavijestProvider _obavijestProvider;

  @override
  void initState() {
    super.initState();
    primalac = widget.obavijest.imePrezime ?? "/";
    naslov = widget.obavijest.naslov;
    sadrzaj = widget.obavijest.sadrzaj;
    datumObavijesti = widget.obavijest.datumObavijesti;

    _obavijestProvider = context.read<ObavijestProvider>();

    _oznaciKaoProcitanu();
  }

  Future<void> _oznaciKaoProcitanu() async {
    try {
      if (widget.obavijest.obavijestId != null) {
        await _obavijestProvider
            .oznaciKaoProcitanu(widget.obavijest.obavijestId!);
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
    return MasterScreen(
      title: "Detalji obavijesti",
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 20),
            _buildSadrzajBox(),
            const SizedBox(height: 30),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoRow("Primalac:", primalac, Icons.account_circle_outlined),
          _buildInfoRow("Naslov:", naslov, Icons.title),
          _buildInfoRow(
            "Datum obavijesti:",
            DateFormat('dd.MM.yyyy. HH:mm').format(datumObavijesti.toLocal()),
            Icons.calendar_today_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor ?? const Color(0xFF3C6E71), size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Color(0xFF3C6E71),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16.5,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSadrzajBox() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sadržaj",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color(0xFF3C6E71),
            ),
          ),
          const Divider(height: 20, thickness: 1),
          Text(
            sadrzaj,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 140,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: () => Navigator.pop(context, true),
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 18),
            label: const Text(
              "Nazad",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.grey.shade600;
                }
                return Colors.grey;
              }),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              elevation: MaterialStateProperty.all(4),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 16),
              ),
              shadowColor: MaterialStateProperty.all(Colors.black54),
            ),
          ),
        ),
      ],
    );
  }
}
