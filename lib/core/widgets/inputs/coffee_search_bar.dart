import 'package:flutter/material.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_shadows.dart';
import '../../../app/constants/app_typography.dart';

class CoffeeSearchBar extends StatefulWidget {
  const CoffeeSearchBar({
    super.key,
    this.hint = 'Cari...',
    this.onChanged,
    this.onClear,
    this.controller,
    this.autofocus = false,
  });

  final String hint;
  final void Function(String)? onChanged;
  final VoidCallback? onClear;
  final TextEditingController? controller;
  final bool autofocus;

  @override
  State<CoffeeSearchBar> createState() => _CoffeeSearchBarState();
}

class _CoffeeSearchBarState extends State<CoffeeSearchBar> {
  late TextEditingController _ctrl;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _ctrl = widget.controller ?? TextEditingController();
    _ctrl.addListener(() {
      final has = _ctrl.text.isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    if (widget.controller == null) _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: AppRadius.inputBR,
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.subtle,
      ),
      child: TextField(
        controller: _ctrl,
        autofocus: widget.autofocus,
        onChanged: widget.onChanged,
        style: AppTypography.bodyRegular(),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: AppTypography.bodyRegular(color: AppColors.textSecondary),
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.secondary, size: 20),
          suffixIcon: _hasText
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded,
                      size: 18, color: AppColors.textSecondary),
                  onPressed: () {
                    _ctrl.clear();
                    widget.onChanged?.call('');
                    widget.onClear?.call();
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
