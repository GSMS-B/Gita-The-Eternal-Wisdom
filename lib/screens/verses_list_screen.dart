import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/asset_paths.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../data/models/chapter_model.dart';
import '../providers/verse_provider.dart';
import '../widgets/verse_tile.dart';

class VersesListScreen extends StatefulWidget {
  final ChapterModel chapter;

  const VersesListScreen({super.key, required this.chapter});

  @override
  State<VersesListScreen> createState() => _VersesListScreenState();
}

class _VersesListScreenState extends State<VersesListScreen> {
  @override
  void initState() {
    super.initState();
    // Load verses for this chapter
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VerseProvider>().loadVersesForChapter(widget.chapter.chapterNumber);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      appBar: AppBar(
        backgroundColor: AppColors.pageBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryAccent),
      ),
      body: CustomScrollView(
        slivers: [
          // Hero Image
          SliverToBoxAdapter(
            child: Image.asset(
              AssetPaths.getChapterHero(widget.chapter.chapterNumber),
              width: double.infinity,
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) =>
                  Container(height: 200, color: AppColors.primaryAccent),
            ),
          ),
          
          // Chapter Title & Summary
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.cardSurface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Chapter ${widget.chapter.chapterNumber}',
                    style: const TextStyle(
                      fontFamily: 'Samarkan',
                      fontSize: 32,
                      color: AppColors.primaryAccent,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.chapter.nameTranslation,
                    style: AppTextStyles.heading2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    widget.chapter.chapterSummary,
                    style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ),
          
          // Verses List Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(AppSpacing.lg, AppSpacing.xl, AppSpacing.lg, AppSpacing.sm),
              child: Text(
                'Verses',
                style: AppTextStyles.heading3,
              ),
            ),
          ),
          
          // Verses List
          Consumer<VerseProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                );
              }
              
              if (provider.chapterVerses.isEmpty) {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.xl),
                    child: Center(child: Text('No verses found for this chapter.')),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final verse = provider.chapterVerses[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: VerseTile(verse: verse),
                      );
                    },
                    childCount: provider.chapterVerses.length,
                  ),
                ),
              );
            },
          ),
          
          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
        ],
      ),
    );
  }
}
