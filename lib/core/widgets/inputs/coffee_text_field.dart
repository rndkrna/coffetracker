import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_typography.dart';

class CoffeeTextField extends StatelessWidget {
  const CoffeeTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.minLines,
    this.enabled = true,
    this.readOnly = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.focusNode,
    this.autofocus = false,
    this.helperText,
    this.errorText,
    this.fillColor,
    this.textInputAction,
    this.initialValue,
    this.onTap,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final int? maxLines;
  final int? minLines;
  final bool enabled;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? helperText;
  final String? errorText;
  final Color? fillColor;
  final TextInputAction? textInputAction;
  final String? initialValue;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      enabled: enabled,
      readOnly: readOnly,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      focusNode: focusNode,
      autofocus: autofocus,
      textInputAction: textInputAction,
      onTap: onTap,
      style: AppTypography.bodyRegular(),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        fillColor: fillColor ?? AppColors.surface,
      ),
    );
  }
}
