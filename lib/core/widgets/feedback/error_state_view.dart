import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/constants/app_typography.dart';
import '../buttons/primary_button.dart';

class ErrorStateView extends StatelessWidget {
  const ErrorStateView({
    super.key,
    this.message = AppStrings.errorGeneral,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
    this.compact = false,
  });

  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(compact ? AppSpacing.md : AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: compact ? 60.0 : 80.0,
              height: compact ? 60.0 : 80.0,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  size: compact ? 30.0 : 40.0, color: AppColors.error),
            ),
            SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
            Text('Terjadi Kesalahan',
                textAlign: TextAlign.center,
                style: AppTypography.heading3()),
            const SizedBox(height: AppSpacing.xs),
            Text(message,
                textAlign: TextAlign.center,
                style: AppTypography.bodySmall()),
            if (onRetry != null) ...[
              SizedBox(
                  height: compact ? AppSpacing.md : AppSpacing.lg),
              PrimaryButton(
                label: AppStrings.retry,
                onPressed: onRetry,
                icon: Icons.refresh_rounded,
                width: 180,
                height: 44,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

