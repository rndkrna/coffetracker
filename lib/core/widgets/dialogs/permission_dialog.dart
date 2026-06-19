import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/ghost_button.dart';

/// Dialog untuk meminta izin lokasi.
///
/// Menampilkan rationale mengapa izin diperlukan, tombol utama
/// untuk mengizinkan, dan opsi fallback (lokasi manual / nanti saja).
///
/// PRD ref: Section 2.2 — Permission Flow
/// Wireframe ref: Section 5.16 — Permission Location
class PermissionDialog extends StatelessWidget {
  const PermissionDialog({
    super.key,
    this.title = 'Izinkan Akses Lokasi',
    this.description =
        'Lokasi digunakan untuk mencari coffeeshop dan menu terdekat.',
    this.privacyNote =
        'Lokasi tidak dilacak terus-menerus dan hanya digunakan '
        'ketika fitur lokasi dibuka.',
    this.primaryLabel = 'Izinkan Lokasi',
    this.secondaryLabel = 'Masukkan Lokasi Manual',
    this.dismissLabel = 'Nanti Saja',
    this.onAllow,
    this.onManual,
    this.onDismiss,
    this.isPermanentlyDenied = false,
  });

  final String title;
  final String description;
  final String privacyNote;
  final String primaryLabel;
  final String secondaryLabel;
  final String dismissLabel;
  final VoidCallback? onAllow;
  final VoidCallback? onManual;
  final VoidCallback? onDismiss;

  /// Jika true, tampilkan copy "Buka Settings" daripada "Izinkan Lokasi"
  final bool isPermanentlyDenied;

  /// Menampilkan sebagai bottom sheet.
  static Future<void> show(
    BuildContext context, {
    VoidCallback? onAllow,
    VoidCallback? onManual,
    VoidCallback? onDismiss,
    bool isPermanentlyDenied = false,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isDismissible: true,
      builder: (_) => PermissionDialog(
        onAllow: onAllow,
        onManual: onManual,
        onDismiss: onDismiss,
        isPermanentlyDenied: isPermanentlyDenied,
        primaryLabel: isPermanentlyDenied ? 'Buka Settings' : 'Izinkan Lokasi',
        description: isPermanentlyDenied
            ? 'Izin lokasi diblokir. Buka Settings untuk mengaktifkan?'
            : 'Lokasi digunakan untuk mencari coffeeshop dan menu terdekat.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.lg, AppSpacing.lg, AppSpacing.lg + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.modal)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag indicator
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              color: AppColors.cream,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isPermanentlyDenied
                  ? Icons.settings_rounded
                  : Icons.location_on_outlined,
              size: 32,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Title
          Text(title, style: AppTypography.heading2(),
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),

          // Description
          Text(description, style: AppTypography.bodyRegular(),
              textAlign: TextAlign.center),
          const SizedBox(height: AppSpacing.sm),

          // Privacy note
          if (!isPermanentlyDenied) ...[
            Text(privacyNote,
                style: AppTypography.bodySmall(),
                textAlign: TextAlign.center),
            const SizedBox(height: AppSpacing.lg),
          ] else
            const SizedBox(height: AppSpacing.md),

          // Primary action
          PrimaryButton(
            label: primaryLabel,
            onPressed: () {
              Navigator.of(context).pop();
              onAllow?.call();
            },
          ),
          const SizedBox(height: AppSpacing.sm),

          // Secondary action
          GhostButton(
            label: secondaryLabel,
            onPressed: () {
              Navigator.of(context).pop();
              onManual?.call();
            },
          ),
          const SizedBox(height: AppSpacing.xs),

          // Dismiss
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onDismiss?.call();
            },
            child: Text(
              dismissLabel,
              style: AppTypography.bodySmall(color: AppColors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
