import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/knjiga.dart';
import 'package:littrack_desktop/providers/knjiga_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:provider/provider.dart';
import 'package:littrack_desktop/screens/admin_knjige_details.dart';

class AdminKnjigeScreen extends StatefulWidget {
  const AdminKnjigeScreen({super.key});

  @override
  State<AdminKnjigeScreen> createState() => _AdminKnjigeScreenState();
}

class _AdminKnjigeScreenState extends State<AdminKnjigeScreen> {
  final TextEditingController _nazivController = TextEditingController();
  final TextEditingController _autorNazivController = TextEditingController();
  late KnjigaProvider _provider;
  late KnjigaDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _provider = context.read<KnjigaProvider>();
    _dataSource = KnjigaDataSource(provider: _provider, context: context);
    _dataSource.filterServerSide('', '');
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Knjige",
      child: Column(
        children: [
          _buildSearchSection(),
          const SizedBox(height: 15),
          _buildTable(),
        ],
      ),
    );
  }

  Widget _buildSearchSection() {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _nazivController,
              decoration: InputDecoration(
                labelText: 'Naziv knjige',
                hintText: 'Unesite naziv knjige',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              onChanged: (value) {
                _dataSource.filterServerSide(
                  _nazivController.text,
                  _autorNazivController.text,
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            flex: 3,
            child: TextField(
              controller: _autorNazivController,
              decoration: InputDecoration(
                labelText: 'Autor',
                hintText: 'Unesite ime/prezime autora',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              onChanged: (value) {
                _dataSource.filterServerSide(
                  _nazivController.text,
                  _autorNazivController.text,
                );
              },
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              _nazivController.clear();
              _autorNazivController.clear();
              _dataSource.filterServerSide('', '');
              setState(() {});
            },
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.pressed) ||
                    states.contains(WidgetState.selected)) {
                  return const Color(0xFF41706A);
                }
                if (states.contains(WidgetState.hovered)) {
                  return const Color(0xFF51968F);
                }
                return const Color(0xFF3C6E71);
              }),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.clear, color: Colors.white),
                SizedBox(width: 8),
                Text("Očisti filtere", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminKnjigeDetailsScreen(),
                ),
              );
              if (result == true) {
                _dataSource.filterServerSide(
                  _nazivController.text,
                  _autorNazivController.text,
                );
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Dodaj knjigu",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor:
                  WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.pressed) ||
                    states.contains(WidgetState.selected)) {
                  return const Color(0xFF41706A);
                }
                if (states.contains(WidgetState.hovered)) {
                  return const Color(0xFF51968F);
                }
                return const Color(0xFF3C6E71);
              }),
              padding: WidgetStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Tooltip(
            message: 'Filtrirajte knjige po nazivu i/ili autoru.',
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 128, 136, 132),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color.fromARGB(255, 96, 102, 102), width: 1),
            ),
            textStyle: const TextStyle(
              color: Color.fromARGB(255, 246, 246, 246),
              fontSize: 14.5,
            ),
            child: const Icon(
              Icons.info_outline,
              color: Colors.grey,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DataTableTheme(
        data: DataTableThemeData(
          headingRowColor: WidgetStateProperty.all(
              const Color.fromARGB(255, 213, 224, 219)),
          headingTextStyle: const TextStyle(
              color: Color(0xFF3C6E71), fontWeight: FontWeight.bold),
          dataRowColor: WidgetStateProperty.all(Colors.white),
        ),
        child: AdvancedPaginatedDataTable(
          showCheckboxColumn: false,
          addEmptyRows: false,
          source: _dataSource,
          rowsPerPage: 10,
          columns: const [
            DataColumn(label: Text("NAZIV")),
            DataColumn(label: Text("AUTOR")),
            DataColumn(label: Text("SLIKA")),
            DataColumn(label: Text("OPCIJE")),
          ],
        ),
      ),
    );
  }
}

class KnjigaDataSource extends AdvancedDataTableSource<Knjiga> {
  final KnjigaProvider provider;
  final BuildContext context;

  List<Knjiga> data = [];
  int page = 1;
  int pageSize = 10;
  int count = 0;
  String nazivFilter = "";
  String autorNazivFilter = "";

  KnjigaDataSource({required this.provider, required this.context});

  void filterServerSide(String naziv, String autorNaziv) {
    nazivFilter = naziv;
    autorNazivFilter = autorNaziv;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<Knjiga>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize) + 1;

