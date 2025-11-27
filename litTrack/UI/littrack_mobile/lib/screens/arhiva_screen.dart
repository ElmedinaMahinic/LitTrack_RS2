import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littrack_mobile/models/arhiva.dart';
import 'package:littrack_mobile/providers/arhiva_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/knjiga_provider.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/screens/knjiga_details_screen.dart';

class ArhivaScreen extends StatefulWidget {
  const ArhivaScreen({super.key});

  @override
  State<ArhivaScreen> createState() => _ArhivaScreenState();
}

class _ArhivaScreenState extends State<ArhivaScreen> {
  late ArhivaProvider _provider;
  late KnjigaProvider _knjigaProvider;
  List<Arhiva> _knjige = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  int _totalCount = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _provider = context.read<ArhivaProvider>();
    _knjigaProvider = context.read<KnjigaProvider>();
    _fetchData();
  }

  Future<void> _fetchData({int page = 1}) async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    final filter = <String, dynamic>{
      'page': page,
      'pageSize': _pageSize,
      'KorisnikId': AuthProvider.korisnikId,
    };

    try {
      final result = await _provider.get(filter: filter);
      if (!mounted) return;
      setState(() {
        _knjige = result.resultList;
        _totalCount = result.count;
        _currentPage = page;
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

  Future<void> _deleteFromArchive(Arhiva knjiga) async {
    try {
      await _provider.delete(knjiga.arhivaId!);

      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Uspješno",
        message: "Knjiga je uklonjena iz arhive.",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );

      if (!mounted) return;
      _fetchData(page: _currentPage);
    } catch (e) {
      if (!mounted) return;
      await showCustomDialog(
        context: context,
        title: "Greška",
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
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
                fontSize: 16,
                color: Color(0xFF3C6E71),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 21),
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
                        "Nema arhiviranih knjiga.",
                        style:
                            TextStyle(fontSize: 16, color: Color(0xFF3C6E71)),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              )
            else ...[
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _knjige.length,
                itemBuilder: (context, index) {
                  return _buildKnjigaCard(_knjige[index]);
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
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

  Widget _buildKnjigaCard(Arhiva knjiga) {
    return Slidable(
      key: ValueKey(knjiga.arhivaId),
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            backgroundColor: Colors.black,
            icon: Icons.delete,
            label: "Obriši",
            onPressed: (_) async {
              showConfirmDialog(
                context: context,
                title: "Brisanje knjige",
                message:
                    "Da li ste sigurni da želite ukloniti knjigu iz arhive?",
                icon: Icons.delete,
                iconColor: Colors.red,
                onConfirm: () => _deleteFromArchive(knjiga),
              );
            },
          ),
        ],
      ),
      child: GestureDetector(
        onTap: () async {
          try {
            final knjigaDetalji =
                await _knjigaProvider.getById(knjiga.knjigaId);

            if (!mounted) return;

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    KnjigaDetailsScreen(knjiga: knjigaDetalji),
              ),
            );

            if (!mounted) return;

            if (result == true) {
              _fetchData(page: _currentPage);
            }
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
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          padding: const EdgeInsets.all(10),
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
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String? slikaBase64) {
    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return Image.asset(
        "assets/images/placeholder.png",
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      );
    }

    try {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          width: 60,
          height: 60,
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
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.3),
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
                ? () => _fetchData(page: _currentPage + 1)
                : null,
            style: ElevatedButton.styleFrom(
              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.3),
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
