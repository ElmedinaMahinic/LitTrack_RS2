import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/providers/ciljna_grupa_provider.dart';
import 'package:littrack_desktop/models/ciljna_grupa.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:littrack_desktop/screens/admin_ciljne_grupe_details.dart';
import 'package:provider/provider.dart';

class AdminCiljneGrupeScreen extends StatefulWidget {
  const AdminCiljneGrupeScreen({super.key});

  @override
  State<AdminCiljneGrupeScreen> createState() => _AdminCiljneGrupeScreenState();
}

class _AdminCiljneGrupeScreenState extends State<AdminCiljneGrupeScreen> {
  final TextEditingController _nazivController = TextEditingController();
  late CiljnaGrupaProvider _provider;
  late CiljnaGrupaDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _provider = context.read<CiljnaGrupaProvider>();
    _dataSource = CiljnaGrupaDataSource(provider: _provider, context: context);
    _dataSource.filterServerSide('');
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Ciljne grupe",
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
                labelText: 'Naziv ciljne grupe',
                hintText: 'Unesite naziv ciljne grupe',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
              ),
              onChanged: (value) {
                _dataSource.filterServerSide(value);
              },
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              _nazivController.clear();
              _dataSource.filterServerSide('');
              setState(() {});
            },
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.hovered)) {
                  return const Color(0xFF51968F);
                }
                return const Color(0xFF3C6E71);
              }),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              shape: MaterialStateProperty.all(
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
                  builder: (context) => const AdminCiljnaGrupaDetailsScreen(),
                ),
              );
              if (result == true) {
                _dataSource.filterServerSide(_nazivController.text);
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Dodaj ciljnu grupu",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.resolveWith<Color>((states) {
                if (states.contains(MaterialState.hovered)) {
                  return const Color(0xFF51968F);
                }
                return const Color(0xFF3C6E71);
              }),
              padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Tooltip(
            message: 'Filtrirajte ciljne grupe po nazivu.',
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 128, 136, 132),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color.fromARGB(255, 96, 102, 102),
                width: 1,
              ),
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
          headingRowColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 213, 224, 219)),
          headingTextStyle: const TextStyle(
            color: Color(0xFF3C6E71),
            fontWeight: FontWeight.bold,
          ),
          dataRowColor: MaterialStateProperty.all(Colors.white),
        ),
        child: AdvancedPaginatedDataTable(
          showCheckboxColumn: false,
          addEmptyRows: false,
          source: _dataSource,
          rowsPerPage: 10,
          columns: const [
            DataColumn(label: Text("NAZIV")),
            DataColumn(label: Text("OPCIJE")),
          ],
        ),
      ),
    );
  }
}

class CiljnaGrupaDataSource extends AdvancedDataTableSource<CiljnaGrupa> {
  final CiljnaGrupaProvider provider;
  final BuildContext context;

  List<CiljnaGrupa> data = [];
  int page = 1;
  int pageSize = 10;
  int count = 0;
  String nazivFilter = "";

  CiljnaGrupaDataSource({required this.provider, required this.context});

  void filterServerSide(String naziv) {
    nazivFilter = naziv;
    setNextView();
  }

  @override
  Future<RemoteDataSourceDetails<CiljnaGrupa>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize) + 1;
    final filter = {'Naziv': nazivFilter};

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
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminCiljnaGrupaDetailsScreen(
                ciljnaGrupa: item,
              ),
            ),
          );
          if (result == true) {
            filterServerSide(nazivFilter);
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                item.naziv,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminCiljnaGrupaDetailsScreen(
                        ciljnaGrupa: item,
                      ),
                    ),
                  );
                  if (result == true) {
                    filterServerSide(nazivFilter);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return const Color(0xFF51968F);
                    }
                    return const Color(0xFF3C6E71);
                  }),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                  ),
                  shape: MaterialStateProperty.all(
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
                    message:
                        "Da li ste sigurni da želite obrisati ovu ciljnu grupu?",
                    icon: Icons.warning,
                    iconColor: Colors.red,
                    onConfirm: () async {
                      try {
                        await provider.delete(item.ciljnaGrupaId!);
                        showCustomDialog(
                          context: context,
                          title: "Uspjeh",
                          message: "Ciljna grupa je uspješno obrisana.",
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                        );
                        filterServerSide(nazivFilter);
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
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.resolveWith<Color>((states) {
                    if (states.contains(MaterialState.hovered)) {
                      return const Color(0xFF51968F);
                    }
                    return const Color(0xFF3C6E71);
                  }),
                  padding: MaterialStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
                  ),
                  shape: MaterialStateProperty.all(
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

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}
