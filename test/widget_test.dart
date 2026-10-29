// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/prediksi_mikroklimat.dart';
import 'package:flutter_application_1/state/app_routes.dart';

void main() {
  testWidgets('Beranda menampilkan informasi model dan membuka Tentang', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Selamat Datang di AgriClima LSTM'), findsOneWidget);
    expect(find.text('LSTM'), findsOneWidget);
    expect(find.text('24 jam ke depan'), findsOneWidget);
    expect(find.text('3 parameter'), findsOneWidget);

    await tester.tap(find.text('Tentang AgriClima'));
    await tester.pumpAndSettle();

    expect(find.text('Tentang'), findsWidgets);
  });

  testWidgets('Form prediksi menampilkan semua field yang diminta', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Prediksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prediksi Baru'));
    await tester.pumpAndSettle();

    expect(find.text('Petak 1'), findsOneWidget);
    expect(find.text('Petak 2'), findsOneWidget);
    expect(find.text('Nama Tanaman'), findsOneWidget);
    expect(find.text('Prediksi suhu udara (°C)'), findsOneWidget);
    expect(find.text('Prediksi kelembapan udara (%)'), findsOneWidget);
    expect(find.text('Prediksi kelembapan tanah (%)'), findsOneWidget);
    expect(find.text('Nama Petugas'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Data sudah benar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    expect(find.text('Data sudah benar'), findsOneWidget);
    expect(tester.widget<FilledButton>(find.byType(FilledButton)).onPressed, isNull);
  });

  testWidgets('Route input prediksi dapat dibuka dengan konstanta route', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final context = tester.element(find.byType(KerangkaNavigasi));
    Navigator.pushNamed(context, AppRoutes.inputPrediksi);
    await tester.pumpAndSettle();

    expect(find.text('Input Prediksi'), findsOneWidget);
  });

  testWidgets('Validasi form mewajibkan pilihan petak', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final context = tester.element(find.byType(KerangkaNavigasi));
    Navigator.pushNamed(context, AppRoutes.inputPrediksi);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('Data sudah benar'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Data sudah benar'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Pilih petak'), findsOneWidget);
  });

  testWidgets('Form menampilkan error untuk nilai prediksi dan petugas invalid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    final context = tester.element(find.byType(KerangkaNavigasi));
    Navigator.pushNamed(context, AppRoutes.inputPrediksi);
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('temperature')), 'panas');
    await tester.enterText(find.byKey(const ValueKey('air-humidity')), '101');
    await tester.enterText(find.byKey(const ValueKey('soil-humidity')), 'abc');
    await tester.ensureVisible(find.text('Data sudah benar'));
    await tester.tap(find.text('Data sudah benar'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Suhu harus berupa angka'), findsOneWidget);
    expect(
      find.text('Kelembapan udara harus antara 0 dan 100'),
      findsOneWidget,
    );
    expect(find.text('Kelembapan tanah harus berupa angka'), findsOneWidget);
    expect(find.text('Nama petugas wajib diisi'), findsOneWidget);
  });

  testWidgets('Prediksi Baru menyimpan hasil dan kembali dengan status', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Prediksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prediksi Baru'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Petak 1'));
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Padi').last);
    await tester.enterText(find.byKey(const ValueKey('temperature')), '25');
    await tester.enterText(find.byKey(const ValueKey('air-humidity')), '70');
    await tester.enterText(find.byKey(const ValueKey('soil-humidity')), '60');
    await tester.enterText(find.byKey(const ValueKey('officer')), 'Ayu');
    await tester.ensureVisible(find.text('Data sudah benar'));
    await tester.tap(find.text('Data sudah benar'));
    await tester.pumpAndSettle();

    final saveButton = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(saveButton.onPressed, isNotNull);
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    expect(find.text('Konfirmasi'), findsOneWidget);
    expect(find.text('Simpan prediksi Padi di Petak 1?\nStatus: Optimal'), findsOneWidget);
    await tester.tap(find.text('Ya, Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Input Prediksi'), findsNothing);
    expect(find.text('Optimal'), findsWidgets);
    expect(
      find.text(
        'Rekomendasi: Pertahankan pola perawatan saat ini.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'Catatan: Jaga genangan air 2–5 cm pada fase vegetatif dan '
        'keringkan lahan menjelang panen.',
      ),
      findsOneWidget,
    );
    expect(find.text('Data tersimpan'), findsOneWidget);
  });

  testWidgets('Riwayat mendukung filter, badge tindakan, dan hapus data', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Prediksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prediksi Baru'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Petak 2'));
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Jagung').last);
    await tester.enterText(find.byKey(const ValueKey('temperature')), '25');
    await tester.enterText(find.byKey(const ValueKey('air-humidity')), '65');
    await tester.enterText(find.byKey(const ValueKey('soil-humidity')), '35');
    await tester.enterText(find.byKey(const ValueKey('officer')), 'Budi');
    await tester.ensureVisible(find.text('Data sudah benar'));
    await tester.tap(find.text('Data sudah benar'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ya, Simpan'));
    await tester.pumpAndSettle();

    expect(find.text('Kering'), findsWidgets);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('Perlu Tindakan'), findsOneWidget);
    expect(find.text('1'), findsWidgets);
    expect(find.byType(Badge), findsWidgets);

    await tester.tap(find.text('Petak 1'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada data'), findsOneWidget);

    await tester.tap(find.text('Petak 2'));
    await tester.pumpAndSettle();
    await tester.tap(find.byTooltip('Hapus data'));
    await tester.pumpAndSettle();
    expect(find.text('Belum ada data'), findsOneWidget);
  });

  testWidgets('Batal pada konfirmasi tidak menyimpan dan tetap di form', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.tap(find.text('Prediksi'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Prediksi Baru'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Petak 2'));
    await tester.ensureVisible(find.byType(DropdownButtonFormField<String>));
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Cabai').last);
    await tester.enterText(find.byKey(const ValueKey('temperature')), '25');
    await tester.enterText(find.byKey(const ValueKey('air-humidity')), '70');
    await tester.enterText(find.byKey(const ValueKey('soil-humidity')), '35');
    await tester.enterText(find.byKey(const ValueKey('officer')), 'Budi');
    await tester.ensureVisible(find.text('Data sudah benar'));
    await tester.tap(find.text('Data sudah benar'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Simpan'));
    await tester.tap(find.text('Simpan'));
    await tester.pumpAndSettle();

    expect(
      find.text('Simpan prediksi Cabai di Petak 2?\nStatus: Kering'),
      findsOneWidget,
    );
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    expect(find.text('Input Prediksi'), findsOneWidget);
    expect(find.text('Konfirmasi'), findsNothing);
  });

  test('Status kelembapan tanah mengikuti batas Tabel A', () {
    HasilPrediksi buildPrediction(double soilHumidity) {
      return HasilPrediksi(
        petak: 'Petak 1',
        namaTanaman: 'Padi',
        suhuUdara: 25,
        kelembapanUdara: 70,
        kelembapanTanah: soilHumidity,
        namaPetugas: 'Ayu',
        waktu: DateTime(2026, 10, 29),
      );
    }

    expect(buildPrediction(39.9).namaStatus, 'Kering');
    expect(buildPrediction(40).namaStatus, 'Optimal');
    expect(buildPrediction(70).namaStatus, 'Optimal');
    expect(buildPrediction(70.1).namaStatus, 'Terlalu Lembap');
  });

  test('Rekomendasi perawatan mengikuti Tabel B berdasarkan tanaman', () {
    HasilPrediksi buildPrediction(String crop) {
      return HasilPrediksi(
        petak: 'Petak 1',
        namaTanaman: crop,
        suhuUdara: 25,
        kelembapanUdara: 70,
        kelembapanTanah: 60,
        namaPetugas: 'Ayu',
        waktu: DateTime(2026, 10, 29),
      );
    }

    expect(
      buildPrediction('Padi').catatanPerawatan,
      'Jaga genangan air 2–5 cm pada fase vegetatif dan keringkan lahan '
      'menjelang panen.',
    );
    expect(
      buildPrediction('Jagung').catatanPerawatan,
      'Siram saat tanah mulai kering dan hindari genangan di sekitar '
      'perakaran.',
    );
    expect(
      buildPrediction('Cabai').catatanPerawatan,
      'Gunakan mulsa untuk menjaga kelembapan tanah dan siram pada pagi '
      'atau sore hari.',
    );
  });
}
