import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_shadows.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_strings.dart';
import '../../../app/constants/app_typography.dart';

class BudgetSummaryCard extends StatelessWidget {
  const BudgetSummaryCard({
    super.key,
    required this.spent,
    required this.budget,
    this.onTap,
  });

  final int spent;
  final int budget;
  final VoidCallback? onTap;

  static final _fmt = NumberFormat.currency(
      locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  double get _pct =>
      budget > 0 ? (spent / budget).clamp(0.0, 1.0) : 0.0;
  int get _remaining => (budget - spent).clamp(0, budget > 0 ? budget : 0);

  Color get _progressColor {
    if (_pct >= 1.0) return AppColors.error;
    if (_pct >= 0.8) return AppColors.warning;
    return AppColors.primary;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: AppRadius.lgBR,
          boxShadow: AppShadows.subtle,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.8),
                    borderRadius: AppRadius.smBR,
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(AppStrings.homeBudgetTitle,
                      style: AppTypography.label(color: AppColors.primary)),
                ),
                if (onTap != null)
                  const Icon(Icons.chevron_right_rounded,
                      size: 16, color: AppColors.secondary),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(_fmt.format(spent),
                    style: AppTypography.priceHero(color: AppColors.primary)),
                if (budget > 0)
                  Text(' / ${_fmt.format(budget)}',
                      style: AppTypography.bodySmall(
                          color: AppColors.secondary)),
              ],
            ),
            if (budget > 0) ...[
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: AppRadius.smBR,
                child: LinearProgressIndicator(
                  value: _pct,
                  minHeight: 8,
                  backgroundColor:
                      AppColors.surface.withValues(alpha: 0.7),
                  valueColor:
                      AlwaysStoppedAnimation<Color>(_progressColor),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        _pct >= 0.8
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline_rounded,
                        size: 13,
                        color: _progressColor,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${(_pct * 100).toStringAsFixed(0)}% terpakai',
                        style: AppTypography.caption(color: AppColors.primary)
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Text(
                    '${AppStrings.homeRemaining}: ${_fmt.format(_remaining)}',
                    style: AppTypography.caption(color: AppColors.primary)
                        .copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: AppSpacing.sm),
              Text('Belum ada budget — tap untuk mengatur',
                  style:
                      AppTypography.caption(color: AppColors.secondary)),
            ],
          ],
        ),
      ),
    );
  }
}
