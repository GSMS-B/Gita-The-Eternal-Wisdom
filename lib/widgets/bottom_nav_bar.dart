import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: AppColors.cardSurface,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 8.0,
      height: 75, // Lowered slightly to fit within strict Android bounds
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(0, 'ic_home.png', 'Home'),
            _buildNavItem(1, 'ic_chapters.png', 'Chapters'),
            const SizedBox(width: 60), // Space for the central FAB
            _buildNavItem(2, 'ic_bookmarks.png', 'Bookmarks'),
            _buildNavItem(3, 'ic_settings.png', 'Settings'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String iconName, String label) {
    final isSelected = currentIndex == index;
    final color = isSelected ? AppColors.primaryAccent : AppColors.dividerAndInactive;
    
    return Expanded(
      child: GestureDetector(
        onTap: () => onTap(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: isSelected ? const EdgeInsets.all(6) : EdgeInsets.zero,
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.transparent,
                shape: BoxShape.circle,
                boxShadow: isSelected ? [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  )
                ] : null,
              ),
              child: Image.asset(
                'assets/icons/$iconName',
                color: color,
                width: 26, // Reduced slightly to fix overflow
                height: 26,
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: color,
                  fontSize: 11, // Reduced slightly
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
