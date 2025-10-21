import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/zanr.dart';
import 'package:littrack_mobile/providers/zanr_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/screens/knjige_filter_screen.dart';

class ZanroviScreen extends StatefulWidget {
  const ZanroviScreen({super.key});

  @override
  State<ZanroviScreen> createState() => _ZanroviScreenState();
}

class _ZanroviScreenState extends State<ZanroviScreen> {
  late ZanrProvider _provider;
  List<Zanr> _zanrovi = [];
  int _currentPage = 1;
  final int _pageSize = 5;
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _provider = context.read<ZanrProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final filter = <String, dynamic>{
        'page': _currentPage,
        'pageSize': _pageSize,
        'orderBy': 'Naziv',
        'sortDirection': 'asc',
      };

      final result = await _provider.get(filter: filter);
      setState(() {
        _zanrovi = result.resultList;
        _totalCount = result.count;
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
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_zanrovi.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Nema dostupnih žanrova.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
              )
            else
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _zanrovi.length,
                    itemBuilder: (context, index) {
                      return _buildZanrCard(_zanrovi[index], index);
                    },
                  ),
                  if (_totalCount > _pageSize) _buildPaging(),
                ],
              ),
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
            "Pretraži žanrove",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.library_books, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildZanrCard(Zanr zanr, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KnjigeFilterScreen(filterObject: zanr),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                zanr.naziv,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _buildImage(zanr.slika),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String? slikaBase64) {
    const double imageSize = 50;

    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          "assets/images/placeholder.png",
          width: imageSize,
          height: imageSize,
          fit: BoxFit.cover,
        ),
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: imageSize,
          height: imageSize,
          child: imageFromString(slikaBase64),
        ),
      );
    } catch (_) {
      return const Icon(Icons.broken_image, size: imageSize);
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
                ? () {
                    setState(() {
                      _currentPage--;
                    });
                    _fetchData();
                  }
                : null,
            child: const Text("Prethodna"),
          ),
          const SizedBox(width: 20),
          Text("Stranica $_currentPage / $totalPages"),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() {
                      _currentPage++;
                    });
                    _fetchData();
                  }
                : null,
            child: const Text("Sljedeća"),
          ),
        ],
      ),
    );
  }
}
