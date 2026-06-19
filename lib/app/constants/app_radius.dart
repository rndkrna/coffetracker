import 'package:flutter/material.dart';

// Top-level const
const double kRadiusInput     = 14.0;
const double kRadiusCardSM    = 16.0;
const double kRadiusCard      = 20.0;
const double kRadiusModal     = 24.0;
const double kRadiusFab       = 18.0;

class AppRadius {
  AppRadius._();
  static const double input     = kRadiusInput;
  static const double cardSmall = kRadiusCardSM;
  static const double card      = kRadiusCard;
  static const double modal     = kRadiusModal;
  static const double fab       = kRadiusFab;

  static const double sm  = kRadiusInput;
  static const double md  = kRadiusCardSM;
  static const double lg  = kRadiusCard;
  static const double xl  = kRadiusModal;

  // Pre-built BorderRadius
  static const BorderRadius inputBR    = BorderRadius.all(Radius.circular(kRadiusInput));
  static const BorderRadius cardSmallBR= BorderRadius.all(Radius.circular(kRadiusCardSM));
  static const BorderRadius cardBR     = BorderRadius.all(Radius.circular(kRadiusCard));
  static const BorderRadius smBR       = BorderRadius.all(Radius.circular(kRadiusInput));
  static const BorderRadius mdBR       = BorderRadius.all(Radius.circular(kRadiusCardSM));
  static const BorderRadius lgBR       = BorderRadius.all(Radius.circular(kRadiusCard));
  static const BorderRadius xlBR       = BorderRadius.all(Radius.circular(kRadiusModal));
  static const BorderRadius modalBR    = BorderRadius.vertical(top: Radius.circular(kRadiusModal));
}
