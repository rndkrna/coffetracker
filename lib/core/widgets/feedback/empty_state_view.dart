import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/constants/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/ghost_button.dart';

// ─── Generic empty state ──────────────────────────────────────────────────

class EmptyStateView extends StatelessWidget {
  const EmptyStateView({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.primaryActionLabel,
    this.onPrimaryAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
    this.iconColor,
    this.iconSize = 64,
    this.compact = false,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? primaryActionLabel;
  final VoidCallback? onPrimaryAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;
  final Color? iconColor;
  final double iconSize;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: compact ? AppSpacing.lg : AppSpacing.xl,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 72.0 : 96.0,
              height: compact ? 72.0 : 96.0,
              decoration: const BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: compact ? 36.0 : iconSize,
                color: iconColor ?? AppColors.border,
              ),
            ),
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            Text(title,
                textAlign: TextAlign.center,
                style: AppTypography.heading3()),
            if (subtitle != null) ...[
              SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
              Text(subtitle!,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodySmall()),
            ],
            if (primaryActionLabel != null) ...[
              SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
              PrimaryButton(
                label: primaryActionLabel!,
                onPressed: onPrimaryAction,
                width: 200,
                height: 44,
              ),
            ],
            if (secondaryActionLabel != null) ...[
              const SizedBox(height: AppSpacing.sm),
              GhostButton(
                label: secondaryActionLabel!,
                onPressed: onSecondaryAction,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ─── Rekomendasi empty state dengan relaksasi kriteria ────────────────────

class EmptyRecommendationState extends StatelessWidget {
  const EmptyRecommendationState({
    super.key,
    this.message,
    this.alternativeText,
    this.onExpandRadius,
    this.onRaiseBudget,
    this.onAllowSimilar,
    this.onChangePreference,
    this.onGeneralReco,
  });

  final String? message;
  final String? alternativeText;
  final VoidCallback? onExpandRadius;
  final VoidCallback? onRaiseBudget;
  final VoidCallback? onAllowSimilar;
  final VoidCallback? onChangePreference;
  final VoidCallback? onGeneralReco;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: const BoxDecoration(
              color: AppColors.cream,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.coffee_outlined,
                size: 40, color: AppColors.border),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(AppStrings.emptyRecommendations,
              textAlign: TextAlign.center,
              style: AppTypography.heading3()),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(message!,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall()),
          ],
          const SizedBox(height: AppSpacing.lg),
          _actionTile(
              icon: Icons.zoom_out_map_rounded,
              label: 'Perluas jarak',
              onTap: onExpandRadius),
          _actionTile(
              icon: Icons.trending_up_rounded,
              label: 'Naikkan anggaran',
              onTap: onRaiseBudget),
          _actionTile(
              icon: Icons.coffee_rounded,
              label: 'Izinkan menu serupa',
              onTap: onAllowSimilar),
          _actionTile(
              icon: Icons.tune_rounded,
              label: 'Ubah preferensi',
              onTap: onChangePreference),
          _actionTile(
              icon: Icons.star_outline_rounded,
              label: 'Lihat rekomendasi umum',
              onTap: onGeneralReco),
          if (alternativeText != null) ...[
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppRadius.mdBR,
                border: Border.all(color: AppColors.border),
              ),
              child: Text(alternativeText!,
                  textAlign: TextAlign.center,
                  style:
                      AppTypography.bodySmall(color: AppColors.textPrimary)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _actionTile(
      {required IconData icon,
      required String label,
      VoidCallback? onTap}) {
    if (onTap == null) return const SizedBox.shrink();
    return ListTile(
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: AppRadius.smBR,
        ),
        child: Icon(icon, size: 18, color: AppColors.primary),
      ),
      title: Text(label, style: AppTypography.bodyRegular()),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textSecondary, size: 20),
      onTap: onTap,
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}
