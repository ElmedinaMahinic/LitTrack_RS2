import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/knjiga.dart';
import 'package:littrack_mobile/providers/utils.dart';

class KnjigaDetailsScreen extends StatefulWidget {
  final Knjiga knjiga;

  const KnjigaDetailsScreen({super.key, required this.knjiga});

  @override
  State<KnjigaDetailsScreen> createState() => _KnjigaDetailsScreenState();
}

class _KnjigaDetailsScreenState extends State<KnjigaDetailsScreen> {
  late String naziv;
  late String autor;
  late String opis;
  late int godina;
  late List<String> ciljneGrupe;
  late List<String> zanrovi;
  String? slika;

  @override
  void initState() {
    super.initState();

    naziv = widget.knjiga.naziv;
    autor = widget.knjiga.autorNaziv ?? "/";
    opis = widget.knjiga.opis;
    godina = widget.knjiga.godinaIzdavanja;
    ciljneGrupe = widget.knjiga.ciljneGrupe;
    zanrovi = widget.knjiga.zanrovi;
    slika = widget.knjiga.slika;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF6F4F3),
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight + 25,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, size: 35, color: Colors.black),
              onPressed: () => Navigator.pop(context, true),
            ),
            Row(
              children: [
                Image.asset("assets/images/logo.png", height: 45, width: 45),
                const SizedBox(width: 8),
                const Text(
                  "LitTrack",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 28),
                ),
              ],
            ),
            const Icon(Icons.menu_book, size: 35, color: Colors.black),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeaderInfo(),
                const SizedBox(height: 16),
                _buildTags(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImage(slika),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(naziv,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text(autor,
                  style: const TextStyle(fontSize: 15, color: Colors.black87)),
              Text("$godina.",
                  style: const TextStyle(fontSize: 13, color: Colors.black54)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: ciljneGrupe
              .map(
                (g) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(g),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 8),
        Text(zanrovi.join(", "), style: const TextStyle(fontSize: 14)),
        const SizedBox(height: 8),
        Text(opis, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildImage(String? slikaBase64) {
    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/images/placeholder.png",
          height: 140,
          width: 120,
          fit: BoxFit.cover,
        ),
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 140,
          width: 120,
          child: imageFromString(slikaBase64),
        ),
      );
    } catch (_) {
      return const Icon(Icons.broken_image, size: 100);
    }
  }
}
