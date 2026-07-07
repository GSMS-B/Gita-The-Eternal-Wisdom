import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: AppColors.primaryAccent,
      scaffoldBackgroundColor: AppColors.pageBackground,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primaryAccent,
        secondary: AppColors.goldHighlight,
        surface: AppColors.cardSurface,
        background: AppColors.pageBackground,
        onPrimary: Colors.white,
        onSurface: AppColors.textMain,
        onBackground: AppColors.textMain,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryAccent),
        titleTextStyle: AppTextStyles.heading2,
        centerTitle: true,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.pageBackground,
        selectedItemColor: AppColors.primaryAccent,
        unselectedItemColor: AppColors.dividerAndInactive,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),

      dividerTheme: const DividerThemeData(
        color: AppColors.dividerAndInactive,
        thickness: 1,
        space: 24,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.heading1,
        displayMedium: AppTextStyles.heading2,
        displaySmall: AppTextStyles.heading3,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
      ),
    );
  }
}
