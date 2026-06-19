import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

/// Progress header untuk guided multi-step flow.
///
/// Menampilkan: [‹ Kembali] [Title] [currentStep/totalSteps]
/// plus progress bar visual.
///
/// Digunakan di Guided Menu Search 3 langkah.
class StepProgressHeader extends StatelessWidget {
  const StepProgressHeader({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.title = 'Cari Menu',
    this.onBack,
  });

  final int currentStep;
  final int totalSteps;
  final String title;
  final VoidCallback? onBack;

  double get _progress => totalSteps > 0 ? currentStep / totalSteps : 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ─── Top bar ────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
          child: Row(
            children: [
              if (onBack != null)
                IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_back_ios_rounded, size: 20),
                  color: AppColors.textPrimary,
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              const Spacer(),
              Text(title, style: AppTypography.appBarTitle()),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$currentStep/$totalSteps',
                  style: AppTypography.label(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ),

        // ─── Progress bar ───────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 4,
              backgroundColor: AppColors.warmBeige,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
