import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/verse_model.dart';
import '../providers/bookmarks_provider.dart';
import '../providers/reading_progress_provider.dart';
import '../screens/verse_reader_screen.dart';

class VerseTile extends StatelessWidget {
  final VerseModel verse;

  const VerseTile({super.key, required this.verse});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VerseReaderScreen(verseId: verse.id),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Verse Number Column
            Column(
              children: [
                Text(
                  '${verse.chapter}.${verse.verse}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryAccent,
                  ),
                ),
                Consumer2<BookmarksProvider, ReadingProgressProvider>(
                  builder: (context, bookmarks, progress, child) {
                    bool isBookmarked = bookmarks.isBookmarked(verse.id);
                    bool isRead = progress.isRead(verse.id);
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isBookmarked) 
                          const Icon(Icons.bookmark, size: 14, color: AppColors.primaryAccent),
                        if (isRead)
                          const Icon(Icons.check_circle, size: 14, color: Colors.green),
                      ],
                    );
                  },
                ),
              ],
            ),
            const SizedBox(width: AppSpacing.md),
            // Verse Preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    verse.slok.split('\n').first,
                    style: AppTextStyles.devanagari.copyWith(fontSize: 18),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    verse.translation,
                    style: AppTextStyles.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
