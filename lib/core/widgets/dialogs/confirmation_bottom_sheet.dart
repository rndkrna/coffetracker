import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/constants/app_typography.dart';
import '../buttons/primary_button.dart';
import '../buttons/secondary_button.dart';

// ─── Generic confirmation sheet ───────────────────────────────────────────

Future<bool> showConfirmationBottomSheet({
  required BuildContext context,
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = AppStrings.cancel,
  Color? confirmColor,
  IconData? icon,
  bool isDanger = false,
}) async {
  final result = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => _ConfirmSheet(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      confirmColor: confirmColor,
      icon: icon,
      isDanger: isDanger,
    ),
  );
  return result ?? false;
}

class _ConfirmSheet extends StatelessWidget {
  const _ConfirmSheet({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.cancelLabel,
    this.confirmColor,
    this.icon,
    this.isDanger = false,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;
  final IconData? icon;
  final bool isDanger;

  @override
  Widget build(BuildContext context) {
    final btnColor =
        confirmColor ?? (isDanger ? AppColors.error : AppColors.primary);
    final bottom = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.modalBR,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: AppRadius.smBR,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (icon != null) ...[
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: btnColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: btnColor, size: 28),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(title, style: AppTypography.heading2()),
          const SizedBox(height: AppSpacing.sm),
          Text(message,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall()),
          const SizedBox(height: AppSpacing.lg),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: btnColor,
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.inputBR),
            ),
            child: Text(confirmLabel, style: AppTypography.button()),
          ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: cancelLabel,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}

// ─── Location permission sheet ────────────────────────────────────────────

enum LocationPermissionAction { allow, manual, later, settings }

Future<LocationPermissionAction> showLocationPermissionSheet({
  required BuildContext context,
  required bool isPermanentlyDenied,
}) async {
  final result = await showModalBottomSheet<LocationPermissionAction>(
    context: context,
    backgroundColor: Colors.transparent,
    isDismissible: false,
    builder: (_) =>
        _LocationPermSheet(isPermanentlyDenied: isPermanentlyDenied),
  );
  return result ?? LocationPermissionAction.later;
}

class _LocationPermSheet extends StatelessWidget {
  const _LocationPermSheet({required this.isPermanentlyDenied});
  final bool isPermanentlyDenied;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewPadding.bottom;
    return Container(
      padding: EdgeInsets.fromLTRB(
          AppSpacing.lg, AppSpacing.md, AppSpacing.lg, AppSpacing.lg + bottom),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.modalBR,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: AppRadius.smBR,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.location_on_rounded,
                color: AppColors.primary, size: 32),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            isPermanentlyDenied
                ? 'Izin Lokasi Diblokir'
                : 'Izinkan Akses Lokasi',
            style: AppTypography.heading2(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            isPermanentlyDenied
                ? 'Izin lokasi diblokir. Buka Settings untuk mengaktifkan.'
                : 'Lokasi digunakan untuk mencari coffeeshop dan menu terdekat.\n\nLokasi tidak dilacak terus-menerus.',
            textAlign: TextAlign.center,
            style: AppTypography.bodySmall(),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (isPermanentlyDenied)
            PrimaryButton(
              label: 'Buka Settings',
              onPressed: () => Navigator.pop(
                  context, LocationPermissionAction.settings),
              icon: Icons.settings_outlined,
            )
          else
            PrimaryButton(
              label: 'Izinkan Lokasi',
              onPressed: () => Navigator.pop(
                  context, LocationPermissionAction.allow),
              icon: Icons.location_on_outlined,
            ),
          const SizedBox(height: AppSpacing.sm),
          SecondaryButton(
            label: 'Masukkan Lokasi Manual',
            onPressed: () =>
                Navigator.pop(context, LocationPermissionAction.manual),
          ),
          const SizedBox(height: AppSpacing.xs),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, LocationPermissionAction.later),
            child: Text('Nanti Saja',
                style: AppTypography.bodySmall(
                    color: AppColors.textSecondary)),
          ),
        ],
      ),
    );
  }
}
