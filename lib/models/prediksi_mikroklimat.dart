enum StatusMikroklimat { kering, optimal, terlaluLembap }

const Map<String, String> catatanPerawatanPerTanaman = {
  'Padi':
    'Jaga genangan air 2–5 cm pada fase vegetatif dan keringkan lahan '
    'menjelang panen.',
  'Jagung':
    'Siram saat tanah mulai kering dan hindari genangan di sekitar '
    'perakaran.',
  'Cabai':
    'Gunakan mulsa untuk menjaga kelembapan tanah dan siram pada pagi '
    'atau sore hari.',
};

class HasilPrediksi {
  const HasilPrediksi({
    required this.petak,
    required this.namaTanaman,
    required this.suhuUdara,
    required this.kelembapanUdara,
    required this.kelembapanTanah,
    required this.namaPetugas,
    required this.waktu,
  });

  final String petak;
  final String namaTanaman;
  final double suhuUdara;
  final double kelembapanUdara;
  final double kelembapanTanah;
  final String namaPetugas;
  final DateTime waktu;

  StatusMikroklimat get status {
    if (kelembapanTanah < 40) return StatusMikroklimat.kering;
    if (kelembapanTanah <= 70) return StatusMikroklimat.optimal;
    return StatusMikroklimat.terlaluLembap;
  }

  String get namaStatus => switch (status) {
    StatusMikroklimat.kering => 'Kering',
    StatusMikroklimat.optimal => 'Optimal',
    StatusMikroklimat.terlaluLembap => 'Terlalu Lembap',
  };

  String get rekomendasiStatus => switch (status) {
    StatusMikroklimat.kering =>
      'Segera lakukan penyiraman atau irigasi.',
    StatusMikroklimat.optimal =>
      'Pertahankan pola perawatan saat ini.',
    StatusMikroklimat.terlaluLembap =>
      'Kurangi penyiraman dan periksa drainase.',
  };

  String get catatanPerawatan =>
      catatanPerawatanPerTanaman[namaTanaman] ??
      'Catatan perawatan belum tersedia untuk tanaman ini.';
}
