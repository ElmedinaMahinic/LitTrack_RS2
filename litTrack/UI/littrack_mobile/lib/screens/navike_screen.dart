import 'package:flutter/material.dart';
import 'package:littrack_mobile/providers/moja_listum_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';

class NavikeScreen extends StatefulWidget {
  const NavikeScreen({super.key});

  @override
  State<NavikeScreen> createState() => _NavikeScreenState();
}

class _NavikeScreenState extends State<NavikeScreen> {
  late MojaListumProvider _provider;
  bool _isLoading = true;

  int _procitaneCount = 0;
  int _neprocitaneCount = 0;
  int _zanroviCount = 0;
  int _autoriCount = 0;

  @override
  void initState() {
    super.initState();
    _provider = context.read<MojaListumProvider>();
    _fetchData();
  }

  Future<void> _fetchData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final procitaneFilter = <String, dynamic>{
        "JeProcitana": true,
        "KorisnikId": AuthProvider.korisnikId,
      };
      final procitane = await _provider.get(filter: procitaneFilter);
      if (!mounted) return;

      final neprocitaneFilter = <String, dynamic>{
        "JeProcitana": false,
        "KorisnikId": AuthProvider.korisnikId,
      };
      final neprocitane = await _provider.get(filter: neprocitaneFilter);
      if (!mounted) return;

      final zanrovi =
          await _provider.getBrojRazlicitihZanrova(AuthProvider.korisnikId!);
      if (!mounted) return;

      final autori =
          await _provider.getBrojRazlicitihAutora(AuthProvider.korisnikId!);
      if (!mounted) return;

      setState(() {
        _procitaneCount = procitane.count;
        _neprocitaneCount = neprocitane.count;
        _zanroviCount = zanrovi;
        _autoriCount = autori;
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
            else ...[
              _buildNavikaCard(
                title: "Broj pročitanih knjiga",
                value: _procitaneCount,
                icon: Icons.sentiment_satisfied,
              ),
              _buildNavikaCard(
                title: "Broj knjiga koje želim pročitati",
                value: _neprocitaneCount,
                icon: Icons.menu_book,
              ),
              _buildNavikaCard(
                title: "Broj istraženih žanrova",
                value: _zanroviCount,
                icon: Icons.category,
              ),
              _buildNavikaCard(
                title: "Broj istraženih autora",
                value: _autoriCount,
                icon: Icons.person_search,
              ),
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
            color: Colors.black.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Moje čitateljske navike",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.bar_chart, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildNavikaCard({
    required String title,
    required int value,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      padding: const EdgeInsets.all(14),
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
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Row(
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3C6E71),

                ),
              ),
              const SizedBox(width: 8),
              Icon(icon, size: 28, color: Colors.black87),
            ],
          ),
        ],
      ),
    );
  }
}

