import 'package:flutter/material.dart';
import 'package:littrack_desktop/layouts/master_screen.dart';
import 'package:littrack_desktop/models/autor.dart';
import 'package:littrack_desktop/providers/autor_provider.dart';
import 'package:littrack_desktop/providers/utils.dart';
import 'package:advanced_datatable/datatable.dart';
import 'package:advanced_datatable/advanced_datatable_source.dart';
import 'package:littrack_desktop/screens/admin_autori_details.dart';
import 'package:provider/provider.dart';

class AdminAutoriScreen extends StatefulWidget {
  const AdminAutoriScreen({super.key});

  @override
  State<AdminAutoriScreen> createState() => _AdminAutoriScreenState();
}

class _AdminAutoriScreenState extends State<AdminAutoriScreen> {
  final TextEditingController _imeController = TextEditingController();
  late AutorProvider _provider;
  late AutorDataSource _dataSource;

  @override
  void initState() {
    super.initState();
    _provider = context.read<AutorProvider>();
    _dataSource = AutorDataSource(provider: _provider, context: context);
    _dataSource.loadInitial();
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Autori",
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
              controller: _imeController,
              decoration: InputDecoration(
                labelText: 'Ime ili prezime autora',
                hintText: 'Unesite ime ili prezime',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              ),
              onChanged: (value) {
                _dataSource.filterServerSide(value);
              },
            ),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              _imeController.clear();
              _dataSource.filterServerSide('');
            },
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
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
                  builder: (context) => const AdminAutoriDetailsScreen(),
                ),
              );
              if (result == true) {
                await _dataSource.reset();
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Dodaj autora",
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
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
            message: 'Filtrirajte autore po imenu i/ili prezimenu.',
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
          headingRowColor:
              WidgetStateProperty.all(const Color.fromARGB(255, 213, 224, 219)),
          headingTextStyle: const TextStyle(
            color: Color(0xFF3C6E71),
            fontWeight: FontWeight.bold,
          ),
          dataRowColor: WidgetStateProperty.all(Colors.white),
        ),
        child: AdvancedPaginatedDataTable(
          showCheckboxColumn: false,
          addEmptyRows: false,
          source: _dataSource,
          rowsPerPage: _dataSource.pageSize,
          showFirstLastButtons: true,
          columns: const [
            DataColumn(label: Text("IME")),
            DataColumn(label: Text("PREZIME")),
            DataColumn(label: Text("OPCIJE")),
          ],
        ),
      ),
    );
  }
}

class AutorDataSource extends AdvancedDataTableSource<Autor> {
  final AutorProvider provider;
  final BuildContext context;

  List<Autor> data = [];
  int page = 1;
  final int pageSize = 10;
  int count = 0;
  String imeFilter = "";

  AutorDataSource({required this.provider, required this.context});

  Future<void> loadInitial() async {
    if (!context.mounted) return;
    try {
      await reset(targetPage: page);
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

  void filterServerSide(String ime) async {
    imeFilter = ime;
    await reset(targetPage: 1);
  }

  Future<void> reset({int? targetPage}) async {
    final newPage = targetPage ?? page;
    final filter = {'ImePrezime': imeFilter};

    try {
      final result =
          await provider.get(filter: filter, page: newPage, pageSize: pageSize);

      var newData = result.resultList;
      var newCount = result.count;

      if (newData.isEmpty && newPage > 1) {
        final fallbackPage = newPage - 1;
        final fallbackResult = await provider.get(
            filter: filter, page: fallbackPage, pageSize: pageSize);
        newData = fallbackResult.resultList;
        newCount = fallbackResult.count;
        page = fallbackPage;
      } else {
        page = newPage;
      }

      data = newData;
      count = newCount;

      setNextView(startIndex: (page - 1) * pageSize);
      await Future.delayed(const Duration(milliseconds: 100));
      notifyListeners();
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

  @override
  Future<RemoteDataSourceDetails<Autor>> getNextPage(
      NextPageRequest pageRequest) async {
    page = (pageRequest.offset ~/ pageSize) + 1;
    final filter = {'ImePrezime': imeFilter};

    try {
      final result =
          await provider.get(filter: filter, page: page, pageSize: pageSize);
      data = result.resultList;
      count = result.count;
      return RemoteDataSourceDetails(count, data);
    } catch (e) {
      if (!context.mounted) return RemoteDataSourceDetails(0, []);
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
      color: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.hovered)) {
          return const Color(0xFFD8EBEA);
        }
        return Colors.white;
      }),
      onSelectChanged: (selected) async {
        if (selected == true) {
          try {
            final autor = await provider.getById(item.autorId!);
            if (!context.mounted) return;

            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminAutoriDetailsScreen(autor: autor),
              ),
            );

            if (result == true) {
              if (!context.mounted) return;
              await reset();
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
      cells: [
        DataCell(
          Tooltip(
            message: "Klikni za prikaz detalja",
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                item.ime,
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
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                item.prezime,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
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
                    final autor = await provider.getById(item.autorId!);
                    if (!context.mounted) return;

                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            AdminAutoriDetailsScreen(autor: autor),
                      ),
                    );

                    if (result == true) {
                      await reset();
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
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.pressed) ||
                          states.contains(WidgetState.selected)) {
                        return const Color(0xFF41706A);
                      }
                      if (states.contains(WidgetState.hovered)) {
                        return const Color(0xFF51968F);
                      }
                      return const Color(0xFF3C6E71);
                    },
                  ),
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
                    message:
                        "Da li ste sigurni da želite obrisati ovog autora?",
                    icon: Icons.warning,
                    iconColor: Colors.red,
                    onConfirm: () async {
                      try {
                        await provider.delete(item.autorId!);
                        if (!context.mounted) return;
                        showCustomDialog(
                          context: context,
                          title: "Uspjeh",
                          message: "Autor je uspješno obrisan.",
                          icon: Icons.check_circle,
                          iconColor: Colors.green,
                        );
                        await reset();
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
                  backgroundColor: WidgetStateProperty.resolveWith<Color>(
                    (states) {
                      if (states.contains(WidgetState.pressed) ||
                          states.contains(WidgetState.selected)) {
                        return const Color(0xFF41706A);
                      }
                      if (states.contains(WidgetState.hovered)) {
                        return const Color(0xFF51968F);
                      }
                      return const Color(0xFF3C6E71);
                    },
                  ),
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

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => count;

  @override
  int get selectedRowCount => 0;
}
