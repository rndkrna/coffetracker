import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_shadows.dart';
import '../../../app/constants/app_spacing.dart';

enum SkeletonType { transaction, recommendation }

// ─── Base skeleton ────────────────────────────────────────────────────────

class LoadingSkeleton extends StatefulWidget {
  const LoadingSkeleton({
    super.key,
    this.width,
    this.height = 16,
    this.radius,
    this.isCircle = false,
  });

  final double? width;
  final double height;
  final double? radius;
  final bool isCircle;

  @override
  State<LoadingSkeleton> createState() => _LoadingSkeletonState();
}

class _LoadingSkeletonState extends State<LoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this)
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _anim,
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: AppColors.warmBeige,
          borderRadius: widget.isCircle
              ? BorderRadius.circular(widget.height / 2)
              : BorderRadius.circular(widget.radius ?? AppRadius.sm),
          shape: widget.isCircle ? BoxShape.circle : BoxShape.rectangle,
        ),
      ),
    );
  }
}

// ─── Transaction card skeleton ────────────────────────────────────────────

class TransactionCardSkeleton extends StatelessWidget {
  const TransactionCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.mdBR,
        boxShadow: AppShadows.subtle,
      ),
      child: const Row(
        children: [
          LoadingSkeleton(width: 44, height: 44, radius: 12),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingSkeleton(height: 14, radius: 6),
                SizedBox(height: AppSpacing.xs),
                LoadingSkeleton(width: 120, height: 11, radius: 4),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.md),
          LoadingSkeleton(width: 70, height: 28, radius: 8),
        ],
      ),
    );
  }
}

// ─── Recommendation card skeleton ─────────────────────────────────────────

class RecommendationCardSkeleton extends StatelessWidget {
  const RecommendationCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.lgBR,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LoadingSkeleton(width: double.infinity, height: 180, radius: 0),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LoadingSkeleton(width: 200, height: 18, radius: 6),
                SizedBox(height: AppSpacing.xs),
                LoadingSkeleton(width: 140, height: 13, radius: 4),
                SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    LoadingSkeleton(width: 80, height: 28, radius: 14),
                    SizedBox(width: AppSpacing.sm),
                    LoadingSkeleton(width: 80, height: 28, radius: 14),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Loading list ─────────────────────────────────────────────────────────

class LoadingListSkeleton extends StatelessWidget {
  const LoadingListSkeleton({
    super.key,
    this.count = 4,
    this.type = SkeletonType.transaction,
  });

  final int count;
  final SkeletonType type;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(count, (_) {
        return switch (type) {
          SkeletonType.transaction => const TransactionCardSkeleton(),
          SkeletonType.recommendation => const RecommendationCardSkeleton(),
        };
      }),
    );
  }
}
