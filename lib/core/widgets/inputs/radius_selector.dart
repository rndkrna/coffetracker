import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

/// Radius selector segmented control: 500m / 1km / 3km / 5km / 10km
///
/// Digunakan di Coffeeshop Finder dan Guided Menu Search (langkah 3).
class RadiusSelector extends StatelessWidget {
  const RadiusSelector({
    super.key,
    required this.selectedMeters,
    required this.onChanged,
    this.label = 'Radius',
    this.options = _defaultOptions,
  });

  final int selectedMeters;
  final ValueChanged<int> onChanged;
  final String label;
  final List<RadiusOption> options;

  static const List<RadiusOption> _defaultOptions = [
    RadiusOption(meters: 500, label: '500m'),
    RadiusOption(meters: 1000, label: '1 km'),
    RadiusOption(meters: 3000, label: '3 km'),
    RadiusOption(meters: 5000, label: '5 km'),
    RadiusOption(meters: 10000, label: '10 km'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppTypography.label()),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((option) {
              final isSelected = option.meters == selectedMeters;
              return Padding(
                padding: const EdgeInsets.only(right: AppSpacing.sm),
                child: _RadiusChip(
                  option: option,
                  isSelected: isSelected,
                  onTap: () => onChanged(option.meters),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RadiusChip extends StatelessWidget {
  const _RadiusChip({
    required this.option,
    required this.isSelected,
    required this.onTap,
  });

  final RadiusOption option;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: AppRadius.inputBR,
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Text(
          option.label,
          style: AppTypography.label(
            color: isSelected ? Colors.white : AppColors.textPrimary,
          ).copyWith(
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Model data untuk opsi radius.
class RadiusOption {
  const RadiusOption({required this.meters, required this.label});
  final int meters;
  final String label;
}
