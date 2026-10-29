import 'package:flutter/material.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Tentang')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text('Tujuan Aplikasi', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            'AgriClima LSTM membantu memantau kondisi mikroklimat dan '
            'menyajikan prediksi untuk mendukung pengelolaan lahan pertanian.',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 24),
          Text('Lokasi Pemantauan', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          const _TentangListItem(
            icon: Icons.location_on_outlined,
            title: 'Petak 1',
          ),
          const _TentangListItem(
            icon: Icons.location_on_outlined,
            title: 'Petak 2',
          ),
          const SizedBox(height: 24),
          Text('Parameter Mikroklimat', style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          const _TentangListItem(
            icon: Icons.device_thermostat,
            title: 'Suhu udara',
          ),
          const _TentangListItem(
            icon: Icons.water_drop_outlined,
            title: 'Kelembapan udara',
          ),
          const _TentangListItem(
            icon: Icons.grass,
            title: 'Kelembapan tanah',
          ),
        ],
      ),
    );
  }
}

class _TentangListItem extends StatelessWidget {
  const _TentangListItem({required this.icon, required this.title});

  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ListTile(leading: Icon(icon), title: Text(title), contentPadding: EdgeInsets.zero);
  }
}