import 'package:material_ui/material_ui.dart';

abstract final class AppColors {
  static const background = Color(0xFFF4F3FA);
  static const surface = Color(0xFFFFFFFF);
  static const ink = Color(0xFF16143A);
  static const inkSoft = Color(0xFF2A2760);
  static const muted = Color(0xFF6F6B93);
  static const border = Color(0xFFE4E1F2);
  static const primary = Color(0xFF5B4BFF);
  static const primarySoft = Color(0xFFEDEBFF);
  static const gem = Color(0xFF13B5EA);
  static const positive = Color(0xFF14A05B);
  static const negative = Color(0xFFE5484D);
  static const gold = Color(0xFFF5A524);

  static Color trend(double value) => value >= 0 ? positive : negative;
}
