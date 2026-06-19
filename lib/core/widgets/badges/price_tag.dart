import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../app/constants/app_colors.dart';
import '../../../app/constants/app_radius.dart';
import '../../../app/constants/app_typography.dart';

/// Tag harga yang diformat sebagai Rupiah.
/// Contoh: "Rp25.000" atau "Rp20.000–Rp35.000"
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.price,
    this.maxPrice,
    this.style = PriceTagStyle.normal,
    this.compact = false,
  });

  /// Harga utama (atau harga minimum jika [maxPrice] diisi).
  final int price;

  /// Jika diisi, tampilkan sebagai range: "Rp[price]–Rp[maxPrice]".
  final int? maxPrice;

  final PriceTagStyle style;
  final bool compact;

  static final _formatter = NumberFormat('#,###', 'id_ID');

  String get _text {
    final min = 'Rp${_formatter.format(price)}';
    if (maxPrice != null && maxPrice! > price) {
      return '$min–Rp${_formatter.format(maxPrice)}';
    }
    return min;
  }

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case PriceTagStyle.badge:
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 6 : 8,
            vertical: compact ? 2 : 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.caramel.withValues(alpha: 0.12),
            borderRadius: AppRadius.smBR,
          ),
          child: Text(
            _text,
            style: (compact
                    ? AppTypography.caption(color: AppColors.caramel)
                    : AppTypography.label(color: AppColors.caramel))
                .copyWith(fontWeight: FontWeight.w700),
          ),
        );

      case PriceTagStyle.hero:
        return Text(_text, style: AppTypography.priceHero());

      case PriceTagStyle.medium:
        return Text(_text, style: AppTypography.priceMedium());

      case PriceTagStyle.normal:
        return Text(
          _text,
          style: compact
              ? AppTypography.priceSmall()
              : AppTypography.priceMedium(),
        );
    }
  }
}

enum PriceTagStyle {
  /// Tampil inline tanpa background.
  normal,

  /// Tampil dengan background caramel transparan.
  badge,

  /// Ukuran besar untuk hero section.
  hero,

  /// Ukuran sedang.
  medium,
}
