import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_routes.dart';
import 'pages/halaman_beranda.dart';
import 'pages/halaman_input_prediksi.dart';
import 'pages/halaman_riwayat_prediksi.dart';
import 'pages/halaman_tentang.dart';
import 'models/prediksi_mikroklimat.dart';
import 'state/prediksi_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PrediksiModel(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: .fromSeed(seedColor: Colors.deepPurple),
        ),
        routes: {
          AppRoutes.beranda: (_) => const KerangkaNavigasi(),
          AppRoutes.tentang: (_) => const HalamanTentang(),
          AppRoutes.inputPrediksi: (_) => const HalamanInputPrediksi(),
        },
      ),
    );
  }
}

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  static const List<String> _tabNames = [
    'Beranda',
    'Prediksi',
    'Statistik',
    'Pengaturan',
  ];

  int _selectedIndex = 0;

  void _selectTab(int index) {
    setState(() => _selectedIndex = index);
  }

  Future<void> _openPredictionForm() async {
    final result = await Navigator.pushNamed(
      context,
      AppRoutes.inputPrediksi,
    );
    if (!mounted || result is! HasilPrediksi) return;

    context.read<PrediksiModel>().add(result);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data tersimpan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('AgriClima'),
            Text(
              _tabNames[_selectedIndex],
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HalamanBeranda(),
          const _RiwayatPrediksiTab(),
          const _TabContent(title: 'Statistik'),
          const _TabContent(title: 'Pengaturan'),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _selectTab,
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Consumer<PrediksiModel>(
              builder: (context, model, _) => Badge(
                isLabelVisible: model.needsActionCount > 0,
                label: Text('${model.needsActionCount}'),
                child: const Icon(Icons.cloud_outlined),
              ),
            ),
            selectedIcon: Consumer<PrediksiModel>(
              builder: (context, model, _) => Badge(
                isLabelVisible: model.needsActionCount > 0,
                label: Text('${model.needsActionCount}'),
                child: const Icon(Icons.cloud),
              ),
            ),
            label: 'Prediksi',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Statistik',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Pengaturan',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 1
          ? FloatingActionButton.extended(
              onPressed: _openPredictionForm,
              icon: const Icon(Icons.add),
              label: const Text('Prediksi Baru'),
            )
          : null,
    );
  }
}

class _TabContent extends StatelessWidget {
  const _TabContent({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}

class _RiwayatPrediksiTab extends StatelessWidget {
  const _RiwayatPrediksiTab();

  @override
  Widget build(BuildContext context) => const HalamanRiwayatPrediksi();
}

