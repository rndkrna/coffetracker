import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Design token tipografi
///
/// Design System v1 Section 5:
/// - Heading: Playfair Display atau DM Serif Display
/// - Body UI: Poppins, Inter, atau Nunito Sans
///
/// Implementasi: Playfair Display untuk heading premium,
/// Poppins untuk body dan elemen UI.
class AppTypography {
  AppTypography._();

  // ─── Heading (Playfair Display — elegan, premium) ────────────────────────

  static TextStyle displayLarge({Color? color}) => GoogleFonts.playfairDisplay(
        fontSize: 32, fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary, height: 1.25);

  static TextStyle heading1({Color? color}) => GoogleFonts.playfairDisplay(
        fontSize: 24, fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary, height: 1.3);

  static TextStyle heading2({Color? color}) => GoogleFonts.playfairDisplay(
        fontSize: 20, fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary, height: 1.3);

  static TextStyle heading3({Color? color}) => GoogleFonts.playfairDisplay(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary, height: 1.4);

  // ─── Body & UI (Poppins — readable, modern) ─────────────────────────────

  static TextStyle bodyLarge({Color? color}) => GoogleFonts.poppins(
        fontSize: 16, fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary, height: 1.5);

  static TextStyle bodyRegular({Color? color}) => GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w400,
        color: color ?? AppColors.textPrimary, height: 1.5);

  static TextStyle bodySmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary, height: 1.5);

  static TextStyle caption({Color? color}) => GoogleFonts.poppins(
        fontSize: 11, fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary, height: 1.4);

  static TextStyle label({Color? color}) => GoogleFonts.poppins(
        fontSize: 13, fontWeight: FontWeight.w500,
        color: color ?? AppColors.textPrimary, height: 1.4);

  static TextStyle button({Color? color}) => GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: color ?? Colors.white, height: 1.4, letterSpacing: 0.2);

  static TextStyle buttonSmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 12, fontWeight: FontWeight.w600,
        color: color ?? Colors.white, height: 1.4);

  // ─── Price styles ──────────────────────────────────────────────────────

  static TextStyle priceHero({Color? color}) => GoogleFonts.poppins(
        fontSize: 28, fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary, height: 1.2);

  static TextStyle priceMedium({Color? color}) => GoogleFonts.poppins(
        fontSize: 18, fontWeight: FontWeight.w700,
        color: color ?? AppColors.primary, height: 1.3);

  static TextStyle priceSmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 14, fontWeight: FontWeight.w600,
        color: color ?? AppColors.primary, height: 1.4);

  // ─── Navigation & App Bar ──────────────────────────────────────────────

  static TextStyle appBarTitle({Color? color}) => GoogleFonts.poppins(
        fontSize: 18, fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary);

  static TextStyle navLabel({Color? color}) => GoogleFonts.poppins(
        fontSize: 10, fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary);

  static TextStyle navLabelActive({Color? color}) => GoogleFonts.poppins(
        fontSize: 10, fontWeight: FontWeight.w700,
        color: color ?? AppColors.primary);
}
