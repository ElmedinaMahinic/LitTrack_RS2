import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:littrack_mobile/providers/recenzija_provider.dart';
import 'package:littrack_mobile/providers/recenzija_odgovor_provider.dart';
import 'package:littrack_mobile/providers/auth_provider.dart';
import 'package:littrack_mobile/providers/utils.dart';
import 'package:provider/provider.dart';
import 'package:littrack_mobile/models/recenzija.dart';
import 'package:littrack_mobile/models/recenzija_odgovor.dart';
import 'package:littrack_mobile/screens/korpa_screen.dart';

class RecenzijeScreen extends StatefulWidget {
  final int knjigaId;
  const RecenzijeScreen({super.key, required this.knjigaId});

  @override
  State<RecenzijeScreen> createState() => _RecenzijeScreenState();
}

class _RecenzijeScreenState extends State<RecenzijeScreen> {
  late RecenzijaProvider _recenzijaProvider;
  late RecenzijaOdgovorProvider _odgovorProvider;

  final Map<int, List<RecenzijaOdgovor>> _odgovori = {};
  final Map<int, int> _odgovorCurrentPage = {};
  final Map<int, int> _odgovorTotalCount = {};
  final Map<int, bool> _isLoadingOdgovori = {};
  final Map<int, bool> _showReplies = {};
  final Map<int, bool> _expandedKomentar = {};

  List<Recenzija> _recenzije = [];
  final int _pageSize = 5;
  bool _isLoadingRecenzije = false;
  int _currentPage = 1;
  int _recenzijeTotalCount = 0;

  final Map<int, bool> _isTogglingRecenzija = {};
  final Map<int, bool> _isTogglingOdgovor = {};

  @override
  void initState() {
    super.initState();
    _recenzijaProvider = context.read<RecenzijaProvider>();
    _odgovorProvider = context.read<RecenzijaOdgovorProvider>();
    _fetchRecenzije();
  }

