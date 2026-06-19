import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_shadows.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

class CoffeeBottomNav extends StatelessWidget {
  const CoffeeBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final void Function(int) onTap;

  static const _labels = [
    'Home',
    'Transaksi',
    'Cari Kedai',
    'Rekomendasi',
    'Profil',
  ];

  static const _activeIcons = [
    Icons.home_rounded,
    Icons.receipt_long_rounded,
    Icons.location_on_rounded,
    Icons.auto_awesome_rounded,
    Icons.person_rounded,
  ];

  static const _inactiveIcons = [
    Icons.home_outlined,
    Icons.receipt_long_outlined,
    Icons.location_on_outlined,
    Icons.auto_awesome_outlined,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.bottomNav,
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (i) => _buildItem(i)),
          ),
        ),
      ),
    );
  }

  Widget _buildItem(int index) {
    final isSelected = index == currentIndex;
    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: AppRadius.inputBR,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? _activeIcons[index] : _inactiveIcons[index],
              color: isSelected ? AppColors.primary : AppColors.textSecondary,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              _labels[index],
              style: isSelected
                  ? AppTypography.navLabelActive()
                  : AppTypography.navLabel(),
            ),
          ],
        ),
      ),
    );
  }
}
