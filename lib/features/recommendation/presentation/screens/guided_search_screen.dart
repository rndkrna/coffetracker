import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../app/constants/app_colors.dart';
import '../../../../app/constants/app_routes.dart';
import '../../../../core/widgets/widgets.dart';
import '../../providers/recommendation_provider.dart';

class GuidedSearchScreen extends ConsumerStatefulWidget {
  const GuidedSearchScreen({super.key});

  @override
  ConsumerState<GuidedSearchScreen> createState() => _GuidedSearchScreenState();
}

class _GuidedSearchScreenState extends ConsumerState<GuidedSearchScreen> {
  int _currentStep = 1;

  // Step 1: Dasar
  String _drinkType = 'Coffee';
  String _flavor = 'Chocolate';
  String _temperature = 'Iced';

  // Step 2: Detail
  int _strength = 3;
  String _milkType = 'Oat Milk';
  int _sweetness = 3;

  // Step 3: Kondisi
  String _vibe = 'Nugas';
  double _budget = 50000;
  bool _openNow = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'Cari Menu Sendiri',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () {
            if (_currentStep > 1) {
              setState(() => _currentStep--);
            } else {
              context.pop();
            }
          },
        ),
      ),
      body: Column(
        children: [
          // Step Progress
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: [
                _buildStepIndicator(1, 'Dasar'),
                _buildStepDivider(),
                _buildStepIndicator(2, 'Detail'),
                _buildStepDivider(),
                _buildStepIndicator(3, 'Kondisi'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildCurrentStep(),
            ),
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: PrimaryButton(
              label: _currentStep < 3 ? 'Lanjut' : 'Temukan Rekomendasi',
              onPressed: () {
                if (_currentStep < 3) {
                  setState(() => _currentStep++);
                } else {
                  final results = ref.read(recommendationProvider.notifier).searchGuided(
                    drinkType: _drinkType,
                    flavor: _flavor,
                    temperature: _temperature,
                    strength: _strength,
                    milkType: _milkType,
                    sweetness: _sweetness,
                    vibe: _vibe,
                    budget: _budget,
                    openNow: _openNow,
                  );
                  context.push(AppRoutes.recommendationResults, extra: results);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(int step, String label) {
    final isActive = _currentStep >= step;
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.surface,
            shape: BoxShape.circle,
            border: isActive ? null : Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              step.toString(),
              style: GoogleFonts.poppins(
                color: isActive ? Colors.white : AppColors.textSecondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 10,
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildStepDivider() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16, left: 8, right: 8),
        color: AppColors.border,
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 1:
        return _buildStep1();
      case 2:
        return _buildStep2();
      case 3:
        return _buildStep3();
      default:
        return const SizedBox();
    }
  }

  Widget _buildStep1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Jenis Minuman', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ['Coffee', 'Non-Coffee', 'Tea', 'Pastry'].map((e) => _buildChoiceChip(e, _drinkType, (v) => setState(() => _drinkType = v))).toList(),
        ),
        const SizedBox(height: 24),

        Text('Rasa Dominan', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ['Chocolate', 'Fruity', 'Nutty', 'Caramel', 'Floral', 'Vanilla']
              .map((e) => _buildChoiceChip(e, _flavor, (v) => setState(() => _flavor = v))).toList(),
        ),
        const SizedBox(height: 24),

        Text('Suhu', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildChoiceChip('Hot', _temperature, (v) => setState(() => _temperature = v), isExpanded: true),
            const SizedBox(width: 16),
            _buildChoiceChip('Iced', _temperature, (v) => setState(() => _temperature = v), isExpanded: true),
          ],
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Kekuatan Kopi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Slider(
          value: _strength.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: AppColors.primary,
          label: _strength == 1 ? 'Sangat Ringan' : _strength == 5 ? 'Sangat Kuat' : 'Sedang',
          onChanged: (v) => setState(() => _strength = v.toInt()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Ringan', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            Text('Kuat', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 24),

        Text('Tingkat Manis', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Slider(
          value: _sweetness.toDouble(),
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: AppColors.secondary,
          label: _sweetness == 1 ? 'Pahit' : _sweetness == 5 ? 'Sangat Manis' : 'Sedang',
          onChanged: (v) => setState(() => _sweetness = v.toInt()),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Pahit', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
            Text('Manis', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 24),

        Text('Pilihan Susu', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ['Regular', 'Oat Milk', 'Almond Milk', 'Soy Milk', 'No Milk']
              .map((e) => _buildChoiceChip(e, _milkType, (v) => setState(() => _milkType = v))).toList(),
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Budget Maksimal', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 8),
        Text('Rp ${_budget.toInt()}', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Slider(
          value: _budget,
          min: 15000,
          max: 100000,
          divisions: 17,
          activeColor: AppColors.primary,
          onChanged: (v) => setState(() => _budget = v),
        ),
        const SizedBox(height: 24),

        Text('Mood / Kondisi', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: ['Nugas', 'Nongkrong', 'Meeting', 'Me Time', 'Date']
              .map((e) => _buildChoiceChip(e, _vibe, (v) => setState(() => _vibe = v))).toList(),
        ),
        const SizedBox(height: 32),

        SwitchListTile(
          title: Text('Buka Sekarang', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          subtitle: Text('Hanya tampilkan kedai yang sedang buka', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
          value: _openNow,
          activeTrackColor: AppColors.primary.withAlpha(100),
          activeThumbColor: AppColors.primary,
          onChanged: (v) => setState(() => _openNow = v),
          contentPadding: EdgeInsets.zero,
        ),
      ],
    );
  }

  Widget _buildChoiceChip(String label, String groupValue, Function(String) onSelect, {bool isExpanded = false}) {
    final isSelected = label == groupValue;
    final child = GestureDetector(
      onTap: () => onSelect(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : AppColors.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
    
    if (isExpanded) {
      return Expanded(child: child);
    }
    return child;
  }
}
