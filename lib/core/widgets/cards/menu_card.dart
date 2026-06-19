import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_shadows.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';
import '../badges/availability_badge.dart';
import '../badges/price_tag.dart';

/// Card untuk menampilkan menu item kopi.
///
/// Digunakan di detail coffeeshop dan hasil rekomendasi.
/// Menampilkan: nama menu, harga, status ketersediaan, dan aksi.
class MenuCard extends StatelessWidget {
  const MenuCard({
    super.key,
    required this.name,
    required this.price,
    this.coffeeshopName,
    this.description,
    this.imageUrl,
    this.category,
    this.temperature,
    this.availabilityStatus,
    this.verifiedAt,
    this.onTap,
    this.trailing,
    this.compact = false,
  });

  final String name;
  final int price;
  final String? coffeeshopName;
  final String? description;
  final String? imageUrl;
  final String? category;
  final String? temperature;
  final AvailabilityStatus? availabilityStatus;
  final DateTime? verifiedAt;
  final VoidCallback? onTap;
  final Widget? trailing;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(compact ? AppSpacing.s12 : AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: compact ? AppRadius.mdBR : AppRadius.lgBR,
          boxShadow: AppShadows.subtle,
          border: Border.all(color: AppColors.border.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            // ─── Thumbnail ────────────────────────────────────────────
            if (imageUrl != null && !compact) ...[
              ClipRRect(
                borderRadius: AppRadius.smBR,
                child: Container(
                  width: 64,
                  height: 64,
                  color: AppColors.cream,
                  child: imageUrl!.startsWith('http')
                      ? Image.network(
                          imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.coffee_rounded,
                            color: AppColors.accent,
                            size: 28,
                          ),
                        )
                      : const Icon(
                          Icons.coffee_rounded,
                          color: AppColors.accent,
                          size: 28,
                        ),
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
            ],

            // ─── Ikon kopi (compact) ──────────────────────────────────
            if (compact) ...[
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: AppColors.cream,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _categoryIcon,
                  size: 18,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.s12),
            ],

            // ─── Info ─────────────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    style: compact
                        ? AppTypography.bodyRegular()
                            .copyWith(fontWeight: FontWeight.w600)
                        : AppTypography.bodyLarge()
                            .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (coffeeshopName != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      coffeeshopName!,
                      style: AppTypography.caption(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (description != null && !compact) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      description!,
                      style: AppTypography.bodySmall(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      PriceTag(price: price, compact: true),
                      if (temperature != null) ...[
                        const SizedBox(width: AppSpacing.sm),
                        _tempChip(temperature!),
                      ],
                    ],
                  ),
                  if (availabilityStatus != null && !compact) ...[
                    const SizedBox(height: AppSpacing.xs),
                    AvailabilityBadge(
                      status: availabilityStatus!,
                      verifiedAt: verifiedAt,
                      compact: true,
                    ),
                  ],
                ],
              ),
            ),

            // ─── Trailing / Availability compact ──────────────────────
            if (trailing != null) trailing!
            else if (availabilityStatus != null && compact)
              Padding(
                padding: const EdgeInsets.only(left: AppSpacing.sm),
                child: AvailabilityBadge(
                  status: availabilityStatus!,
                  compact: true,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData get _categoryIcon {
    switch (category?.toLowerCase()) {
      case 'coffee':
        return Icons.coffee_rounded;
      case 'non_coffee':
      case 'non-coffee':
        return Icons.local_cafe_outlined;
      case 'food':
        return Icons.restaurant_rounded;
      default:
        return Icons.coffee_rounded;
    }
  }

  Widget _tempChip(String temp) {
    final isHot = temp.toLowerCase() == 'hot' || temp.toLowerCase() == 'panas';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isHot
            ? AppColors.caramel.withValues(alpha: 0.12)
            : AppColors.info.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isHot ? '☕ Panas' : '🧊 Dingin',
        style: AppTypography.caption(
          color: isHot ? AppColors.caramel : AppColors.info,
        ),
      ),
    );
  }
}
