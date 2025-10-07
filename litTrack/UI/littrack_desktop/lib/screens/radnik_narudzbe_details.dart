import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:littrack_desktop/models/narudzba.dart';
import 'package:littrack_desktop/models/stavka_narudzbe.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:littrack_desktop/providers/narudzba_provider.dart';
import 'package:littrack_desktop/providers/stavka_narudzbe_provider.dart';
import 'package:provider/provider.dart';

class RadnikNarudzbeDetailsScreen extends StatefulWidget {
  final Narudzba narudzba;

  const RadnikNarudzbeDetailsScreen({
    super.key,
    required this.narudzba,
  });

  @override
  State<RadnikNarudzbeDetailsScreen> createState() =>
      _RadnikNarudzbeDetailsScreenState();
}

class _RadnikNarudzbeDetailsScreenState
    extends State<RadnikNarudzbeDetailsScreen> {
  late final String sifra;
  late final DateTime datumNarudzbe;
  late final double ukupnaCijena;
  late final String status;
  late final String imePrezime;
  late final String nacinPlacanja;
  late final int brojStavki;
  late final int ukupanBrojKnjiga;

  late StavkaNarudzbeProvider _stavkaProvider;

  bool showStavke = false;
  bool isLoadingStavke = false;
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

    _stavkaProvider = context.read<StavkaNarudzbeProvider>();
  }

  Future<void> loadStavke() async {
    setState(() {
      isLoadingStavke = true;
    });

    try {
      final result = await _stavkaProvider.get(filter: {
        "NarudzbaId": widget.narudzba.narudzbaId,
      });

      setState(() {
        stavke = result.resultList;
        isLoadingStavke = false;
      });
    } catch (e) {
      setState(() {
        isLoadingStavke = false;
      });
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
      title: "Detalji narudžbe",
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoSection(),
            const SizedBox(height: 20),
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
    );
  }

  Widget _buildStavkeToggleButton() {
    return SizedBox(
      width: 280,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: () async {
          if (!showStavke) {
            await loadStavke();
          }
          setState(() {
            showStavke = !showStavke;
          });
        },
        icon: Icon(
          showStavke ? Icons.hide_source : Icons.shopping_basket,
          color: Colors.white,
          size: 18,
        ),
        label: Text(
          showStavke ? "Sakrij stavke narudžbe" : "Prikaži stavke narudžbe",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
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
    );
  }

  Widget _buildStavkeSection() {
    if (isLoadingStavke) {
      return const Center(child: CircularProgressIndicator());
    }
    if (stavke.isEmpty) {
      return const Text("Nema stavki za ovu narudžbu.");
    }

    return Column(
      children: stavke.asMap().entries.map((entry) {
        int index = entry.key;
        StavkaNarudzbe stavka = entry.value;

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
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Naslov stavke
              Text(
                "Stavka ${index + 1}",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C6E71),
                ),
              ),
              const Divider(height: 20, thickness: 1),
              _buildInfoRow(
                  "Naziv knjige:", stavka.nazivKnjige ?? "-", Icons.book),
              _buildInfoRow("Cijena:", "${stavka.cijena.toStringAsFixed(2)} KM",
                  Icons.attach_money),
              _buildInfoRow("Količina:", stavka.kolicina.toString(),
                  Icons.format_list_numbered),
            ],
          ),
        );
      }).toList(),
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
          _buildInfoRow("Šifra:", sifra, Icons.confirmation_number_outlined),
          _buildInfoRow(
              "Datum kreiranja:",
              DateFormat('dd.MM.yyyy. HH:mm').format(datumNarudzbe.toLocal()),
              Icons.calendar_today_outlined),
          _buildInfoRow("Ukupna cijena:",
              "${ukupnaCijena.toStringAsFixed(2)} KM", Icons.attach_money),
          _buildInfoRow("Status:", status, Icons.info_outline),
          _buildInfoRow("Naručilac:", imePrezime, Icons.person_outline),
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
            width: 200,
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

  Widget _buildActionButtons() {
    final NarudzbaProvider provider = NarudzbaProvider();

    String getButtonText() {
      switch (status.toLowerCase()) {
        case "kreirana":
          return "Preuzmi narudžbu";
        case "preuzeta":
          return "Pošalji narudžbu";
        case "utoku":
          return "Završi narudžbu";
        case "ponistena":
          return "Narudžba otkazana";
        case "zavrsena":
          return "Narudžba završena";
        default:
          return "Nema aktivnosti";
      }
    }

    bool isButtonEnabled() {
      return ["kreirana", "preuzeta", "utoku"].contains(status.toLowerCase());
    }

    Future<void> onStatusButtonPressed() async {
      String actionText = getButtonText();
      Future<void> Function()? action;

      switch (status.toLowerCase()) {
        case "kreirana":
          action = () => provider.preuzmi(widget.narudzba.narudzbaId!);
          break;
        case "preuzeta":
          action = () => provider.uToku(widget.narudzba.narudzbaId!);
          break;
        case "utoku":
          action = () => provider.zavrsi(widget.narudzba.narudzbaId!);
          break;
        default:
          return;
      }

      await showConfirmDialog(
        context: context,
        title: "Potvrda",
        message: "Da li ste sigurni da želite izvršiti akciju: $actionText?",
        icon: Icons.help_outline,
        iconColor: Colors.red,
        onConfirm: () async {
          try {
            await action!();
            await showCustomDialog(
              context: context,
              title: "Uspjeh",
              message: "Akcija '$actionText' je uspješno izvršena.",
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
          width: 200,
          height: 45,
          child: ElevatedButton.icon(
            onPressed: isButtonEnabled() ? onStatusButtonPressed : null,
            icon: const Icon(Icons.update, color: Colors.white, size: 18),
            label: Text(
              getButtonText(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (!isButtonEnabled()) return Colors.grey.shade400;
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
}
