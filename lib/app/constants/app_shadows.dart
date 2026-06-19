import 'package:flutter/material.dart';

class AppShadows {
  AppShadows._();

  static const List<BoxShadow> card = [
    BoxShadow(color: Color(0x145C3A21), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> cardElevated = [
    BoxShadow(color: Color(0x1F5C3A21), blurRadius: 20, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> subtle = [
    BoxShadow(color: Color(0x0A5C3A21), blurRadius: 6, offset: Offset(0, 2)),
  ];

  static const List<BoxShadow> bottomNav = [
    BoxShadow(color: Color(0x1A3A2416), blurRadius: 12, offset: Offset(0, -3)),
  ];

  static const List<BoxShadow> primaryButton = [
    BoxShadow(color: Color(0x405C3A21), blurRadius: 16, offset: Offset(0, 6)),
  ];
}
