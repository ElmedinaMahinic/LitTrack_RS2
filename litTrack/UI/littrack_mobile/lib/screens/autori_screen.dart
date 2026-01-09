import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/autor.dart';
import 'package:littrack_mobile/providers/autor_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/screens/knjige_filter_screen.dart';

class AutoriScreen extends StatefulWidget {
  const AutoriScreen({super.key});

  @override
  State<AutoriScreen> createState() => _AutoriScreenState();
}

class _AutoriScreenState extends State<AutoriScreen> {
  late AutorProvider _provider;
  List<Autor> _autori = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _provider = context.read<AutorProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    try {
      final filter = <String, dynamic>{
        'page': _currentPage,
        'pageSize': _pageSize,
        'orderBy': 'Ime',
        'sortDirection': 'asc',
      };

      final result = await _provider.get(filter: filter);
      if (!mounted) return;
      setState(() {
        _autori = result.resultList;
        _totalCount = result.count;
      });
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
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
            else if (_autori.isEmpty)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.person_outline,
                      color: Color(0xFF3C6E71),
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Nema dostupnih autora.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF3C6E71),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _autori.length,
                    itemBuilder: (context, index) {
                      return _buildAutorCard(_autori[index], index);
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(51),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Pretraži autore",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.person, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildAutorCard(Autor autor, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KnjigeFilterScreen(filterObject: autor),
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
              color: Colors.black.withAlpha(51),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                "${autor.ime} ${autor.prezime}".trim(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.person_outline,
                color: Color(0xFF3C6E71),
                size: 26,
              ),
            ),
          ],
        ),
      ),
    );
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
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withAlpha(77),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withAlpha(77),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text("Sljedeća"),
          ),
        ],
      ),
    );
  }
}
