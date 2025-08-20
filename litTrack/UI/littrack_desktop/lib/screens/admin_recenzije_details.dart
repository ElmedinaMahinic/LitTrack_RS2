import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_desktop/models/recenzija.dart';
import 'package:littrack_desktop/models/recenzija_odgovor.dart';
import 'package:littrack_desktop/providers/recenzija_provider.dart';
import 'package:littrack_desktop/providers/recenzija_odgovor_provider.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/providers/utils.dart';

class AdminRecenzijeDetailsScreen extends StatefulWidget {
  final Recenzija? recenzija;
  final RecenzijaOdgovor? odgovor;

  const AdminRecenzijeDetailsScreen({
    super.key,
    this.recenzija,
    this.odgovor,
  });

  @override
  State<AdminRecenzijeDetailsScreen> createState() =>
      _AdminRecenzijeDetailsScreenState();
}

class _AdminRecenzijeDetailsScreenState
    extends State<AdminRecenzijeDetailsScreen> {
  late final bool isRecenzija;
  late final String korisnickoIme;
  late final DateTime datum;
  late final int brojLajkova;
  late final int brojDislajkova;
  late final String komentar;

  @override
  void initState() {
    super.initState();
    isRecenzija = widget.recenzija != null;

    if (isRecenzija) {
      final recenzija = widget.recenzija!;
      korisnickoIme = recenzija.korisnickoIme ?? "/";
      datum = recenzija.datumDodavanja;
      brojLajkova = recenzija.brojLajkova;
      brojDislajkova = recenzija.brojDislajkova;
      komentar = recenzija.komentar;
    } else {
      final odgovor = widget.odgovor!;
      korisnickoIme = odgovor.korisnickoIme ?? "/";
      datum = odgovor.datumDodavanja;
      brojLajkova = odgovor.brojLajkova;
      brojDislajkova = odgovor.brojDislajkova;
      komentar = odgovor.komentar;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: isRecenzija ? "Detalji recenzije" : "Detalji odgovora",
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 20),
            _buildKomentarBox(),
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
          _buildInfoRow(
              "Korisničko ime:", korisnickoIme, Icons.account_circle_outlined),
          _buildInfoRow(
              "Datum dodavanja:",
              DateFormat('dd.MM.yyyy. HH:mm').format(datum.toLocal()),
              Icons.calendar_today_outlined),
          _buildInfoRow("Broj lajkova:", brojLajkova.toString(),
              Icons.thumb_up_alt_outlined),
          _buildInfoRow("Broj dislajkova:", brojDislajkova.toString(),
              Icons.thumb_down_alt_outlined),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon,
      {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                color: Color(0xFF3C6E71),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKomentarBox() {
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
            "Komentar:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Color(0xFF3C6E71),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            komentar,
            style: const TextStyle(fontSize: 16),
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
            onPressed: () => Navigator.pop(context),
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
        const SizedBox(width: 20),
        SizedBox(
          width: 140,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: _delete,
            icon:
                const Icon(Icons.delete_outline, color: Colors.white, size: 20),
            label: const Text(
              "Obriši",
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
                  return const Color(0xFF51968F);
                }
                return const Color(0xFF3C6E71);
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

  Future<void> _delete() async {
    await showConfirmDialog(
      context: context,
      title: "Brisanje",
      message:
          "Da li želite obrisati ${isRecenzija ? "recenziju" : "odgovor"} zbog neprimjerenog sadržaja?",
      icon: Icons.warning,
      iconColor: Colors.red,
      onConfirm: () async {
        try {
          if (isRecenzija) {
            final provider = RecenzijaProvider();
            await provider.delete(widget.recenzija!.recenzijaId!);
          } else {
            final provider = RecenzijaOdgovorProvider();
            await provider.delete(widget.odgovor!.recenzijaOdgovorId!);
          }

          await showCustomDialog(
            context: context,
            title: "Uspjeh",
            message:
                "${isRecenzija ? "Recenzija" : "Odgovor"} je uspješno obrisan.",
            icon: Icons.check_circle,
            iconColor: Colors.green,
          );

          Navigator.pop(context, true);
        } catch (e) {
          await showCustomDialog(
            context: context,
            title: "Greška",
            message: e.toString(),
            icon: Icons.error,
            iconColor: Colors.red,
          );
        }
      },
    );
  }
}
