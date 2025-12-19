import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/models/knjiga.dart';
import 'package:littrack_mobile/providers/knjiga_provider.dart';
import 'package:littrack_mobile/providers/ocjena_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/screens/knjiga_details_screen.dart';

class HomepageScreen extends StatefulWidget {
  const HomepageScreen({super.key});

  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  late KnjigaProvider _knjigaProvider;
  late OcjenaProvider _ocjenaProvider;
  final TextEditingController _searchController = TextEditingController();

  List<Knjiga> _knjige = [];
  final Map<int, double> _prosjekOcjena = {};
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalCount = 0;
  bool _isLoading = true;

  String? _orderBy;
  String _sortDirection = 'asc';

  @override
  void initState() {
    super.initState();
    _knjigaProvider = context.read<KnjigaProvider>();
    _ocjenaProvider = context.read<OcjenaProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final filter = {
      'Naziv': _searchController.text,
      if (_orderBy != null) ...{
        'orderBy': _orderBy,
        'sortDirection': _sortDirection,
      },
    };

    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final result = await _knjigaProvider.get(
        filter: filter,
        page: _currentPage,
        pageSize: _pageSize,
      );
      if (!mounted) return;

      setState(() {
        _knjige = result.resultList;
        _totalCount = result.count;
      });

      for (var knjiga in result.resultList) {
        try {
          final prosjek =
              await _ocjenaProvider.getProsjekOcjena(knjiga.knjigaId!);
          if (!mounted) return;
          setState(() {
            _prosjekOcjena[knjiga.knjigaId!] = prosjek;
          });
        } catch (e) {
          _prosjekOcjena[knjiga.knjigaId!] = 0;
        }
      }
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

  void _clearSearch() {
    _searchController.clear();
    _currentPage = 1;
    _orderBy = null;
    _sortDirection = 'asc';
    _fetchData();
  }

  void _showSortMenu(BuildContext context, Offset offset) async {
    final selected = await showMenu<String>(
      context: context,
      color: const Color.fromARGB(255, 226, 236, 231),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      position: RelativeRect.fromLTRB(offset.dx, offset.dy, 0, 0),
      items: [
        const PopupMenuItem<String>(
          enabled: false,
          child: Text(
            "Sortiranje",
            style: TextStyle(
              color: Color(0xFF3C6E71),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: "abecedno",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Abecedno", style: TextStyle(color: Color(0xFF3C6E71))),
              Icon(Icons.sort_by_alpha, size: 15, color: Color(0xFF3C6E71)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: "cijena_asc",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cijena (najniža)",
                  style: TextStyle(color: Color(0xFF3C6E71))),
              Icon(Icons.arrow_downward, size: 15, color: Color(0xFF3C6E71)),
            ],
          ),
        ),
        const PopupMenuItem<String>(
          value: "cijena_desc",
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Cijena (najviša)",
                  style: TextStyle(color: Color(0xFF3C6E71))),
              Icon(Icons.arrow_upward, size: 15, color: Color(0xFF3C6E71)),
            ],
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: "zatvori",
          child: Center(
            child: Text(
              "Zatvori",
              style: TextStyle(
                color: Color(0xFF3C6E71),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
      elevation: 8,
    );

    if (selected == null || selected == "zatvori") return;

    setState(() {
      switch (selected) {
        case "abecedno":
          _orderBy = "Naziv";
          _sortDirection = "asc";
          break;
        case "cijena_asc":
          _orderBy = "Cijena";
          _sortDirection = "asc";
          break;
        case "cijena_desc":
          _orderBy = "Cijena";
          _sortDirection = "desc";
          break;
      }
    });

    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 17),
            _buildSearchBox(),
            const SizedBox(height: 22),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_knjige.isEmpty)
              const Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_outlined,
                      color: Color(0xFF3C6E71),
                      size: 50,
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        "Nema knjiga za prikaz.",
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
                  _buildGrid(),
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
      padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF3C6E71),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          "Pronađi novu knjigu za čitanje",
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

  Widget _buildSearchBox() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Pretraži po nazivu...",
              hintStyle: const TextStyle(color: Colors.grey),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear, color: Colors.grey),
                onPressed: _clearSearch,
              ),
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.2),
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.grey, width: 1.5),
                borderRadius: BorderRadius.circular(16),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            ),
            style: const TextStyle(color: Colors.grey),
            onChanged: (value) {
              _currentPage = 1;
              _fetchData();
            },
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTapDown: (details) =>
              _showSortMenu(context, details.globalPosition),
          child: const Icon(Icons.filter_list, color: Colors.grey, size: 28),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _knjige.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.84,
      ),
      itemBuilder: (context, index) {
        final knjiga = _knjige[index];
        final prosjek = _prosjekOcjena[knjiga.knjigaId] ?? 0;

        return GestureDetector(
          onTap: () async {
            try {
              final knjigaDetalji =
                  await _knjigaProvider.getById(knjiga.knjigaId!);

              if (!mounted) return;

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      KnjigaDetailsScreen(knjiga: knjigaDetalji),
                ),
              );
              if (!mounted) return;

              if (result == true) _fetchData();
            } catch (e) {
              if (!mounted) return;
              showCustomDialog(
                context: context,
                title: "Greška",
                message: e.toString(),
                icon: Icons.error,
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(knjiga.slika),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        knjiga.naziv,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        knjiga.autorNaziv ?? "",
                        style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.black54),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${knjiga.cijena} KM",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star,
                                  color: Color(0xFFD55B91), size: 18),
                              const SizedBox(width: 4),
                              Text(
                                prosjek > 0 ? prosjek.toStringAsFixed(1) : "-",
                                style: const TextStyle(
                                    fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildImage(String? slikaBase64) {
    Widget imageWidget;

    if (slikaBase64 == null || slikaBase64.isEmpty) {
      imageWidget = Image.asset(
        "assets/images/placeholder.png",
        height: 120,
        width: 108,
        fit: BoxFit.cover,
      );
    } else {
      try {
        imageWidget = SizedBox(
          height: 120,
          width: 108,
          child: imageFromString(slikaBase64),
        );
      } catch (_) {
        imageWidget = const Icon(Icons.broken_image, size: 100);
      }
    }

    return Center(
      child:
          ClipRRect(borderRadius: BorderRadius.circular(8), child: imageWidget),
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
                    setState(() => _currentPage--);
                    _fetchData();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Prethodna"),
          ),
          const SizedBox(width: 20),
          Text("Stranica $_currentPage / $totalPages"),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: _currentPage < totalPages
                ? () {
                    setState(() => _currentPage++);
                    _fetchData();
                  }
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.3),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text("Sljedeća"),
          ),
        ],
      ),
    );
  }
}
