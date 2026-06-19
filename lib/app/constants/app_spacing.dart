import 'package:flutter/material.dart';

// Top-level const agar bisa dipakai di const widget tree
const double kSpaceXXS = 2.0;
const double kSpaceXS  = 4.0;
const double kSpaceSM  = 8.0;
const double kSpaceS12 = 12.0;
const double kSpaceMD  = 16.0;
const double kSpaceS20 = 20.0;
const double kSpaceLG  = 24.0;
const double kSpaceS28 = 28.0;
const double kSpaceXL  = 32.0;
const double kSpaceS40 = 40.0;
const double kSpaceS48 = 48.0;
const double kSpaceS56 = 56.0;
const double kSpaceS64 = 64.0;

const double kPageHorizontal   = 20.0;
const double kBottomNavOffset  = 100.0;

/// Design token spacing — class wrapper untuk kompatibilitas
/// Gunakan kSpaceMD dll langsung di const context
class AppSpacing {
  AppSpacing._();
  static const double xxs  = kSpaceXXS;
  static const double xs   = kSpaceXS;
  static const double sm   = kSpaceSM;
  static const double s12  = kSpaceS12;
  static const double md   = kSpaceMD;
  static const double s20  = kSpaceS20;
  static const double lg   = kSpaceLG;
  static const double s28  = kSpaceS28;
  static const double xl   = kSpaceXL;
  static const double s40  = kSpaceS40;
  static const double s48  = kSpaceS48;
  static const double s56  = kSpaceS56;
  static const double s64  = kSpaceS64;
  static const double pageHorizontal  = kPageHorizontal;
  static const double bottomNavOffset = kBottomNavOffset;

  // EdgeInsets helpers
  static const EdgeInsets pagePadding = EdgeInsets.symmetric(horizontal: kPageHorizontal);
  static const EdgeInsets cardPadding = EdgeInsets.all(kSpaceMD);
  static const EdgeInsets sectionPadding = EdgeInsets.all(kSpaceLG);
}
