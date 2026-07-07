import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/settings_provider.dart';
import '../data/models/authors_metadata.dart';

class TranslationPreferencesScreen extends StatelessWidget {
  const TranslationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        title: const Text('Translation Preferences'),
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryAccent),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settings, child) {
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: AuthorsMetadata.authors.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.md),
            itemBuilder: (context, index) {
              final author = AuthorsMetadata.authors[index];
              final isSelected = settings.translationAuthor == author.id;

              return InkWell(
                onTap: () {
                  settings.setTranslationAuthor(author.id);
                  // Optional: Navigator.pop(context) to go back immediately, 
                  // but letting them stay to read other bios is nice too.
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primaryAccent.withOpacity(0.05) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primaryAccent : AppColors.dividerAndInactive.withOpacity(0.5),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: AppColors.primaryAccent.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        )
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              author.name,
                              style: AppTextStyles.heading3.copyWith(
                                color: isSelected ? AppColors.primaryAccent : AppColors.textMain,
                              ),
                            ),
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: AppColors.primaryAccent),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        author.intro,
                        style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: author.tags.map((tag) => _buildTag(tag)).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildTag(String tag) {
    Color bgColor = AppColors.tagBlue;
    Color textColor = Colors.blue.shade800;

    if (tag.contains('Hindi')) {
      bgColor = AppColors.tagPeach;
      textColor = Colors.orange.shade800;
    } else if (tag.contains('Sanskrit')) {
      bgColor = AppColors.tagLavender;
      textColor = Colors.purple.shade800;
    } else if (tag.contains('English')) {
      bgColor = AppColors.tagMint;
      textColor = Colors.green.shade800;
    }

    if (tag.contains('Commentary')) {
      // Make commentary tags slightly bolder or different
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: textColor.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book, size: 12, color: textColor),
            const SizedBox(width: 4),
            Text(
              tag,
              style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        tag,
        style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
