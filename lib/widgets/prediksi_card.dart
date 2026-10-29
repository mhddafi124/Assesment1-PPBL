import 'package:flutter/material.dart';

import '../models/prediksi_mikroklimat.dart';

class PrediksiCard extends StatelessWidget {
  const PrediksiCard({
    super.key,
    required this.prediction,
    required this.onDelete,
  });

  final HasilPrediksi prediction;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final Color statusColor = switch (prediction.status) {
      StatusMikroklimat.kering => colors.error,
      StatusMikroklimat.optimal => Colors.green,
      StatusMikroklimat.terlaluLembap => Colors.blue,
    };

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${prediction.petak} · ${prediction.namaTanaman}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                IconButton(
                  onPressed: onDelete,
                  tooltip: 'Hapus data',
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  prediction.namaStatus,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: prediction.kelembapanTanah / 100),
            const SizedBox(height: 12),
            Text('Kelembapan tanah: ${prediction.kelembapanTanah}%'),
            Text('Suhu udara: ${prediction.suhuUdara} °C'),
            Text('Kelembapan udara: ${prediction.kelembapanUdara}%'),
            Text('Rekomendasi: ${prediction.rekomendasiStatus}'),
            Text('Catatan: ${prediction.catatanPerawatan}'),
            const SizedBox(height: 8),
            Text('Petugas: ${prediction.namaPetugas}'),
            Text(
              'Waktu prediksi: ${_formatTime(prediction.waktu)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime value) {
    String twoDigits(int number) => number.toString().padLeft(2, '0');
    return '${twoDigits(value.day)}/${twoDigits(value.month)}/${value.year} '
        '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }
}
