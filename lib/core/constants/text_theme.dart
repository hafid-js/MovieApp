import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextTheme {
  AppTextTheme._();

  static TextTheme lightTextTheme = TextTheme(

    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),

    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),

    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),

    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.menuTitle,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.textPrimaryLight,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppColors.textSecondaryLight,
    ),

     labelSmall: TextStyle(
      fontSize: 12,
        //  fontWeight: FontWeight.w500,
      color: AppColors.primary,
    ),

    labelMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: AppColors.textSecondaryLight,
    ),


    labelLarge: TextStyle(
      fontSize: 16,
      // fontWeight: FontWeight.bold,
      color: AppColors.textSecondaryLight,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(

    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),

    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),

    titleMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),

    bodyLarge: TextStyle(
      fontSize: 16,
      color: AppColors.textPrimaryDark,
    ),

    bodyMedium: TextStyle(
      fontSize: 14,
      color: AppColors.textSecondaryDark,
    ),

     labelSmall:  TextStyle(
      fontSize: 12,
      color: AppColors.textPrimaryDark,
    ),


     labelMedium: TextStyle(
      fontSize: 14,
            fontWeight: FontWeight.w300,
      color: AppColors.textSecondaryDark,
    ),

    labelLarge: TextStyle(
      fontSize: 16,
      // fontWeight: FontWeight.bold,
      color: AppColors.textSecondaryDark,
    ),
  );
}