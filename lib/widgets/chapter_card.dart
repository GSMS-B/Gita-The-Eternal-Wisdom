import 'package:flutter/material.dart';
import '../core/constants/asset_paths.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/chapter_model.dart';
import '../screens/verses_list_screen.dart';

class ChapterCard extends StatelessWidget {
  final ChapterModel chapter;

  const ChapterCard({super.key, required this.chapter});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shadowColor: AppColors.primaryAccent.withOpacity(0.2),
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.primaryAccent.withOpacity(0.3), width: 1.5),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => VersesListScreen(chapter: chapter),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Chapter Icon
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 80,
                  height: 80,
                  color: AppColors.cardSurface,
                  child: Image.asset(
                    AssetPaths.getChapterIcon(chapter.imageName),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.menu_book, color: AppColors.primaryAccent),
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              // Chapter Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Chapter ${chapter.chapterNumber}',
                      style: AppTextStyles.heading3.copyWith(
                        color: AppColors.primaryAccent,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chapter.nameTranslation,
                      style: AppTextStyles.bodyLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${chapter.versesCount} Verses',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.dividerAndInactive,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.dividerAndInactive),
            ],
          ),
        ),
      ),
    );
  }
}
