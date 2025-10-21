import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/ciljna_grupa.dart';
import 'package:littrack_mobile/providers/ciljna_grupa_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/screens/knjige_filter_screen.dart';

class CiljneGrupeScreen extends StatefulWidget {
  const CiljneGrupeScreen({super.key});

  @override
  State<CiljneGrupeScreen> createState() => _CiljneGrupeScreenState();
}

class _CiljneGrupeScreenState extends State<CiljneGrupeScreen> {
  late CiljnaGrupaProvider _provider;
  List<CiljnaGrupa> _ciljneGrupe = [];
  int _currentPage = 1;
  final int _pageSize = 5;
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _provider = context.read<CiljnaGrupaProvider>();
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
        _ciljneGrupe = result.resultList;
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
            else if (_ciljneGrupe.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  "Nema dostupnih ciljnih grupa.",
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
                    itemCount: _ciljneGrupe.length,
                    itemBuilder: (context, index) {
                      return _buildCiljnaGrupaCard(_ciljneGrupe[index], index);
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
            "Pretraži ciljne grupe",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.groups, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildCiljnaGrupaCard(CiljnaGrupa ciljnaGrupa, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => KnjigeFilterScreen(filterObject: ciljnaGrupa),
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
                ciljnaGrupa.naziv,
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
                Icons.group_outlined,
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
