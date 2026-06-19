import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_typography.dart';

/// Badge untuk menampilkan rating bintang.
/// Contoh: ★ 4.7
class RatingBadge extends StatelessWidget {
  const RatingBadge({
    super.key,
    required this.rating,
    this.compact = false,
  });

  final double rating;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 6 : 8,
        vertical: compact ? 2 : 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: AppRadius.smBR,
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.star_rounded,
            size: compact ? 12 : 14,
            color: AppColors.caramel,
          ),
          const SizedBox(width: 2),
          Text(
            rating.toStringAsFixed(1),
            style: (compact
                    ? AppTypography.caption(color: AppColors.textPrimary)
                    : AppTypography.label(color: AppColors.textPrimary))
                .copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
