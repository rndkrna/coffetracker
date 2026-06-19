import 'package:flutter/material.dart';

/// Design token warna utama Coffee Budget Tracker
/// Sumber: Coffee_Budget_Tracker_Design_System_v1.md — Section 4
class AppColors {
  AppColors._();

  // ─── Primary Coffee Palette ───────────────────────────────────────────────
  static const Color coffeeCream50  = Color(0xFFFAF5EE); // Background utama app
  static const Color coffeeCream100 = Color(0xFFF4E9DA); // Surface ringan / section block
  static const Color coffeeCream200 = Color(0xFFEBD7BE); // Input background / chip nonaktif
  static const Color coffeeBrown300 = Color(0xFFC49A6C); // Accent lembut
  static const Color coffeeBrown500 = Color(0xFF8B5E3C); // Secondary brand color
  static const Color coffeeBrown700 = Color(0xFF5C3A21); // Primary brand color / tombol utama
  static const Color coffeeBrown900 = Color(0xFF3A2416); // Teks utama / ikon utama
  static const Color milkFoam       = Color(0xFFFFFDF9); // Card terang / modal

  // ─── Supporting Accent Palette ────────────────────────────────────────────
  static const Color caramel    = Color(0xFFB97A3D);
  static const Color matchaSoft = Color(0xFFA8B18A);
  static const Color roseMocha  = Color(0xFFC88D7A);
  static const Color mochaGray  = Color(0xFF8A8178);
  static const Color linen      = Color(0xFFF8F1E7);

  // ─── Status Colors ────────────────────────────────────────────────────────
  static const Color success = Color(0xFF7C9A62);
  static const Color warning = Color(0xFFD1A054);
  static const Color error   = Color(0xFFB85C4A);
  static const Color info    = Color(0xFF7A8FA6);

  // ─── Semantic Aliases ─────────────────────────────────────────────────────
  static const Color background   = coffeeCream50;
  static const Color surface      = milkFoam;
  static const Color primary      = coffeeBrown700;
  static const Color secondary    = coffeeBrown500;
  static const Color accent       = coffeeBrown300;
  static const Color cream        = coffeeCream100;
  static const Color warmBeige    = coffeeCream200;
  static const Color textPrimary  = coffeeBrown900;
  static const Color textSecondary = mochaGray;
  static const Color border       = Color(0xFFDCCAB5);
  static const Color divider      = Color(0xFFE8DDCF);

  // ─── Chart Colors ─────────────────────────────────────────────────────────
  static const Color chartBar1 = coffeeBrown500;
  static const Color chartBar2 = coffeeBrown300;
  static const Color chartBar3 = coffeeCream200;
  static const Color chartLine = coffeeBrown700;

  // ─── Shadow ───────────────────────────────────────────────────────────────
  static const Color shadowBrown = Color(0x145C3A21);

  // ─── Dark Theme ───────────────────────────────────────────────────────────
  static const Color darkBackground = Color(0xFF120C09);
  static const Color darkSurface    = Color(0xFF1E140F);
  static const Color darkCard       = Color(0xFF2C1E16);
  static const Color darkBorder     = Color(0xFF3D2A1E);

  // ─── Legacy Aliases (kompatibilitas screen lama) ──────────────────────────
  // Alias ini memastikan screen lama yang menggunakan AppColors.danger dll
  // tetap compile tanpa perubahan. Hapus bertahap saat screen dimigrasikan.

  /// Legacy alias → gunakan [error] pada kode baru
  static const Color danger = error;

  /// Legacy alias → warna coklat gelap
  static const Color primaryDark = coffeeBrown900;

  /// Legacy alias → background input
  static const Color inputBg = surface;

  /// Legacy alias → card background
  static const Color cardBg = surface;

  /// Legacy alias → surface brown
  static const Color surfaceBrown = primary;

  /// Legacy alias → coffee light accent
  static const Color coffeeLight = coffeeBrown300;
}
