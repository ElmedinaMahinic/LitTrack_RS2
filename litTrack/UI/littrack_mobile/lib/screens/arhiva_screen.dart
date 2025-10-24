import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/arhiva.dart';
import 'package:littrack_mobile/providers/arhiva_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ArhivaScreen extends StatefulWidget {
  const ArhivaScreen({super.key});

  @override
  State<ArhivaScreen> createState() => _ArhivaScreenState();
}

class _ArhivaScreenState extends State<ArhivaScreen> {
  late ArhivaProvider _provider;
  List<Arhiva> _knjige = [];
  int _currentPage = 1;
  final int _pageSize = 6;
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _provider = context.read<ArhivaProvider>();
    _fetchData();
  }

  Future<void> _fetchData({int page = 1}) async {
    setState(() => _isLoading = true);

    final filter = <String, dynamic>{
      'page': page,
      'pageSize': _pageSize,
      'KorisnikId': AuthProvider.korisnikId,
    };

    try {
      final result = await _provider.get(filter: filter);
      setState(() {
        _knjige = result.resultList;
        _totalCount = result.count;
        _currentPage = page;
      });
    } catch (e) {
      showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
      );
    } finally {
      setState(() => _isLoading = false);
    }
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
            const SizedBox(height: 15),
            const Text(
              "Arhiviraj knjigu i imaj svoje favorite na jednom mjestu!",
              style: TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_knjige.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "Niste arhivirali nijednu knjigu.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
              )
            else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _knjige.length,
                itemBuilder: (context, index) {
                  return _buildKnjigaCard(_knjige[index], index);
                },
              ),
              if (_totalCount > _pageSize) _buildPaging(),
            ],
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
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Moja arhiva",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.archive, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildKnjigaCard(Arhiva knjiga, int index) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigacija na detalje knjige
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.all(10),
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
        child: Row(
          children: [
            _buildImage(knjiga.slika),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    knjiga.nazivKnjige ?? "-",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    knjiga.autorNaziv ?? "-",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? slikaBase64) {
    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return Image.asset(
        "assets/images/placeholder.png",
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 50,
          height: 50,
          child: imageFromString(slikaBase64),
        ),
      );
    } catch (_) {
      return const Icon(Icons.broken_image, size: 50);
    }
  }

  Widget _buildPaging() {
    int totalPages = (_totalCount / _pageSize).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: _currentPage > 1
                ? () => _fetchData(page: _currentPage - 1)
                : null,
            child: const Text("Prethodna"),
          ),
          const SizedBox(width: 20),
          Text("Stranica $_currentPage / $totalPages"),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: _currentPage < totalPages
                ? () => _fetchData(page: _currentPage + 1)
                : null,
            child: const Text("Sljedeća"),
          ),
        ],
      ),
    );
  }
}