    final filter = {
      'Naziv': nazivFilter,
      'AutorNaziv': autorNazivFilter,
    };

    try {
      final result =
          await provider.get(filter: filter, page: page, pageSize: pageSize);
      data = result.resultList;
      count = result.count;
      return RemoteDataSourceDetails(count, data);
    } catch (e) {
      if (!context.mounted) {
        return RemoteDataSourceDetails(0, []);
      }
      showCustomDialog(
        context: context,
        title: 'Greška',
        message: e.toString(),
        icon: Icons.error,
      );
      return RemoteDataSourceDetails(0, []);
    }
  }

  @override
  DataRow? getRow(int index) {
    if (index >= data.length) return null;
    final item = data[index];

    return DataRow(
      onSelectChanged: (selected) async {
        if (selected == true) {
          try {
            final knjiga = await provider.getById(item.knjigaId!);
            if (!context.mounted) return;
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminKnjigeDetailsScreen(knjiga: knjiga),
              ),
            );
            if (result == true) {
              filterServerSide(nazivFilter, autorNazivFilter);
            }
          } catch (e) {
            if (!context.mounted) return;
            showCustomDialog(
              context: context,
              title: 'Greška',
              message: e.toString(),
              icon: Icons.error,
            );
          }
        }
      },
      color: WidgetStateProperty.resolveWith<Color?>(
        (Set<WidgetState> states) {
          if (states.contains(WidgetState.hovered)) {
            return const Color(0xFFD8EBEA);
          }
          return Colors.white;
        },
      ),
      cells: [
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                item.naziv,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(
                item.autorNaziv ?? '-',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: _buildImage(item.slika),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  try {
                    final knjiga = await provider.getById(item.knjigaId!);
                    if (!context.mounted) return;
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminKnjigeDetailsScreen(knjiga: knjiga),
                      ),
                    );
                    if (result == true) {
                      filterServerSide(nazivFilter, autorNazivFilter);
                    }
                  } catch (e) {
                    if (!context.mounted) return;
                    showCustomDialog(
                      context: context,
                      title: 'Greška',
                      message: e.toString(),
                      icon: Icons.error,
                    );
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.pressed) ||
                        states.contains(WidgetState.selected)) {
                      return const Color(0xFF41706A);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return const Color(0xFF51968F);
                    }
                    return const Color(0xFF3C6E71);
                  }),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 9)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.edit, color: Colors.white, size: 20),
                    SizedBox(width: 6),
                    Text("Uredi", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  showConfirmDialog(
                    context: context,
                    title: "Brisanje",
                    message: "Da li ste sigurni da želite obrisati ovu knjigu?",
                    icon: Icons.warning,
                    iconColor: Colors.red,
                    onConfirm: () async {
                      try {
                        await provider.delete(item.knjigaId!);
                        if (!context.mounted) return;
                        showCustomDialog(
                          context: context,
                          title: "Uspjeh",
                          message: "Knjiga je uspješno obrisana.",
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                        );
                        filterServerSide(nazivFilter, autorNazivFilter);
                      } catch (e) {
                        if (!context.mounted) return;
                        showCustomDialog(
                          context: context,
                          title: "Greška",
                          message: e.toString(),
                          icon: Icons.error,
                          iconColor: Colors.red,
                        );
                      }
                    },
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.resolveWith<Color>((states) {
                    if (states.contains(WidgetState.pressed) ||
                        states.contains(WidgetState.selected)) {
                      return const Color(0xFF41706A);
                    }
                    if (states.contains(WidgetState.hovered)) {
                      return const Color(0xFF51968F);
                    }
                    return const Color(0xFF3C6E71);
                  }),
                  padding: WidgetStateProperty.all(
                      const EdgeInsets.symmetric(horizontal: 13, vertical: 9)),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.delete_outline, color: Colors.white, size: 20),
                    SizedBox(width: 6),
                    Text("Obriši", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildImage(String? slikaBase64) {
    if (slikaBase64 == null || slikaBase64.isEmpty) {
      return Image.asset(
        'assets/images/placeholder.png',
        width: 30,
        height: 30,
        fit: BoxFit.cover,
      );
    }

    try {
      return SizedBox(
        width: 30,
        height: 30,
        child: imageFromString(slikaBase64),
      );
    } catch (_) {
      return const Icon(Icons.broken_image);
    }
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}
