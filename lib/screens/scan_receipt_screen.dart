import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../helpers/receipt_parser.dart';
import '../models/transaction.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../theme/app_theme.dart';

class ScanReceiptScreen extends ConsumerStatefulWidget {
  const ScanReceiptScreen({super.key});
  @override
  ConsumerState<ScanReceiptScreen> createState() => _ScanReceiptScreenState();
}

class _ScanReceiptScreenState extends ConsumerState<ScanReceiptScreen> {
  File? _imageFile;
  bool _isProcessing = false;
  String _rawText = '';
  List<ParsedReceiptItem> _parsedItems = [];
  final _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    setState(() {
      _imageFile = File(picked.path);
      _parsedItems = [];
      _rawText = '';
    });
    await _processImage();
  }

  Future<void> _processImage() async {
    if (_imageFile == null) return;
    setState(() => _isProcessing = true);
    try {
      final inputImage = InputImage.fromFile(_imageFile!);
      final recognizer = TextRecognizer(script: TextRecognitionScript.latin);
      final result = await recognizer.processImage(inputImage);
      await recognizer.close();
      setState(() {
        _rawText = result.text;
        _parsedItems = ReceiptParser.parseReceipt(_rawText);
        _isProcessing = false;
      });
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memproses: $e'), backgroundColor: AppColors.danger),
        );
      }
    }
  }

  void _saveItems() {
    final selected = _parsedItems.where((i) => i.isSelected).toList();
    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih minimal 1 item')),
      );
      return;
    }
    final provider = ref.read(transactionProvider.notifier);
    for (final item in selected) {
      provider.addTransaction(CoffeeTransaction(
        id: const Uuid().v4(),
        coffeeName: item.name,
        price: item.price,
        date: DateTime.now(),
        category: item.category,
        note: 'Dari scan struk',
      ));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${selected.length} transaksi berhasil disimpan!'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Scan Struk', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.divider),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.arrow_back_ios_new, size: 14),
          ),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text('Scan Struk Belanjaan', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('Foto struk kopi kamu, item & harga terdeteksi otomatis',
                style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            const SizedBox(height: 20),

            // Image Area
            if (_imageFile == null) _buildPickerButtons() else _buildImagePreview(),

            // Processing
            if (_isProcessing) ...[
              const SizedBox(height: 20),
              Center(child: Column(children: [
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 12),
                Text('Memproses struk...', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
              ])),
            ],

            // Parsed Items
            if (_parsedItems.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildParsedItems(),
            ],

            // No items found
            if (!_isProcessing && _imageFile != null && _parsedItems.isEmpty && _rawText.isNotEmpty) ...[
              const SizedBox(height: 20),
              _buildNoItems(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPickerButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider, style: BorderStyle.solid),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(8), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(
              color: AppColors.secondary, borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 36),
          ),
          const SizedBox(height: 16),
          Text('Ambil foto struk', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Pastikan teks pada struk terlihat jelas',
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt_rounded, size: 20),
                  label: Text('Kamera', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_rounded, size: 20, color: AppColors.primary),
                  label: Text('Galeri', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.primary)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(_imageFile!, width: double.infinity, height: 200, fit: BoxFit.cover),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt_rounded, size: 18, color: AppColors.primary),
                label: Text('Foto Ulang', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library_rounded, size: 18, color: AppColors.primary),
                label: Text('Galeri', style: GoogleFonts.poppins(fontSize: 13, color: AppColors.primary)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.divider),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParsedItems() {
    final totalSelected = _parsedItems.where((i) => i.isSelected).fold(0, (s, i) => s + i.price);
    final count = _parsedItems.where((i) => i.isSelected).length;
    String fmt(int v) => 'Rp ${v.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Item Terdeteksi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: AppColors.success.withAlpha(20), borderRadius: BorderRadius.circular(8)),
              child: Text('${_parsedItems.length} item', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._parsedItems.asMap().entries.map((entry) {
          final item = entry.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: item.isSelected ? AppColors.primary.withAlpha(60) : AppColors.divider),
              boxShadow: [BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 6)],
            ),
            child: Row(
              children: [
                Checkbox(
                  value: item.isSelected,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (v) => setState(() => item.isSelected = v!),
                ),
                Container(
                  width: 40, height: 40,
                  decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.coffee_rounded, color: AppColors.primary, size: 20),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text(item.category, style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text(fmt(item.price), style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13)),
              ],
            ),
          );
        }),
        const SizedBox(height: 12),
        // Total & Save
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total ($count item)', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
              Text(fmt(totalSelected), style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity, height: 50,
          child: ElevatedButton.icon(
            onPressed: _saveItems,
            icon: const Icon(Icons.save_rounded, size: 20),
            label: Text('Simpan $count Transaksi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoItems() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(Icons.search_off_rounded, size: 48, color: AppColors.textSecondary.withAlpha(80)),
          const SizedBox(height: 12),
          Text('Tidak ada item terdeteksi', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text('Coba foto ulang dengan pencahayaan lebih baik',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}
