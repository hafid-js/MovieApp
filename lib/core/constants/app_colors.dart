
import 'package:film_app/core/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';

final class AppColors {
  static Color primary = HexColor.fromHex("#256980");
  AppColors._();

  /// PRIMARY
  // static Color primary = setting.colorSelected;

  /// DARK
  static Color dark = HexColor.fromHex("#161818");
  static Color darkCard = Color(0xFF132E3A);
  static Color secondary = HexColor.fromHex("#D39D52");
  static Color darkDisableColor = Colors.grey.withAlpha(120);
  static const Color darkSurface = Color(0xFF17404A);
  // static Color get darkSurface =>
  //     setting.currentColor.value.withAlpha(50);
  //       static Color get lightSurface =>
  //     setting.currentColor.value.withAlpha(50);

  /// LIGHT
  
  static Color light = HexColor.fromHex("#F9F5EF");
  static Color lightCard = Colors.white;
  static Color textSection = HexColor.fromHex("#2D4A52");
    static Color lightDisableColor = HexColor.fromHex("#F6F8F9");
  // static const Color lightContainer = Color(0xFFEAF4F3);
// static const Color lightSurface = Color(0xFFD8EEEB);

  /// TEXT
  static const Color textPrimaryDark = Colors.white;
  static Color textSecondaryDark = AppColors.primary;
// static Color get textPrimaryLight  =>
//       setting.currentColor.value;

static const Color textPrimaryLight = Color(0xFF2D4A52);
static Color menuTitle = HexColor.fromHex("#5a7b8a");
  static Color textSecondaryLight = HexColor.fromHex("#607D85");

  /// BORDER
  //  static Color get borderPrimary  =>
  //     setting.currentColor.value;
  // static const Color borderPrimary = Color(0x332DC8B9);
}