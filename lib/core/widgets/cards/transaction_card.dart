import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_shadows.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

class TransactionCard extends StatelessWidget {
  const TransactionCard({
    super.key,
    required this.coffeeName,
    required this.price,
    required this.date,
    this.location,
    this.category,
    this.source,
    this.onTap,
    this.onLongPress,
    this.trailing,
  });

  final String coffeeName;
  final int price;
  final DateTime date;
  final String? location;
  final String? category;
  final String? source;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final Widget? trailing;

  static final _priceFmt = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  static final _dateFmt = DateFormat('dd MMM yyyy', 'id_ID');

  String get _subtitle {
    final parts = <String>[];
    if (category != null && category!.isNotEmpty) parts.add(category!);
    parts.add(_dateFmt.format(date));
    if (location != null && location!.isNotEmpty) parts.add(location!);
    return parts.join(' • ');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: AppRadius.mdBR,
          boxShadow: AppShadows.subtle,
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppRadius.smBR,
              ),
              child: source == 'ocr'
                  ? const Icon(Icons.document_scanner_rounded,
                      color: AppColors.secondary, size: 20)
                  : const Icon(Icons.coffee_rounded,
                      color: AppColors.secondary, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    coffeeName,
                    style: AppTypography.bodyRegular()
                        .copyWith(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(_subtitle,
                      style: AppTypography.caption(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            trailing ??
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.08),
                    borderRadius: AppRadius.smBR,
                  ),
                  child: Text(_priceFmt.format(price),
                      style: AppTypography.priceSmall(color: AppColors.error)),
                ),
          ],
        ),
      ),
    );
  }
}
