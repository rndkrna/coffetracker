import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

/// Item data untuk chip
class FilterChipItem {
  const FilterChipItem({
    required this.label,
    required this.value,
    this.icon,
  });
  final String label;
  final String value;
  final IconData? icon;
}

// ─── Single-select chip group ──────────────────────────────────────────────

class FilterChipGroup extends StatelessWidget {
  const FilterChipGroup({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.onSelected,
    this.scrollable = true,
    this.wrap = false,
  });

  final List<FilterChipItem> items;
  final String? selectedValue;
  final void Function(String) onSelected;
  final bool scrollable;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final chips = items.map((item) => _chip(item)).toList();

    if (wrap) {
      return Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: chips,
      );
    }
    if (scrollable) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: chips
              .map((c) =>
                  Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: c))
              .toList(),
        ),
      );
    }
    return Row(
      children: chips
          .map((c) =>
              Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: c))
          .toList(),
    );
  }

  Widget _chip(FilterChipItem item) {
    final isSelected = selectedValue == item.value;
    return GestureDetector(
      onTap: () => onSelected(item.value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md, vertical: AppSpacing.sm),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.cream,
          borderRadius: AppRadius.inputBR,
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (item.icon != null) ...[
              Icon(item.icon,
                  size: 14,
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary),
              const SizedBox(width: 4),
            ],
            Text(
              item.label,
              style: AppTypography.bodySmall(
                color:
                    isSelected ? Colors.white : AppColors.textSecondary,
              ).copyWith(
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Multi-select chip group ───────────────────────────────────────────────

class MultiFilterChipGroup extends StatelessWidget {
  const MultiFilterChipGroup({
    super.key,
    required this.items,
    required this.selectedValues,
    required this.onToggle,
    this.wrap = true,
  });

  final List<FilterChipItem> items;
  final List<String> selectedValues;
  final void Function(String) onToggle;
  final bool wrap;

  @override
  Widget build(BuildContext context) {
    final chips = items.map((item) {
      final isSelected = selectedValues.contains(item.value);
      return GestureDetector(
        onTap: () => onToggle(item.value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : AppColors.cream,
            borderRadius: AppRadius.inputBR,
            border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (item.icon != null) ...[
                Icon(item.icon,
                    size: 14,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textSecondary),
                const SizedBox(width: 4),
              ],
              Text(
                item.label,
                style: AppTypography.bodySmall(
                  color: isSelected
                      ? Colors.white
                      : AppColors.textSecondary,
                ).copyWith(
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.w400),
              ),
            ],
          ),
        ),
      );
    }).toList();

    if (wrap) {
      return Wrap(
          spacing: AppSpacing.sm, runSpacing: AppSpacing.sm, children: chips);
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: chips
            .map((c) =>
                Padding(padding: const EdgeInsets.only(right: AppSpacing.sm), child: c))
            .toList(),
      ),
    );
  }
}
