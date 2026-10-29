import 'package:flutter/material.dart';

import '../state/app_routes.dart';

class HalamanBeranda extends StatelessWidget {
  const HalamanBeranda({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Selamat Datang di AgriClima LSTM',
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Informasi Model', style: theme.textTheme.titleLarge),
                const SizedBox(height: 16),
                const _InfoItem(
                  icon: Icons.memory,
                  label: 'Model',
                  value: 'LSTM',
                ),
                const Divider(height: 24),
                const _InfoItem(
                  icon: Icons.schedule,
                  label: 'Horizon prediksi',
                  value: '24 jam ke depan',
                ),
                const Divider(height: 24),
                const _InfoItem(
                  icon: Icons.device_thermostat,
                  label: 'Parameter mikroklimat',
                  value: '3 parameter',
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.tentang),
            icon: const Icon(Icons.info_outline),
            label: const Text('Tentang AgriClima'),
          ),
        ),
      ],
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              Text(value, style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ],
    );
  }
}