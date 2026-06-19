import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/constants/app_typography.dart';
import '../buttons/primary_button.dart';

/// State view untuk kondisi offline.
///
/// Menampilkan ikon cloud, pesan offline, dan opsi retry.
/// Wireframe ref: Section 6.3 — Offline State
class OfflineStateView extends StatelessWidget {
  const OfflineStateView({
    super.key,
    this.message,
    this.subtitle,
    this.onRetry,
    this.compact = false,
  });

  final String? message;
  final String? subtitle;
  final VoidCallback? onRetry;
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
                Icons.cloud_off_rounded,
                size: compact ? 36.0 : 48.0,
                color: AppColors.info,
              ),
            ),
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            Text(
              message ?? AppStrings.errorOffline,
              textAlign: TextAlign.center,
              style: AppTypography.heading3(),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              subtitle ??
                  'Transaksi tersimpan secara lokal.\n'
                      'Beberapa hasil menggunakan data cache terakhir.',
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall(),
            ),
            if (onRetry != null) ...[
              SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
              PrimaryButton(
                label: AppStrings.retry,
                onPressed: onRetry,
                width: 160,
                height: 44,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
