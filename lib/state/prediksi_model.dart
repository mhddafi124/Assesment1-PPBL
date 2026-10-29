import 'package:flutter/foundation.dart';

import '../models/prediksi_mikroklimat.dart';

class PrediksiModel extends ChangeNotifier {
  final List<HasilPrediksi> _items = [];
  String _petakFilter = 'Semua';

  List<HasilPrediksi> get items => List.unmodifiable(_items);
  String get petakFilter => _petakFilter;

  List<HasilPrediksi> get filteredItems => _petakFilter == 'Semua'
      ? items
      : List.unmodifiable(_items.where((item) => item.petak == _petakFilter));

  int get totalCount => _items.length;
  int get optimalCount =>
      _items.where((item) => item.status == StatusMikroklimat.optimal).length;
    int get dryCount =>
      _items.where((item) => item.status == StatusMikroklimat.kering).length;
    int get tooWetCount => _items
      .where((item) => item.status == StatusMikroklimat.terlaluLembap)
      .length;
  int get needsActionCount => _items
      .where((item) => item.status != StatusMikroklimat.optimal)
      .length;

  void add(HasilPrediksi prediction) {
    _items.insert(0, prediction);
    notifyListeners();
  }

  void delete(HasilPrediksi prediction) {
    _items.remove(prediction);
    notifyListeners();
  }

  void setPetakFilter(String value) {
    if (value == _petakFilter) return;
    _petakFilter = value;
    notifyListeners();
  }
}