  Future<void> _fetchRecenzije({int page = 1}) async {
    if (!mounted) return;
    setState(() => _isLoadingRecenzije = true);

    final filter = {
      'KnjigaId': widget.knjigaId,
      'page': page,
      'pageSize': _pageSize,
      'orderBy': 'DatumDodavanja',
      'sortDirection': 'desc',
    };

    try {
      final result = await _recenzijaProvider.get(filter: filter);
      if (!mounted) return;

      setState(() {
        if (page == 1) {
          _recenzije = result.resultList;
        } else {
          _recenzije.addAll(result.resultList);
        }

        _currentPage = page;
        _recenzijeTotalCount = result.count;
      });

      for (final rec in result.resultList) {
        final id = rec.recenzijaId!;
        if (_odgovori.containsKey(id)) continue;

        _fetchOdgovori(id);
      }
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) setState(() => _isLoadingRecenzije = false);
    }
  }

  Future<void> _fetchOdgovori(int recenzijaId, {int page = 1}) async {
    if (_isLoadingOdgovori[recenzijaId] ?? false) return;

    if (!mounted) return;
    setState(() => _isLoadingOdgovori[recenzijaId] = true);
    final filter = <String, dynamic>{
      'page': page,
      'pageSize': _pageSize,
      'RecenzijaId': recenzijaId,
      'orderBy': 'DatumDodavanja',
      'sortDirection': 'desc',
    };
    try {
      final result = await _odgovorProvider.get(filter: filter);
      if (!mounted) return;
      setState(() {
        if (page == 1) {
          _odgovori[recenzijaId] = result.resultList;
        } else {
          _odgovori[recenzijaId]?.addAll(result.resultList);
        }
        _odgovorCurrentPage[recenzijaId] = page;
        _odgovorTotalCount[recenzijaId] = result.count;
      });
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoadingOdgovori[recenzijaId] = false);
      }
    }
  }

  Future<void> _openKomentarDialog({
    bool isOdgovor = false,
    int? recenzijaId,
    int? komentarId,
    String? stariKomentar,
  }) async {
    final formKey = GlobalKey<FormBuilderState>();
    await showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  komentarId == null
                      ? (isOdgovor ? "Dodaj odgovor" : "Dodaj recenziju")
                      : (isOdgovor ? "Uredi odgovor" : "Uredi recenziju"),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF3C6E71),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                FormBuilder(
                  key: formKey,
                  child: FormBuilderTextField(
                    name: 'komentar',
                    initialValue: stariKomentar ?? '',
                    maxLines: 8,
                    style: const TextStyle(fontSize: 16),
                    decoration: InputDecoration(
                      hintText: 'Unesite tekst...',
                      filled: true,
                      fillColor: const Color(0xFFF4F3F2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 14,
                      ),
                    ),
                    validator: FormBuilderValidators.compose([
                      FormBuilderValidators.required(),
                      FormBuilderValidators.maxLength(500),
                    ]),
                  ),
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          foregroundColor: const Color(0xFF3C6E71),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                            side: const BorderSide(color: Color(0xFF3C6E71)),
                          ),
                          textStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        child: const Text("Zatvori"),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState?.saveAndValidate() ??
                              false) {
                            final komentar =
                                formKey.currentState!.value['komentar'];
                            Navigator.pop(context);
                            await _saveKomentar(
                              komentar,
                              isOdgovor: isOdgovor,
                              recenzijaId: recenzijaId,
                              komentarId: komentarId,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3C6E71),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          elevation: 5,
                          shadowColor: Colors.black.withAlpha(51),
                        ),
                        child: const Text(
                          "Sačuvaj",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveKomentar(
    String komentar, {
    bool isOdgovor = false,
    int? recenzijaId,
    int? komentarId,
  }) async {
    if ((isOdgovor && recenzijaId == null) || komentar == '') return;
    try {
      if (komentarId == null) {
        if (isOdgovor) {
          await _odgovorProvider.insert({
            'komentar': komentar,
            'recenzijaId': recenzijaId,
            'korisnikId': AuthProvider.korisnikId,
          });

          if (!mounted) return;
          showCustomSnackBar(
            context: context,
            message: "Odgovor je uspješno dodan.",
            icon: Icons.check_circle,
          );
          await _fetchOdgovori(recenzijaId!);
        } else {
          await _recenzijaProvider.insert({
            'komentar': komentar,
            'knjigaId': widget.knjigaId,
            'korisnikId': AuthProvider.korisnikId,
          });

          if (!mounted) return;
          showCustomSnackBar(
            context: context,
            message: "Recenzija je uspješno dodana.",
            icon: Icons.check_circle,
          );
          await _fetchRecenzije();
        }
      } else {
        if (isOdgovor) {
          await _odgovorProvider.update(komentarId, {'komentar': komentar});

          if (!mounted) return;
          showCustomSnackBar(
            context: context,
            message: "Odgovor je ažuriran.",
            icon: Icons.edit,
          );
          await _fetchOdgovori(recenzijaId!);
        } else {
          await _recenzijaProvider.update(komentarId, {'komentar': komentar});

          if (!mounted) return;
          showCustomSnackBar(
            context: context,
            message: "Recenzija je ažurirana.",
            icon: Icons.edit,
          );
          await _fetchRecenzije();
        }
      }
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    }
  }

  Future<void> _deleteKomentar({
    required bool isOdgovor,
    required int komentarId,
    int? recenzijaId,
  }) async {
    if ((isOdgovor && recenzijaId == null)) return;
    await showConfirmDialog(
      context: context,
      title: "Brisanje",
      message: "Da li sigurno želite obrisati ovaj komentar?",
      icon: Icons.delete,
      iconColor: Colors.red,
      onConfirm: () async {
        try {
          if (isOdgovor) {
            await _odgovorProvider.delete(komentarId);

            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: "Odgovor je obrisan.",
              icon: Icons.delete,
            );
            await _fetchOdgovori(recenzijaId!);
          } else {
            await _recenzijaProvider.delete(komentarId);

            if (!mounted) return;
            showCustomSnackBar(
              context: context,
              message: "Recenzija je obrisana.",
              icon: Icons.delete,
            );
            await _fetchRecenzije();
          }
        } catch (e) {
          if (!mounted) return;
          showCustomDialog(
            context: context,
            title: 'Greška',
            message: e.toString(),
            icon: Icons.error,
            iconColor: Colors.red,
          );
        }
      },
    );
  }

  void _showKomentarMenu(
    BuildContext context,
    Offset position,
    bool isRecenzija,
    int komentarId,
    int? recenzijaId,
    String stariKomentar,
  ) async {
    final selected = await showMenu<String>(
      context: context,
      color: const Color(0xFFF6F4F3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      position: RelativeRect.fromLTRB(position.dx, position.dy, 0, 0),
      items: [
        const PopupMenuItem<String>(
          enabled: false,
          child: Text(
            "Opcije",
            style: TextStyle(
              color: Color(0xFF3C6E71),
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<String>(
          value: "edit",
          child: Text("Uredi", style: TextStyle(color: Color(0xFF3C6E71))),
        ),
        const PopupMenuItem<String>(
          value: "delete",
          child: Text("Obriši", style: TextStyle(color: Color(0xFF3C6E71))),
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
    if (selected == 'edit') {
      await _openKomentarDialog(
        isOdgovor: !isRecenzija,
        recenzijaId: recenzijaId,
        komentarId: komentarId,
        stariKomentar: stariKomentar,
      );
    } else if (selected == 'delete') {
      await _deleteKomentar(
        isOdgovor: !isRecenzija,
        komentarId: komentarId,
        recenzijaId: recenzijaId,
      );
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy. HH:mm').format(date.toLocal());
  }

  Future<void> _toggleLike({
    required bool isOdgovor,
    required int komentarId,
    int? recenzijaId,
  }) async {
    final isLoadingMap = isOdgovor ? _isTogglingOdgovor : _isTogglingRecenzija;

    if (isLoadingMap[komentarId] == true) return;

    setState(() {
      isLoadingMap[komentarId] = true;
    });

    try {
      if (isOdgovor) {
        await _odgovorProvider.toggleLike(
          komentarId,
          AuthProvider.korisnikId!,
        );

        final odgovoriList = _odgovori[recenzijaId!]!;
        final index =
            odgovoriList.indexWhere((o) => o.recenzijaOdgovorId == komentarId);

        if (index != -1) {
          final o = odgovoriList[index];

          if (o.jeLajkovao == true) {
            o.jeLajkovao = false;
            o.brojLajkova--;
          } else {
            o.jeLajkovao = true;
            o.jeDislajkovao = false;
            o.brojLajkova++;
            if (o.brojDislajkova > 0) {
              o.brojDislajkova--;
            }
          }
        }
      } else {
        await _recenzijaProvider.toggleLike(
          komentarId,
          AuthProvider.korisnikId!,
        );

        final index = _recenzije.indexWhere((r) => r.recenzijaId == komentarId);

        if (index != -1) {
          final r = _recenzije[index];

          if (r.jeLajkovao == true) {
            r.jeLajkovao = false;
            r.brojLajkova--;
          } else {
            r.jeLajkovao = true;
            r.jeDislajkovao = false;
            r.brojLajkova++;
            if (r.brojDislajkova > 0) {
              r.brojDislajkova--;
            }
          }
        }
      }

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoadingMap[komentarId] = false;
        });
      }
    }
  }

  Future<void> _toggleDislike({
    required bool isOdgovor,
    required int komentarId,
    int? recenzijaId,
  }) async {
    final isLoadingMap = isOdgovor ? _isTogglingOdgovor : _isTogglingRecenzija;

    if (isLoadingMap[komentarId] == true) return;

    setState(() {
      isLoadingMap[komentarId] = true;
    });

    try {
      if (isOdgovor) {
        await _odgovorProvider.toggleDislike(
          komentarId,
          AuthProvider.korisnikId!,
        );

        final odgovoriList = _odgovori[recenzijaId!]!;
        final index =
            odgovoriList.indexWhere((o) => o.recenzijaOdgovorId == komentarId);

        if (index != -1) {
          final o = odgovoriList[index];

          if (o.jeDislajkovao == true) {
            o.jeDislajkovao = false;
            o.brojDislajkova--;
          } else {
            o.jeDislajkovao = true;
            o.jeLajkovao = false;
            o.brojDislajkova++;
            if (o.brojLajkova > 0) {
              o.brojLajkova--;
            }
          }
        }
      } else {
        await _recenzijaProvider.toggleDislike(
          komentarId,
          AuthProvider.korisnikId!,
        );

        final index = _recenzije.indexWhere((r) => r.recenzijaId == komentarId);

        if (index != -1) {
          final r = _recenzije[index];

          if (r.jeDislajkovao == true) {
            r.jeDislajkovao = false;
            r.brojDislajkova--;
          } else {
            r.jeDislajkovao = true;
            r.jeLajkovao = false;
            r.brojDislajkova++;
            if (r.brojLajkova > 0) {
              r.brojLajkova--;
            }
          }
        }
      }

      if (!mounted) return;
      setState(() {});
    } catch (e) {
      if (!mounted) return;
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoadingMap[komentarId] = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F4F3),
      appBar: AppBar(
        elevation: 0,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: kToolbarHeight + 15,
        backgroundColor: const Color(0xFFF6F4F3),
        title: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(top: 6.0, left: 8, right: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back,
                      color: Colors.black, size: 30),
                  onPressed: () => Navigator.pop(context),
                ),
                Row(
                  children: [
                    Image.asset("assets/images/logo.png",
                        height: 40, width: 40),
                    const SizedBox(width: 8),
                    const Text(
                      "LitTrack",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.shopping_cart,
                      color: Colors.black, size: 30),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const KorpaScreen(),
                      ),
                    );
                  },
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                const SizedBox(height: 24),
                if (_isLoadingRecenzije)
                  const Center(child: CircularProgressIndicator())
                else if (_recenzije.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.mode_comment,
                            color: Color(0xFF3C6E71),
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            "Ova knjiga nema recenzije.",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF3C6E71),
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          _buildButtonDodaj(),
                        ],
                      ),
                    ),
                  )
                else
                  Column(
                    children: [
                      _buildButtonDodaj(),
                      const SizedBox(height: 25),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recenzije.length,
                        itemBuilder: (context, index) {
                          return _buildRecenzijaCard(_recenzije[index]);
                        },
                      ),
                      if (_recenzije.length < _recenzijeTotalCount)
                        TextButton(
                          onPressed: _isLoadingRecenzije
                              ? null
                              : () => _fetchRecenzije(page: _currentPage + 1),
                          child: _isLoadingRecenzije
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                )
                              : const Text("Prikaži više"),
                        ),
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
            "Recenzije",
            style: TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w600,
            ),
          ),
          Icon(Icons.mode_comment, color: Colors.white, size: 28),
        ],
      ),
    );
  }

  Widget _buildButtonDodaj() {
    return SizedBox(
      width: 220,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: () => _openKomentarDialog(isOdgovor: false),
        icon: const Icon(Icons.mode_comment, color: Colors.white),
        label: const Text(
          "Dodaj recenziju",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color(0xFF33585B);
            }
            return const Color(0xFF3C6E71);
          }),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          padding: WidgetStateProperty.all(
            const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildRecenzijaCard(Recenzija rec) {
    final isExpanded = _expandedKomentar[rec.recenzijaId] ?? false;
    final odgovori = _odgovori[rec.recenzijaId] ?? [];
    final imaOdgovora = odgovori.isNotEmpty;
    final isLoadingOdgovori = _isLoadingOdgovori[rec.recenzijaId] ?? false;
    final showMore = rec.komentar.length > 200;
    final isToggling = _isTogglingRecenzija[rec.recenzijaId] == true;
    final isOwn = rec.korisnikId == AuthProvider.korisnikId;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(77),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "${isOwn ? 'Vi' : (rec.korisnickoIme ?? '')} • ${_formatDate(rec.datumDodavanja)}",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isOwn ? FontWeight.w600 : FontWeight.w500,
                        color: const Color(0xFF3C6E71),
                      ),
                    ),
                  ),
                  if (isOwn)
                    GestureDetector(
                      onTapDown: (details) {
                        _showKomentarMenu(
                          context,
                          details.globalPosition,
                          true,
                          rec.recenzijaId!,
                          rec.recenzijaId,
                          rec.komentar,
                        );
                      },
                      child: const Icon(
                        Icons.more_vert,
                        size: 26,
                        color: Color(0xFF3C6E71),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                rec.komentar,
                maxLines: isExpanded ? null : 5,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 16),
              ),
              if (showMore)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _expandedKomentar[rec.recenzijaId!] = !isExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      isExpanded ? "Manje" : "Više",
                      style: const TextStyle(
                        color: Color(0xFF3C6E71),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text("${rec.brojLajkova}"),
                      IconButton(
                        style: ElevatedButton.styleFrom(
                          overlayColor: const Color(0xFF3C6E71).withAlpha(51),
                        ),
                        onPressed: (isToggling || isOwn)
                            ? null
                            : () => _toggleLike(
                                  isOdgovor: false,
                                  komentarId: rec.recenzijaId!,
                                ),
                        icon: Icon(
                          Icons.thumb_up_alt,
                          size: 20,
                          color: rec.jeLajkovao == true
                              ? const Color(0xFF3C6E71)
                              : isOwn
                                  ? Colors.grey.shade600.withAlpha(102)
                                  : Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("${rec.brojDislajkova}"),
                      IconButton(
                        style: ElevatedButton.styleFrom(
                          overlayColor: const Color(0xFF3C6E71).withAlpha(51),
                        ),
                        onPressed: (isToggling || isOwn)
                            ? null
                            : () => _toggleDislike(
                                  isOdgovor: false,
                                  komentarId: rec.recenzijaId!,
                                ),
                        icon: Icon(
                          Icons.thumb_down_alt,
                          size: 20,
                          color: rec.jeDislajkovao == true
                              ? const Color(0xFF3C6E71)
                              : isOwn
                                  ? Colors.grey.shade600.withAlpha(102)
                                  : Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => _openKomentarDialog(
                      isOdgovor: true,
                      recenzijaId: rec.recenzijaId,
                    ),
                    icon: const Icon(
                      Icons.mode_comment,
                      color: Color(0xFF3C6E71),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (imaOdgovora && !isLoadingOdgovori)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: () {
                final noviStatus = !(_showReplies[rec.recenzijaId] ?? false);
                setState(() {
                  _showReplies[rec.recenzijaId!] = noviStatus;
                });
                if (noviStatus && !_odgovori.containsKey(rec.recenzijaId)) {
                  _fetchOdgovori(rec.recenzijaId!);
                }
              },
              icon: Icon(
                _showReplies[rec.recenzijaId] == true
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                color: const Color(0xFF3C6E71),
              ),
              label: Text(
                _showReplies[rec.recenzijaId] == true
                    ? "Sakrij odgovore"
                    : "Prikaži odgovore",
                style: const TextStyle(color: Color(0xFF3C6E71)),
              ),
            ),
          ),
        if (_showReplies[rec.recenzijaId] == true)
          _buildReplies(rec.recenzijaId!),
      ],
    );
  }

  Widget _buildReplies(int recenzijaId) {
    final odgovori = _odgovori[recenzijaId] ?? [];
    final currentPage = _odgovorCurrentPage[recenzijaId] ?? 1;
    final totalCount = _odgovorTotalCount[recenzijaId] ?? 0;
    final isLoading = _isLoadingOdgovori[recenzijaId] ?? false;

    return Column(
      children: [
        if (odgovori.isNotEmpty)
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: odgovori.length,
            itemBuilder: (context, index) {
              final odgovor = odgovori[index];
              final isExpanded =
                  _expandedKomentar[odgovor.recenzijaOdgovorId] ?? false;
              final showMore = odgovor.komentar.length > 160;
              final isToggling =
                  _isTogglingOdgovor[odgovor.recenzijaOdgovorId] == true;
              final isOwn = odgovor.korisnikId == AuthProvider.korisnikId;

              return Container(
                margin: const EdgeInsets.only(left: 28, top: 8, bottom: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(77),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "${isOwn ? 'Vi' : (odgovor.korisnickoIme ?? '')} • ${_formatDate(odgovor.datumDodavanja)}",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight:
                                  isOwn ? FontWeight.w600 : FontWeight.w500,
                              color: const Color(0xFF3C6E71),
                            ),
                          ),
                        ),
                        if (isOwn)
                          GestureDetector(
                            onTapDown: (details) {
                              _showKomentarMenu(
                                context,
                                details.globalPosition,
                                false,
                                odgovor.recenzijaOdgovorId!,
                                recenzijaId,
                                odgovor.komentar,
                              );
                            },
                            child: const Icon(
                              Icons.more_vert,
                              size: 22,
                              color: Color(0xFF3C6E71),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      odgovor.komentar,
                      maxLines: isExpanded ? null : 5,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15),
                    ),
                    if (showMore)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandedKomentar[odgovor.recenzijaOdgovorId!] =
                                !isExpanded;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            isExpanded ? "Manje" : "Više",
                            style: const TextStyle(
                              color: Color(0xFF3C6E71),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Text(
                          "${odgovor.brojLajkova}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                            overlayColor: const Color(0xFF3C6E71).withAlpha(51),
                          ),
                          onPressed: (isToggling || isOwn)
                              ? null
                              : () => _toggleLike(
                                    isOdgovor: true,
                                    komentarId: odgovor.recenzijaOdgovorId!,
                                    recenzijaId: recenzijaId,
                                  ),
                          icon: Icon(
                            Icons.thumb_up_alt,
                            size: 20,
                            color: odgovor.jeLajkovao == true
                                ? const Color(0xFF3C6E71)
                                : isOwn
                                    ? Colors.grey.shade600.withAlpha(102)
                                    : Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "${odgovor.brojDislajkova}",
                          style: const TextStyle(fontSize: 14),
                        ),
                        IconButton(
                          style: ElevatedButton.styleFrom(
                            overlayColor: const Color(0xFF3C6E71).withAlpha(51),
                          ),
                          onPressed: (isToggling || isOwn)
                              ? null
                              : () => _toggleDislike(
                                    isOdgovor: true,
                                    komentarId: odgovor.recenzijaOdgovorId!,
                                    recenzijaId: recenzijaId,
                                  ),
                          icon: Icon(
                            Icons.thumb_down_alt,
                            size: 20,
                            color: odgovor.jeDislajkovao == true
                                ? const Color(0xFF3C6E71)
                                : isOwn
                                    ? Colors.grey.shade600.withAlpha(102)
                                    : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        if (odgovori.length < totalCount)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: isLoading
                  ? null
                  : () {
                      _fetchOdgovori(
                        recenzijaId,
                        page: currentPage + 1,
                      );
                    },
              child: isLoading
                  ? const SizedBox(
                      height: 16,
                      width: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text("Prikaži više"),
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}
