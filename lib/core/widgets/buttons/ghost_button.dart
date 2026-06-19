import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

class GhostButton extends StatelessWidget {
  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.color,
    this.width,
    this.height = 44,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? color;
  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    final textColor = color ?? AppColors.primary;
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(horizontal: 16),
        ),
        child: icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: textColor),
                  const SizedBox(width: AppSpacing.xs),
                  Text(label, style: AppTypography.button(color: textColor)),
                ],
              )
            : Text(label, style: AppTypography.button(color: textColor)),
      ),
    );
  }
}
