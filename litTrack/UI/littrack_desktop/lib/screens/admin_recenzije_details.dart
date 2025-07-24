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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow("Korisničko ime:", korisnickoIme),
        _buildInfoRow("Datum dodavanja:",
            DateFormat('dd.MM.yyyy. HH:mm').format(datum.toLocal())),
        _buildInfoRow("Broj lajkova:", brojLajkova.toString()),
        _buildInfoRow("Broj dislajkova:", brojDislajkova.toString()),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16,),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16),)),
        ],
      ),
    );
  }

  Widget _buildKomentarBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Komentar:",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(komentar),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 120,
          height: 45,
          child: ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Nazad",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 20),
        SizedBox(
          width: 120,
          height: 45,
          child: ElevatedButton(
            onPressed: _delete,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C6E71),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              "Obriši",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
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
