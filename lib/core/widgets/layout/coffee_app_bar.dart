import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

class CoffeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CoffeeAppBar({
    super.key,
    this.title,
    this.titleWidget,
    this.centerTitle = true,
    this.leading,
    this.actions,
    this.showBackButton = true,
    this.onBack,
    this.subtitle,
    this.bottom,
    this.backgroundColor,
    this.elevation,
  });

  final String? title;
  final Widget? titleWidget;
  final bool centerTitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBack;
  final String? subtitle;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final double? elevation;

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 0.5,
      shadowColor: AppColors.shadowBrown,
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      leading: _buildLeading(context),
      title: titleWidget ??
          (title != null
              ? subtitle != null
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(title!, style: AppTypography.appBarTitle()),
                        Text(subtitle!,
                            style: AppTypography.caption(
                                color: AppColors.textSecondary)),
                      ],
                    )
                  : Text(title!, style: AppTypography.appBarTitle())
              : null),
      actions: actions,
      bottom: bottom,
    );
  }

  Widget? _buildLeading(BuildContext context) {
    if (leading != null) return leading;
    if (!showBackButton) return null;
    if (!Navigator.of(context).canPop()) return null;

    return IconButton(
      icon: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: AppRadius.smBR,
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            size: 13, color: AppColors.textPrimary),
      ),
      onPressed: onBack ?? () => Navigator.of(context).pop(),
    );
  }
}

class CoffeeHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CoffeeHomeAppBar({
    super.key,
    this.onNotification,
  });

  final VoidCallback? onNotification;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: AppRadius.smBR,
            ),
            child: const Icon(Icons.coffee_rounded,
                color: Colors.white, size: 18),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text('Coffee Budget Tracker', style: AppTypography.appBarTitle()),
        ],
      ),
      actions: [
        if (onNotification != null)
          IconButton(
            icon: Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: AppRadius.smBR,
              ),
              child: const Icon(Icons.notifications_outlined,
                  size: 18, color: AppColors.secondary),
            ),
            onPressed: onNotification,
          ),
        const SizedBox(width: AppSpacing.sm),
      ],
    );
  }
}
