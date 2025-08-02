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
            child: Column(
              children: [
                TextField(
                  controller: _nazivController,
                  decoration: InputDecoration(
                    labelText: 'Naziv knjige',
                    hintText: 'Unesite naziv knjige',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                  ),
                  onChanged: (value) {
                    _dataSource.filterServerSide(
                        _nazivController.text, _autorNazivController.text);
                  },
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: _autorNazivController,
                  decoration: InputDecoration(
                    labelText: 'Autor',
                    hintText: 'Unesite ime/prezime autora',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 12),
                  ),
                  onChanged: (value) {
                    _dataSource.filterServerSide(
                        _nazivController.text, _autorNazivController.text);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C6E71),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onPressed: () {
              _nazivController.clear();
              _autorNazivController.clear();
              _dataSource.filterServerSide('', '');
              setState(() {});
            },
            child: const Text("Očisti filtere",
                style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 15),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3C6E71),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
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
            child: const Text("Dodaj knjigu",
                style: TextStyle(color: Colors.white)),
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
          headingRowColor: MaterialStateProperty.all(const Color(0xFF3C6E71)),
          headingTextStyle:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          dataRowColor: MaterialStateProperty.all(Colors.white),
        ),
        child: AdvancedPaginatedDataTable(
          showCheckboxColumn: false,
          addEmptyRows: false,
          source: _dataSource,
          rowsPerPage: 10,
          columns: const [
            DataColumn(label: Text("Naziv")),
            DataColumn(label: Text("Autor")),
            DataColumn(label: Text("Slika")),
            DataColumn(label: Text("Opcije")),
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
            showCustomDialog(
              context: context,
              title: 'Greška',
              message: e.toString(),
              icon: Icons.error,
            );
          }
        }
      },
      color: MaterialStateProperty.resolveWith<Color?>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.hovered)) {
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
              child: Text(item.naziv),
            ),
          ),
        ),
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text(item.autorNaziv ?? '-'),
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
                    showCustomDialog(
                      context: context,
                      title: 'Greška',
                      message: e.toString(),
                      icon: Icons.error,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C6E71),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child:
                    const Text("Uredi", style: TextStyle(color: Colors.white)),
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
                        showCustomDialog(
                          context: context,
                          title: "Uspjeh",
                          message: "Knjiga je uspješno obrisana.",
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                        );
                        filterServerSide(nazivFilter, autorNazivFilter);
                      } catch (e) {
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3C6E71),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                child:
                    const Text("Obriši", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
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
