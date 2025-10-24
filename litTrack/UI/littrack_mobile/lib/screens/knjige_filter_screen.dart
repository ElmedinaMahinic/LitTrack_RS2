import 'package:flutter/material.dart';
import 'package:littrack_mobile/models/knjiga.dart';
import 'package:littrack_mobile/models/autor.dart';
import 'package:littrack_mobile/models/zanr.dart';
import 'package:littrack_mobile/models/ciljna_grupa.dart';
import 'package:littrack_mobile/providers/knjiga_provider.dart';
import 'package:littrack_mobile/providers/ocjena_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class KnjigeFilterScreen extends StatefulWidget {
  final dynamic filterObject;

  const KnjigeFilterScreen({super.key, required this.filterObject});

  @override
  State<KnjigeFilterScreen> createState() => _KnjigeFilterScreenState();
}

class _KnjigeFilterScreenState extends State<KnjigeFilterScreen> {
  late KnjigaProvider _knjigaProvider;
  late OcjenaProvider _ocjenaProvider;

  List<Knjiga> _knjige = [];
  final Map<int, double> _prosjekOcjena = {};
  int _currentPage = 1;
  final int _pageSize = 6;
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _knjigaProvider = context.read<KnjigaProvider>();
    _ocjenaProvider = context.read<OcjenaProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);

    Map<String, dynamic> filter = {};

    if (widget.filterObject is Autor) {
      filter = {'AutorId': widget.filterObject.autorId};
    } else if (widget.filterObject is Zanr) {
      filter = {'ZanrId': widget.filterObject.zanrId};
    } else if (widget.filterObject is CiljnaGrupa) {
      filter = {'CiljnaGrupaId': widget.filterObject.ciljnaGrupaId};
    }

    try {
      final result = await _knjigaProvider.get(
        filter: filter,
        page: _currentPage,
        pageSize: _pageSize,
      );

      setState(() {
        _knjige = result.resultList;
        _totalCount = result.count;
      });

      for (var knjiga in result.resultList) {
        try {
          final prosjek =
              await _ocjenaProvider.getProsjekOcjena(knjiga.knjigaId!);
          setState(() {
            _prosjekOcjena[knjiga.knjigaId!] = prosjek;
          });
        } catch (_) {
          _prosjekOcjena[knjiga.knjigaId!] = 0;
        }
      }
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

  String _getHeaderText() {
    if (widget.filterObject is Autor) {
      final autor = widget.filterObject as Autor;
      return "${autor.ime} ${autor.prezime}";
    } else if (widget.filterObject is Zanr) {
      final zanr = widget.filterObject as Zanr;
      return zanr.naziv;
    } else if (widget.filterObject is CiljnaGrupa) {
      final cg = widget.filterObject as CiljnaGrupa;
      return cg.naziv;
    } else {
      return "Knjige";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        toolbarHeight: kToolbarHeight + 25,
        backgroundColor: const Color(0xFFF6F4F3),
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    Image.asset(
                      "assets/images/logo.png",
                      height: 45,
                      width: 45,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "LitTrack",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 28,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.black,
                    size: 35,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (_knjige.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "Nema knjiga za prikaz.",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
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
      ),
      child: Center(
        child: Text(
          _getHeaderText(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
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
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final knjiga = _knjige[index];
        final prosjek = _prosjekOcjena[knjiga.knjigaId] ?? 0;

        return GestureDetector(
          onTap: () {
            // Navigacija na knjiga_details_screen
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
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
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        knjiga.autorNaziv ?? "",
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${knjiga.cijena} KM",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.pinkAccent,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                prosjek > 0 ? prosjek.toStringAsFixed(1) : "-",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageWidget,
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
