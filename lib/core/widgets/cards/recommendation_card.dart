import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_shadows.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';
import '../badges/availability_badge.dart';

class RecommendationCard extends StatelessWidget {
  const RecommendationCard({
    super.key,
    required this.menuName,
    required this.shopName,
    required this.price,
    required this.matchScore,
    required this.availabilityStatus,
    this.distanceMeters,
    this.shopRating,
    this.imageUrl,
    this.reasons = const [],
    this.availabilityVerifiedAt,
    this.isTopPick = false,
    this.onDetail,
    this.onOpenMaps,
    this.onSave,
    this.onRecord,
    this.isSaved = false,
  });

  final String menuName;
  final String shopName;
  final int price;
  final double matchScore;
  final AvailabilityStatus availabilityStatus;
  final int? distanceMeters;
  final double? shopRating;
  final String? imageUrl;
  final List<String> reasons;
  final DateTime? availabilityVerifiedAt;
  final bool isTopPick;
  final VoidCallback? onDetail;
  final VoidCallback? onOpenMaps;
  final VoidCallback? onSave;
  final VoidCallback? onRecord;
  final bool isSaved;

  static final _fmt = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  String get _distance {
    if (distanceMeters == null) return '';
    return distanceMeters! < 1000
        ? '${distanceMeters}m dari lokasi kamu'
        : '${(distanceMeters! / 1000).toStringAsFixed(1)} km dari lokasi kamu';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgBR,
        boxShadow: AppShadows.card,
        border: isTopPick
            ? Border.all(
                color: AppColors.primary.withValues(alpha: 0.3))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isTopPick)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                  vertical: 6, horizontal: AppSpacing.md),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(kRadiusCard)),
              ),
              child: Text('✨ Pilihan Terbaik',
                  style: AppTypography.caption(color: Colors.white)
                      .copyWith(fontWeight: FontWeight.w700)),
            ),
          _buildImage(),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(menuName,
                              style: AppTypography.heading3(),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          const SizedBox(height: 2),
                          Text(shopName,
                              style: AppTypography.bodySmall(
                                  color: AppColors.secondary),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    if (onSave != null)
                      GestureDetector(
                        onTap: onSave,
                        child: Icon(
                          isSaved
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isSaved
                              ? AppColors.primary
                              : AppColors.textSecondary,
                          size: 22,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Text(_fmt.format(price),
                        style: AppTypography.priceMedium()),
                    if (_distance.isNotEmpty) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(_distance,
                            style: AppTypography.bodySmall(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    _matchBadge(),
                    AvailabilityBadge(
                      status: availabilityStatus,
                      verifiedAt: availabilityVerifiedAt,
                      compact: true,
                    ),
                  ],
                ),
                if (reasons.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.md),
                  const Divider(height: 1),
                  const SizedBox(height: AppSpacing.sm),
                  Text('Kenapa cocok untukmu?',
                      style: AppTypography.label()),
                  const SizedBox(height: AppSpacing.xs),
                  ...reasons.map((r) => Padding(
                        padding: const EdgeInsets.only(
                            bottom: AppSpacing.xxs),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_rounded,
                                size: 14, color: AppColors.success),
                            const SizedBox(width: 4),
                            Expanded(
                                child: Text(r,
                                    style:
                                        AppTypography.bodySmall())),
                          ],
                        ),
                      )),
                ],
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                        child: _actionBtn(
                            'Detail',
                            Icons.info_outline_rounded,
                            onDetail,
                            true)),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                        child: _actionBtn(
                            'Maps',
                            Icons.map_outlined,
                            onOpenMaps,
                            true)),
                    if (onRecord != null) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                          child: _actionBtn(
                              'Catat',
                              Icons.add_rounded,
                              onRecord,
                              false)),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage() {
    final radius = isTopPick
        ? BorderRadius.zero
        : const BorderRadius.vertical(
            top: Radius.circular(kRadiusCard));
    return ClipRRect(
      borderRadius: radius,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? Image.network(imageUrl!,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _placeholder())
          : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: AppColors.cream,
      child: const Icon(Icons.coffee_rounded,
          color: AppColors.border, size: 56),
    );
  }

  Widget _matchBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: const BoxDecoration(
          color: AppColors.primary, borderRadius: AppRadius.smBR),
      child: Text('${(matchScore * 100).round()}% cocok',
          style: AppTypography.caption(color: Colors.white)
              .copyWith(fontWeight: FontWeight.w700)),
    );
  }

  Widget _actionBtn(String label, IconData icon, VoidCallback? onTap,
      bool outlined) {
    final shape = RoundedRectangleBorder(borderRadius: AppRadius.smBR);
    final ts = AppTypography.buttonSmall(color: AppColors.primary);
    if (outlined) {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 15),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(0, 36),
          padding: const EdgeInsets.symmetric(horizontal: 8),
          textStyle: ts,
          side: const BorderSide(color: AppColors.border),
          shape: shape,
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, size: 15),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(0, 36),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: AppTypography.buttonSmall(),
        shape: shape,
      ),
    );
  }
}
