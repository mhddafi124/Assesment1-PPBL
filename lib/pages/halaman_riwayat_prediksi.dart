import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/prediksi_model.dart';
import '../widgets/prediksi_card.dart';
import '../widgets/stat_card.dart';

class HalamanRiwayatPrediksi extends StatelessWidget {
  const HalamanRiwayatPrediksi({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PrediksiModel>(
      builder: (context, model, _) {
        final predictions = model.filteredItems;
        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
          children: [
            Text(
              'Riwayat Prediksi',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'Semua', label: Text('Semua')),
                ButtonSegment(value: 'Petak 1', label: Text('Petak 1')),
                ButtonSegment(value: 'Petak 2', label: Text('Petak 2')),
              ],
              selected: {model.petakFilter},
              onSelectionChanged: (selection) {
                model.setPetakFilter(selection.first);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    label: 'Total',
                    value: model.totalCount,
                  ),
                ),
                Expanded(
                  child: StatCard(
                    label: 'Optimal',
                    value: model.optimalCount,
                    color: Colors.green,
                  ),
                ),
                Expanded(
                  child: StatCard(
                    label: 'Perlu Tindakan',
                    value: model.needsActionCount,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (predictions.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: Center(child: Text('Belum ada data')),
              )
            else
              for (final prediction in predictions)
                PrediksiCard(
                  prediction: prediction,
                  onDelete: () => model.delete(prediction),
                ),
          ],
        );
      },
    );
  }
}
