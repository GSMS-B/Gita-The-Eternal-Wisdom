import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_text_styles.dart';
import '../data/repository/gita_repository.dart';
import '../data/models/verse_model.dart';
import '../data/models/chapter_model.dart';
import 'verse_reader_screen.dart';
import 'chapters_screen.dart'; // Or wherever we navigate to read a chapter, wait, there's no ChapterDetailScreen. ChaptersScreen just expands? Let's just navigate to VerseReaderScreen for verse 1 of that chapter.

class GitaSearchDelegate extends SearchDelegate<String> {
  final GitaRepository _repository = GitaRepository();

  @override
  String get searchFieldLabel => 'e.g. Karma Yoga';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context).copyWith(
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.primaryAccent),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        hintStyle: TextStyle(color: AppColors.dividerAndInactive),
      ),
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      if (query.isNotEmpty)
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          },
        ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) return const SizedBox.shrink();
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container(color: AppColors.pageBackground);
    }
    return _buildSearchResults(context);
  }

  Widget _buildSearchResults(BuildContext context) {
    return Container(
      color: AppColors.pageBackground,
      child: FutureBuilder<List<dynamic>>(
        future: Future.wait([
          _repository.searchChapters(query),
          _repository.search(query),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: AppColors.primaryAccent));
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          final chapterResults = (snapshot.data?[0] as List<ChapterModel>?) ?? [];
          final verseResults = (snapshot.data?[1] as List<VerseModel>?) ?? [];
          
          if (chapterResults.isEmpty && verseResults.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: AppColors.dividerAndInactive),
                  const SizedBox(height: 16),
                  Text('No results found for "$query"', style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          return ListView(
            children: [
              if (chapterResults.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Chapters', style: AppTextStyles.heading3),
                ),
                ...chapterResults.map((chapter) => ListTile(
                  title: Text('Chapter ${chapter.chapterNumber}: ${chapter.nameTranslation}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(chapter.chapterSummary, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMedium),
                  onTap: () {
                    // Navigate to the first verse of this chapter
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerseReaderScreen(verseId: '${chapter.chapterNumber}.1'),
                      ),
                    );
                  },
                )).toList(),
              ],
              
              if (verseResults.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Verses', style: AppTextStyles.heading3),
                ),
                ...verseResults.map((verse) => ListTile(
                  title: Text('Chapter ${verse.chapter}, Verse ${verse.verse}', style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(verse.translation, maxLines: 2, overflow: TextOverflow.ellipsis, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerseReaderScreen(verseId: verse.id),
                      ),
                    );
                  },
                )).toList(),
              ]
            ],
          );
        },
      ),
    );
  }

  Widget _buildSuggestionTile(BuildContext context, String suggestion) {
    return ListTile(
      leading: const Icon(Icons.history, color: AppColors.dividerAndInactive),
      title: Text(suggestion, style: AppTextStyles.bodyMedium),
      onTap: () {
        query = suggestion;
        showResults(context);
      },
    );
  }
}
