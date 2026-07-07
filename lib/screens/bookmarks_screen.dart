import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/asset_paths.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/bookmarks_provider.dart';
import 'verse_reader_screen.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/illustrations/hero_bookmarks.png',
            width: double.infinity,
            height: 220,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: SizedBox(
              width: double.infinity,
              child: Center(
                child: Text('Bookmarks', style: AppTextStyles.heading1),
              ),
            ),
          ),
          Expanded(
            child: Consumer<BookmarksProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (provider.bookmarks.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(AssetPaths.bookmarksEmpty, height: 150),
                        const SizedBox(height: AppSpacing.lg),
                        const Text('No Bookmarks Yet', style: AppTextStyles.heading3),
                        const SizedBox(height: AppSpacing.sm),
                        const Text('Save your favorite verses to read them later.'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  itemCount: provider.bookmarks.length,
            itemBuilder: (context, index) {
              final bookmark = provider.bookmarks[index];
              return Card(
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  title: Text('Verse ${bookmark.verseId}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerseReaderScreen(verseId: bookmark.verseId),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.bookmark, color: AppColors.primaryAccent),
                    onPressed: () {
                      provider.toggleBookmark(bookmark.verseId);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    ),
  ],
),
    );
  }
}
