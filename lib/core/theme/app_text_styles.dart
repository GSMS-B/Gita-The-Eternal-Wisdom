import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // We'll use default fonts for now (Roboto/San Francisco), but can be replaced 
  // with custom serif/sans-serif as specified.
  
  static const TextStyle heading1 = TextStyle(
    fontFamily: 'Samarkan',
    fontSize: 32,
    fontWeight: FontWeight.normal,
    color: AppColors.textMain,
    height: 1.2,
  );
  
  static const TextStyle heading2 = TextStyle(
    fontFamily: 'Samarkan',
    fontSize: 28,
    fontWeight: FontWeight.normal,
    color: AppColors.textMain,
    height: 1.3,
  );
  
  static const TextStyle heading3 = TextStyle(
    fontFamily: 'Samarkan',
    fontSize: 24,
    fontWeight: FontWeight.normal,
    color: AppColors.textMain,
    height: 1.4,
  );
  
  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'Lora',
    fontSize: 18,
    fontWeight: FontWeight.normal,
    color: AppColors.textMain,
    height: 1.5,
  );
  
  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'Lora',
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textMain,
    height: 1.5,
  );
  
  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'Lora',
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textMain,
    height: 1.4,
  );
  
  static const TextStyle devanagari = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.rustHighlight,
    height: 1.8,
  );
}
