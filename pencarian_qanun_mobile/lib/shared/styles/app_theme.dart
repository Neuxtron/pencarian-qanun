import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_text_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    scaffoldBackgroundColor: AppColors.background,
    fontFamily: "Poppins",
    textTheme: const TextTheme(
      bodySmall: AppTextStyles.bodySmall,
      bodyMedium: AppTextStyles.bodyMedium,
      bodyLarge: AppTextStyles.bodyLarge,
      titleLarge: AppTextStyles.titleLarge,
      headlineSmall: AppTextStyles.headlineSmall,
      headlineMedium: AppTextStyles.headlineMedium,
      headlineLarge: AppTextStyles.headlineLarge,
    ),
  );
}
