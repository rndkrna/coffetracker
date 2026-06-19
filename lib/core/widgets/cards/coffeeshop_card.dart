import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_shadows.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

class CoffeeshopCard extends StatelessWidget {
  const CoffeeshopCard({
    super.key,
    required this.name,
    required this.rating,
    this.distanceMeters,
    this.priceRangeMin,
    this.priceRangeMax,
    this.imageUrl,
    this.moodTags = const [],
    this.facilities = const [],
    this.isOpen,
    this.onTap,
    this.onFavorite,
    this.isFavorite = false,
  });

  final String name;
  final double rating;
  final int? distanceMeters;
  final int? priceRangeMin;
  final int? priceRangeMax;
  final String? imageUrl;
  final List<String> moodTags;
  final List<String> facilities;
  final bool? isOpen;
  final VoidCallback? onTap;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  static final _fmt = NumberFormat.compactCurrency(
      locale: 'id_ID', symbol: 'Rp', decimalDigits: 0);

  String get _distance {
    if (distanceMeters == null) return '';
    return distanceMeters! < 1000
        ? '${distanceMeters}m'
        : '${(distanceMeters! / 1000).toStringAsFixed(1)} km';
  }

  String get _price {
    if (priceRangeMin == null && priceRangeMax == null) return '';
    if (priceRangeMin != null && priceRangeMax != null) {
      return '${_fmt.format(priceRangeMin)}–${_fmt.format(priceRangeMax)}';
    }
    return priceRangeMin != null
        ? 'ab ${_fmt.format(priceRangeMin)}'
        : 's/d ${_fmt.format(priceRangeMax)}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.lgBR,
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(name,
                            style: AppTypography.heading3(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      if (onFavorite != null)
                        GestureDetector(
                          onTap: onFavorite,
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorite
                                ? AppColors.error
                                : AppColors.textSecondary,
                            size: 20,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: AppSpacing.sm,
                    children: [
                      _pill(
                          '★ ${rating.toStringAsFixed(1)}',
                          AppColors.caramel),
                      if (_distance.isNotEmpty)
                        _pill(_distance, AppColors.info),
                      if (_price.isNotEmpty)
                        _pill(_price, AppColors.secondary),
                    ],
                  ),
                  if (isOpen != null) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isOpen!
                                ? AppColors.success
                                : AppColors.error,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOpen! ? 'Buka' : 'Tutup',
                          style: AppTypography.caption(
                                  color: isOpen!
                                      ? AppColors.success
                                      : AppColors.error)
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                  if (moodTags.isNotEmpty || facilities.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        ...moodTags.map((t) => _tag(t, AppColors.accent)),
                        ...facilities
                            .map((f) => _tag(f, AppColors.warmBeige)),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: OutlinedButton(
                      onPressed: onTap,
                      style: OutlinedButton.styleFrom(
                        minimumSize: Size.zero,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 12),
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                            borderRadius: AppRadius.smBR),
                      ),
                      child: Text('Lihat Kedai',
                          style: AppTypography.button(
                              color: AppColors.primary)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(
          top: Radius.circular(kRadiusCard)),
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(imageUrl!,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _imgPlaceholder())
          : _imgPlaceholder(),
    );
  }

  Widget _imgPlaceholder() {
    return Container(
      height: 160,
      width: double.infinity,
      color: AppColors.cream,
      child: const Icon(Icons.storefront_outlined,
          color: AppColors.border, size: 48),
    );
  }

  Widget _pill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.smBR,
      ),
      child: Text(label,
          style: AppTypography.caption(color: color)
              .copyWith(fontWeight: FontWeight.w600)),
    );
  }

  Widget _tag(String label, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration:
          BoxDecoration(color: bg, borderRadius: AppRadius.smBR),
      child: Text(label,
          style: AppTypography.caption(color: AppColors.textPrimary)),
    );
  }
}
