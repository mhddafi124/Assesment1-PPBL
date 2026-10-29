import 'package:flutter/material.dart';

import '../models/prediksi_mikroklimat.dart';

class HalamanInputPrediksi extends StatefulWidget {
  const HalamanInputPrediksi({super.key});

  @override
  State<HalamanInputPrediksi> createState() => _HalamanInputPrediksiState();
}

class _HalamanInputPrediksiState extends State<HalamanInputPrediksi> {
  final _formKey = GlobalKey<FormState>();
  final _temperatureController = TextEditingController();
  final _airHumidityController = TextEditingController();
  final _soilHumidityController = TextEditingController();
  final _officerController = TextEditingController();
  String? _selectedPlot;
  String? _selectedCrop;
  bool _dataConfirmed = false;

  @override
  void dispose() {
    _temperatureController.dispose();
    _airHumidityController.dispose();
    _soilHumidityController.dispose();
    _officerController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    _formKey.currentState!.save();

    final prediction = HasilPrediksi(
      petak: _selectedPlot!,
      namaTanaman: _selectedCrop!,
      suhuUdara: double.parse(_temperatureController.text.trim()),
      kelembapanUdara: double.parse(_airHumidityController.text.trim()),
      kelembapanTanah: double.parse(_soilHumidityController.text.trim()),
      namaPetugas: _officerController.text.trim(),
      waktu: DateTime.now(),
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Konfirmasi'),
        content: Text(
          'Simpan prediksi ${prediction.namaTanaman} di ${prediction.petak}?\n'
          'Status: ${prediction.namaStatus}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Ya, Simpan'),
          ),
        ],
      ),
    );

    if (!mounted || confirmed != true) return;
    Navigator.pop(context, prediction);
  }

  String? _validateNumber(
    String? value, {
    required String label,
    bool percentage = false,
  }) {
    if (value == null || value.trim().isEmpty) return '$label wajib diisi';
    final parsedValue = double.tryParse(value.trim());
    if (parsedValue == null) return '$label harus berupa angka';
    if (percentage && (parsedValue < 0 || parsedValue > 100)) {
      return '$label harus antara 0 dan 100';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Prediksi')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            Text('Petak', style: Theme.of(context).textTheme.titleMedium),
            FormField<String>(
              validator: (value) => value == null ? 'Pilih petak' : null,
              onSaved: (value) => _selectedPlot = value,
              builder: (field) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RadioGroup<String>(
                    groupValue: field.value,
                    onChanged: field.didChange,
                    child: const Column(
                      children: [
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Petak 1'),
                          value: 'Petak 1',
                        ),
                        RadioListTile<String>(
                          contentPadding: EdgeInsets.zero,
                          title: Text('Petak 2'),
                          value: 'Petak 2',
                        ),
                      ],
                    ),
                  ),
                  if (field.hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, bottom: 12),
                      child: Text(
                        field.errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            DropdownButtonFormField<String>(
              initialValue: _selectedCrop,
              decoration: const InputDecoration(
                labelText: 'Nama Tanaman',
                border: OutlineInputBorder(),
              ),
              hint: const Text('Pilih tanaman'),
              items: const [
                DropdownMenuItem(value: 'Padi', child: Text('Padi')),
                DropdownMenuItem(value: 'Jagung', child: Text('Jagung')),
                DropdownMenuItem(value: 'Cabai', child: Text('Cabai')),
              ],
              validator: (value) => value == null ? 'Pilih tanaman' : null,
              onChanged: (value) => setState(() => _selectedCrop = value),
            ),
            const SizedBox(height: 20),
            _numberField(
              key: const ValueKey('temperature'),
              controller: _temperatureController,
              label: 'Prediksi suhu udara (°C)',
              validator: (value) => _validateNumber(value, label: 'Suhu'),
            ),
            const SizedBox(height: 16),
            _numberField(
              key: const ValueKey('air-humidity'),
              controller: _airHumidityController,
              label: 'Prediksi kelembapan udara (%)',
              validator: (value) => _validateNumber(
                value,
                label: 'Kelembapan udara',
                percentage: true,
              ),
            ),
            const SizedBox(height: 16),
            _numberField(
              key: const ValueKey('soil-humidity'),
              controller: _soilHumidityController,
              label: 'Prediksi kelembapan tanah (%)',
              validator: (value) => _validateNumber(
                value,
                label: 'Kelembapan tanah',
                percentage: true,
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              key: const ValueKey('officer'),
              controller: _officerController,
              decoration: const InputDecoration(
                labelText: 'Nama Petugas',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama petugas wajib diisi'
                  : null,
            ),
            const SizedBox(height: 8),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Data sudah benar'),
              value: _dataConfirmed,
              onChanged: (value) =>
                  setState(() => _dataConfirmed = value ?? false),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
              onPressed: _dataConfirmed ? _submitForm : null,
              icon: const Icon(Icons.save_outlined),
              label: const Text('Simpan'),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numberField({
    required Key key,
    required TextEditingController controller,
    required String label,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      key: key,
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(
        decimal: true,
        signed: true,
      ),
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}