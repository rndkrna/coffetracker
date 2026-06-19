import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height = 52,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cream,
          foregroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.warmBeige,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppRadius.inputBR,
            side: const BorderSide(color: AppColors.border),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                    color: AppColors.primary, strokeWidth: 2.5),
              )
            : icon != null
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, size: 20),
                      const SizedBox(width: AppSpacing.sm),
                      Text(label,
                          style: AppTypography.button(color: AppColors.primary)),
                    ],
                  )
                : Text(label,
                    style: AppTypography.button(color: AppColors.primary)),
      ),
    );
  }
}
