import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/verse_provider.dart';
import '../providers/settings_provider.dart';
import '../providers/bookmarks_provider.dart';
import '../providers/reading_progress_provider.dart';
import '../providers/chapters_provider.dart';
import '../data/models/verse_model.dart';
class VerseReaderScreen extends StatefulWidget {
  final String verseId;

  const VerseReaderScreen({super.key, required this.verseId});

  @override
  State<VerseReaderScreen> createState() => _VerseReaderScreenState();
}

class _VerseReaderScreenState extends State<VerseReaderScreen> {
  final TextEditingController _questionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VerseProvider>().loadVerse(widget.verseId);
      context.read<ReadingProgressProvider>().updateLastRead(widget.verseId);
    });
  }

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer4<VerseProvider, SettingsProvider, BookmarksProvider, ChaptersProvider>(
      builder: (context, verseProvider, settings, bookmarks, chaptersProvider, child) {
        if (verseProvider.isLoading || verseProvider.currentVerse == null) {
          return const Scaffold(
            backgroundColor: AppColors.pageBackground,
            body: Center(child: CircularProgressIndicator(color: AppColors.primaryAccent)),
          );
        }

        final verse = verseProvider.currentVerse!;
        final bool isBookmarked = bookmarks.isBookmarked(verse.id);
        
        final chapter = chaptersProvider.chapters.isNotEmpty 
            ? chaptersProvider.chapters.firstWhere(
                (c) => c.chapterNumber == verse.chapter,
                orElse: () => chaptersProvider.chapters.first,
              ) 
            : null;

        return Scaffold(
          backgroundColor: AppColors.pageBackground,
          appBar: AppBar(
            backgroundColor: AppColors.pageBackground,
            elevation: 0,
            iconTheme: const IconThemeData(color: AppColors.primaryAccent),
            title: Text(verse.id, style: const TextStyle(color: AppColors.textMain)),
            centerTitle: true,
            actions: [
              Consumer<ReadingProgressProvider>(
                builder: (context, readProvider, child) {
                  final isRead = readProvider.isRead(verse.id);
                  return IconButton(
                    icon: Icon(
                      isRead ? Icons.check_circle : Icons.check_circle_outline, 
                      color: isRead ? Colors.green : AppColors.dividerAndInactive
                    ),
                    tooltip: isRead ? 'Mark as Unread' : 'Mark as Read',
                    onPressed: () {
                      readProvider.toggleReadStatus(verse.id);
                    },
                  );
                },
              ),
              IconButton(
                icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border, color: AppColors.primaryAccent),
                onPressed: () {
                  bookmarks.toggleBookmark(verse.id);
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                'assets/images/illustrations/reader_header.png',
                                width: double.infinity,
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            if (chapter != null)
                              Positioned(
                                right: 24,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Chapter ${chapter.chapterNumber} • ${chapter.name}',
                                      style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.textMain),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      chapter.nameTranslation,
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMain.withOpacity(0.7)),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Verse ${verse.verse} of ${chapter.versesCount}',
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMain.withOpacity(0.7)),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(AppSpacing.lg),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Slok
                          Text(
                            verse.slok,
                            style: AppTextStyles.devanagari.copyWith(
                              fontSize: AppTextStyles.devanagari.fontSize! * settings.fontSize,
                              height: 1.8,
                              color: AppColors.rustHighlight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          
                          // Transliteration
                          if (settings.showTransliteration && verse.transliteration.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.xl),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Transliteration',
                                style: AppTextStyles.heading3.copyWith(color: AppColors.primaryAccent),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              verse.transliteration,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontStyle: FontStyle.italic,
                                fontSize: AppTextStyles.bodyMedium.fontSize! * settings.fontSize,
                                height: 1.6,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                          
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                            child: Divider(color: AppColors.dividerAndInactive, thickness: 0.5),
                          ),
                          
                          // Translation
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Translation by ${verse.getAuthorName(settings.translationAuthor)}',
                              style: AppTextStyles.heading3.copyWith(color: AppColors.primaryAccent),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            verse.getTranslationFor(settings.translationAuthor),
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: AppTextStyles.bodyLarge.fontSize! * settings.fontSize,
                              height: 1.6,
                            ),
                          ),
                          
                          const SizedBox(height: AppSpacing.xl),
                          
                          // Purport
                          if (verse.getPurportForAuthor(settings.translationAuthor).isNotEmpty) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Purport by ${verse.getAuthorName(settings.translationAuthor)}',
                                style: AppTextStyles.heading3.copyWith(color: AppColors.primaryAccent),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              verse.getPurportForAuthor(settings.translationAuthor),
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontSize: AppTextStyles.bodyMedium.fontSize! * settings.fontSize,
                                height: 1.6,
                              ),
                            ),
                          ] else if (settings.translationAuthor != 'prabhu') ...[
                            // Fallback if no purport by selected author
                            Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.primaryAccent.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.primaryAccent.withOpacity(0.2)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.info_outline, color: AppColors.primaryAccent, size: 20),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(
                                      '${verse.getAuthorName(settings.translationAuthor)} has not provided a purport for this verse. You can change the author in Settings.',
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMain.withOpacity(0.7)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              // Styled Bottom Bar
              _buildBottomBar(context, verseProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomBar(BuildContext context, VerseProvider provider) {
    int currentIndex = provider.chapterVerses.indexWhere((v) => v.id == provider.currentVerse?.id);
    String prevId = currentIndex > 0 ? 'BG ${provider.chapterVerses[currentIndex - 1].id}' : '';
    String nextId = currentIndex >= 0 && currentIndex < provider.chapterVerses.length - 1 ? 'BG ${provider.chapterVerses[currentIndex + 1].id}' : '';

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.pageBackground,
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.md),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Previous Button
            InkWell(
              onTap: provider.hasPrevious ? () {
                provider.previousVerse();
              } : null,
              child: Opacity(
                opacity: provider.hasPrevious ? 1.0 : 0.3,
                child: Row(
                  children: [
                    const Icon(Icons.arrow_back_ios, size: 16, color: AppColors.primaryAccent),
                    const SizedBox(width: 4),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Previous', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
                        if (prevId.isNotEmpty)
                          Text(prevId, style: AppTextStyles.bodySmall.copyWith(color: AppColors.dividerAndInactive, fontSize: 10)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            // Mark as Read Button
            Consumer<ReadingProgressProvider>(
              builder: (context, progress, child) {
                final isRead = provider.currentVerse != null && progress.isRead(provider.currentVerse!.id);
                return ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryAccent,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  icon: Icon(isRead ? Icons.check_circle : Icons.check_circle_outline, size: 18),
                  label: Text(isRead ? 'Read' : 'Mark as Read', style: const TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    if (provider.currentVerse != null) {
                      progress.markAsRead(provider.currentVerse!.id);
                    }
                  },
                );
              },
            ),
            
            // Next Button
            InkWell(
              onTap: provider.hasNext ? () {
                provider.nextVerse();
              } : null,
              child: Opacity(
                opacity: provider.hasNext ? 1.0 : 0.3,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Next', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryAccent)),
                        if (nextId.isNotEmpty)
                          Text(nextId, style: AppTextStyles.bodySmall.copyWith(color: AppColors.dividerAndInactive, fontSize: 10)),
                      ],
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.primaryAccent),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
