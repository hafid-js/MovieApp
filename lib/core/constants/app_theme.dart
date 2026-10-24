import 'package:flutter/material.dart';
import 'package:film_app/core/constants/shadow_theme.dart';

import 'package:film_app/core/constants/text_theme.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'NetflixSans',
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      disabledColor: AppColors.darkDisableColor,

      textTheme: AppTextTheme.darkTextTheme,

      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.darkSurface,
      ),

      iconTheme: IconThemeData(color: AppColors.textPrimaryDark),

      scaffoldBackgroundColor: AppColors.dark,
      cardColor: AppColors.darkCard,
      extensions: [
        AppShadow(
          small: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
          medium: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
          large: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: Offset(0, 10),
            ),
          ],
        ),
      ],
    );
  }
}
