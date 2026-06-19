import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../models/transaction.dart';
import '../features/transaction/providers/transaction_provider.dart';
import '../theme/app_theme.dart';
import '../core/widgets/widgets.dart';

class AddTransactionScreen extends ConsumerStatefulWidget {
  final CoffeeTransaction? editTransaction;
  const AddTransactionScreen({super.key, this.editTransaction});

  @override
  ConsumerState<AddTransactionScreen> createState() =>
      _AddTransactionScreenState();
}

class _AddTransactionScreenState extends ConsumerState<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _coffeeNameController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory = 'Lainnya';

  // Extended fields (Tahap 2)
  double? _locationLat;
  double? _locationLng;
  LocationSource? _locationSource;
  String? _coffeeshopId;
  TransactionSource _source = TransactionSource.manual;
  DateTime _transactionTime = DateTime.now();
  String? _priceError;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Espresso', 'icon': Icons.coffee, 'color': Color(0xFF3C2415)},
    {'name': 'Latte', 'icon': Icons.local_cafe, 'color': Color(0xFFD4A574)},
    {
      'name': 'Cappuccino',
      'icon': Icons.coffee_maker,
      'color': Color(0xFF8B6914)
    },
    {
      'name': 'Americano',
      'icon': Icons.coffee_rounded,
      'color': Color(0xFF5D4037)
    },
    {
      'name': 'Kopi Susu',
      'icon': Icons.local_drink,
      'color': Color(0xFFA1887F)
    },
    {
      'name': 'Manual Brew',
      'icon': Icons.filter_alt,
      'color': Color(0xFF6F4E37)
    },
    {'name': 'Frappuccino', 'icon': Icons.icecream, 'color': Color(0xFF90CAF9)},
    {'name': 'Lainnya', 'icon': Icons.more_horiz, 'color': Color(0xFFBDBDBD)},
  ];

  bool get isEditing => widget.editTransaction != null;

  @override
  void initState() {
    super.initState();
    if (isEditing) {
      final t = widget.editTransaction!;
      _coffeeNameController.text = t.coffeeName;
      _priceController.text = t.price.toString();
      _locationController.text = t.location ?? '';
      _noteController.text = t.note ?? '';
      _selectedDate = t.date;
      _selectedCategory = t.category;

      _locationLat = t.locationLat;
      _locationLng = t.locationLng;
      _locationSource = t.locationSource;
      _coffeeshopId = t.coffeeshopId;
      _source = t.source;
      _transactionTime = t.transactionTime;
    }
  }

  @override
  void dispose() {
    _coffeeNameController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _save() async {
    final priceText = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    final priceVal = int.tryParse(priceText) ?? 0;

    if (priceVal <= 0) {
      setState(() => _priceError = 'Harga wajib diisi dan harus positif');
      return;
    } else {
      setState(() => _priceError = null);
    }

    if (!_formKey.currentState!.validate()) return;

    final provider = ref.read(transactionProvider.notifier);
    final transaction = CoffeeTransaction(
      id: isEditing ? widget.editTransaction!.id : const Uuid().v4(),
      coffeeName: _coffeeNameController.text.trim(),
      price: priceVal,
      date: _selectedDate,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      category: _selectedCategory,
      createdAt: isEditing ? widget.editTransaction!.createdAt : DateTime.now(),
      locationLat: _locationLat,
      locationLng: _locationLng,
      locationSource: _locationSource,
      coffeeshopId: _coffeeshopId,
      source: _source,
      transactionTime: _transactionTime,
    );

    try {
      if (isEditing) {
        await provider.updateTransaction(transaction);
      } else {
        await provider.addTransaction(transaction);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Gagal menyimpan transaksi. Coba lagi.'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    if (!mounted) return;

    // Show budget warning if applicable
    final warning = ref.read(transactionProvider).getBudgetWarning();
    if (warning != null && !isEditing) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(warning),
          backgroundColor: warning.contains('terlampaui')
              ? AppColors.danger
              : AppColors.warning,
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Transaksi' : 'Tambah Transaksi'),
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
        child: Column(
          children: [
            // Header Image Area
            Container(
              width: double.infinity,
              height: 160,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6F4E37), Color(0xFF3C2415)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(Icons.coffee_rounded,
                          size: 200, color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          isEditing
                              ? 'Edit Transaksi Kopi'
                              : 'Catat Pengeluaran Kopi',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Isi detail pembelian kopi kamu',
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Padding(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category Selection
                    Text(
                      'Kategori',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _categories.length,
                        separatorBuilder: (context, a) =>
                            const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final cat = _categories[index];
                          final isSelected = cat['name'] == _selectedCategory;
                          return GestureDetector(
                            onTap: () =>
                                setState(() => _selectedCategory = cat['name']),
                            child: Column(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.secondary,
                                    borderRadius: BorderRadius.circular(14),
                                    border: isSelected
                                        ? Border.all(
                                            color: AppColors.primary, width: 2)
                                        : null,
                                  ),
                                  child: Icon(
                                    cat['icon'],
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.primary,
                                    size: 22,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  cat['name'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Coffee Name
                    _buildLabel('Nama Kopi *'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _coffeeNameController,
                      decoration: _inputDecor(
                        hint: 'Contoh: Kopi Susu Gula Aren',
                        icon: Icons.coffee_rounded,
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Nama kopi wajib diisi'
                          : null,
                    ),

                    const SizedBox(height: 16),

                    // Price using PriceInputField
                    PriceInputField(
                      controller: _priceController,
                      initialValue:
                          isEditing ? widget.editTransaction!.price : null,
                      label: 'Harga *',
                      hint: 'Rp 25.000',
                      errorText: _priceError,
                    ),

                    const SizedBox(height: 16),

                    // Date Picker
                    _buildLabel('Tanggal'),
                    const SizedBox(height: 6),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: _inputDecor(
                          hint: '',
                          icon: Icons.calendar_today_outlined,
                        ),
                        child: Text(
                          DateFormat('dd MMMM yyyy', 'id')
                              .format(_selectedDate),
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Location
                    _buildLabel('Lokasi (opsional)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _locationController,
                      decoration: _inputDecor(
                        hint: 'Contoh: Kopi Kenangan',
                        icon: Icons.location_on_outlined,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Note
                    _buildLabel('Catatan (opsional)'),
                    const SizedBox(height: 6),
                    TextFormField(
                      controller: _noteController,
                      decoration: _inputDecor(
                        hint: 'Contoh: Extra shot',
                        icon: Icons.note_outlined,
                      ),
                      maxLines: 2,
                    ),

                    const SizedBox(height: 28),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: Icon(isEditing ? Icons.check : Icons.add_rounded,
                            size: 20),
                        label: Text(
                          isEditing ? 'Simpan Perubahan' : 'Simpan Transaksi',
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  InputDecoration _inputDecor({required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      fillColor: Colors.white,
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.divider),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }
}
