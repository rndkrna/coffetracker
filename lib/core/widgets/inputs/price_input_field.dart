import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_spacing.dart';
import '../../../app/constants/app_typography.dart';

/// Input khusus untuk nominal Rupiah dengan auto-formatting.
///
/// Menampilkan prefix "Rp" dan memformat angka dengan pemisah ribuan.
/// Contoh: user ketik 25000 → tampil "Rp 25.000"
class PriceInputField extends StatefulWidget {
  const PriceInputField({
    super.key,
    this.controller,
    this.initialValue,
    this.label = 'Harga',
    this.hint = 'Rp 0',
    this.helperText,
    this.errorText,
    this.onChanged,
    this.enabled = true,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final int? initialValue;
  final String label;
  final String hint;
  final String? helperText;
  final String? errorText;
  final ValueChanged<int>? onChanged;
  final bool enabled;
  final bool autofocus;

  @override
  State<PriceInputField> createState() => _PriceInputFieldState();
}

class _PriceInputFieldState extends State<PriceInputField> {
  late TextEditingController _controller;
  final _formatter = NumberFormat('#,###', 'id_ID');

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null && widget.initialValue! > 0) {
      _controller.text = _formatter.format(widget.initialValue);
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) _controller.dispose();
    super.dispose();
  }

  void _onChanged(String raw) {
    // Strip non-digits
    final digits = raw.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      _controller.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      widget.onChanged?.call(0);
      return;
    }

    final number = int.parse(digits);
    final formatted = _formatter.format(number);

    _controller.value = TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
    widget.onChanged?.call(number);
  }

  int get currentValue {
    final digits = _controller.text.replaceAll(RegExp(r'[^0-9]'), '');
    return digits.isEmpty ? 0 : int.parse(digits);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(widget.label, style: AppTypography.label()),
        const SizedBox(height: AppSpacing.sm),
        Container(
          decoration: BoxDecoration(
            color: widget.enabled ? AppColors.surface : AppColors.cream,
            borderRadius: AppRadius.inputBR,
            border: Border.all(
              color: hasError ? AppColors.error : AppColors.border,
              width: hasError ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.s12, vertical: AppSpacing.s12),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.input - 1),
                    bottomLeft: Radius.circular(AppRadius.input - 1),
                  ),
                ),
                child: Text(
                  'Rp',
                  style: AppTypography.bodyLarge(color: AppColors.primary)
                      .copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _controller,
                  enabled: widget.enabled,
                  autofocus: widget.autofocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  onChanged: _onChanged,
                  style: AppTypography.bodyLarge(),
                  decoration: InputDecoration(
                    hintText: widget.hint.replaceFirst('Rp ', ''),
                    hintStyle:
                        AppTypography.bodyLarge(color: AppColors.border),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.s12,
                      vertical: AppSpacing.s12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (hasError) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(widget.errorText!,
              style: AppTypography.caption(color: AppColors.error)),
        ] else if (widget.helperText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(widget.helperText!, style: AppTypography.caption()),
        ],
      ],
    );
  }
}
