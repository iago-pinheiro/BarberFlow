import 'dart:ui';
import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../constants/app_dimensions.dart';

class AppTextStyles {
  // Headlines
  static const TextStyle heading1 = TextStyle(
    fontSize: AppDimensions.fontSizeXXXL,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: AppDimensions.fontSizeXXL,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: AppDimensions.fontSizeXL,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: AppDimensions.fontSizeLG,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: AppDimensions.fontSizeMD,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: AppDimensions.fontSizeSM,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // Button
  static const TextStyle buttonLarge = TextStyle(
    fontSize: AppDimensions.fontSizeMD,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnAccent,
    letterSpacing: 1.0,
  );

  static const TextStyle buttonMedium = TextStyle(
    fontSize: AppDimensions.fontSizeMD,
    fontWeight: FontWeight.w600,
    color: AppColors.textOnPrimary,
    letterSpacing: 0.5,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: AppDimensions.fontSizeXS,
    fontWeight: FontWeight.w500,
    color: AppColors.textHint,
    letterSpacing: 0.5,
  );

  // Overline
  static const TextStyle overline = TextStyle(
    fontSize: AppDimensions.fontSizeSM,
    fontWeight: FontWeight.w600,
    color: AppColors.accentDark,
    letterSpacing: 1.5,
  );

  // Promo
  static const TextStyle promoPrice = TextStyle(
    fontSize: AppDimensions.fontSizeXXL,
    fontWeight: FontWeight.w800,
    color: AppColors.secondary,
    height: 1.1,
  );

  // Label
  static const TextStyle label = TextStyle(
    fontSize: AppDimensions.fontSizeSM,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
  );
}
