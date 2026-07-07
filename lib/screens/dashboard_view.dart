import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/asset_paths.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/reading_progress_provider.dart';
import '../providers/chapters_provider.dart';
import '../data/models/chapter_model.dart';
import '../data/models/verse_model.dart';
import '../data/repository/gita_repository.dart';
import 'verse_reader_screen.dart';
import 'chapters_screen.dart';
import 'bookmarks_screen.dart';
import 'search_delegate.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the 3 lines / back button
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, top: 8.0),
            child: GestureDetector(
              onTap: () {
                showSearch(context: context, delegate: GitaSearchDelegate());
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFCD9A5B).withOpacity(0.8), // Golden cream border
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFCD9A5B).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  'assets/icons/ic_search.png', 
                  color: AppColors.primaryAccent, 
                  width: 28, 
                  height: 28,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Full Banner Header
            SizedBox(
              width: double.infinity,
              height: 350, // Increased height for a majestic feel
              child: Image.asset(
                AssetPaths.homeBanner,
                fit: BoxFit.cover, // Ensures it fills the larger height
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AssetPaths.homeHero,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
            
            // Content Below Banner
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32), // Add significant vertical spacing
                    const Text('Continue Reading', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Continue Reading Card
                    _buildContinueReadingCard(context),
                    
                    const SizedBox(height: AppSpacing.xl),
                    const Text('Reading Progress', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Reading Progress Card
                    _buildReadingProgressCard(context),
                    
                    const SizedBox(height: AppSpacing.xl),
                    const Text('Quick Actions', style: AppTextStyles.heading3),
                    const SizedBox(height: AppSpacing.md),
                    
                    // Quick Actions Grid
                    _buildQuickActions(context),
                    
                    const SizedBox(height: 100), // padding for bottom nav
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _glassContainer({required Widget child, EdgeInsetsGeometry? padding}) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFCD9A5B).withOpacity(0.6), // Prominent cream/gold outline
          width: 2.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFCD9A5B).withOpacity(0.2), // Matching warm shadow
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildContinueReadingCard(BuildContext context) {
    return Consumer2<ReadingProgressProvider, ChaptersProvider>(
      builder: (context, progress, chaptersProvider, child) {
        if (progress.lastReadVerseId == null || chaptersProvider.chapters.isEmpty) {
          return _glassContainer(
            child: const Text('Start reading a chapter to track your progress here.'),
          );
        }

        String lastRead = progress.lastReadVerseId!.replaceAll('BG ', '');
        
        return _glassContainer(
          child: FutureBuilder<VerseModel>(
            future: () async {
              String? nextId = await GitaRepository().getNextVerseId(lastRead);
              return await GitaRepository().getVerse(nextId ?? lastRead);
            }(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error loading continue reading.');
              }
              
              final verse = snapshot.data!;
              ChapterModel? chapter;
              try {
                chapter = chaptersProvider.chapters.firstWhere((c) => c.chapterNumber == verse.chapter);
              } catch (e) {}
              
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Chapter ${verse.chapter}', style: AppTextStyles.heading2),
                        if (chapter != null) 
                          Text(chapter.nameTranslation, style: AppTextStyles.bodyMedium),
                        const SizedBox(height: AppSpacing.sm),
                        Text('Verse ${verse.verse} of ${chapter?.versesCount ?? '?'}', 
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryAccent, fontWeight: FontWeight.bold)),
                        const SizedBox(height: AppSpacing.md),
                        
                        Text(
                          '" ${verse.translation} "',
                          style: AppTextStyles.bodySmall.copyWith(fontStyle: FontStyle.italic),
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        const SizedBox(height: AppSpacing.md),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryAccent,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            elevation: 0,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VerseReaderScreen(
                                  verseId: verse.id,
                                ),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Continue Reading', style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontSize: 12)),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios, size: 10),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 60,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.menu_book, size: 30, color: AppColors.primaryAccent),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReadingProgressCard(BuildContext context) {
    return Consumer2<ReadingProgressProvider, ChaptersProvider>(
      builder: (context, progress, chaptersProvider, child) {
        
        int totalVerses = 700;
        int completedVerses = progress.readVerses.length;
        
        return _glassContainer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.receipt_long, color: AppColors.primaryAccent, size: 24),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Progress', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, fontSize: 14)),
                            Text('${((completedVerses / totalVerses) * 100).toStringAsFixed(1)}%', style: AppTextStyles.bodySmall.copyWith(fontSize: 12, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('$completedVerses of $totalVerses Verses Read', style: AppTextStyles.bodyMedium.copyWith(fontSize: 12)),
                        const SizedBox(height: 12),
                        _buildProgressBar(completedVerses / totalVerses),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressBar(double progress) {
    if (progress.isNaN || progress.isInfinite) progress = 0;
    if (progress > 1) progress = 1;
    
    return Container(
      height: 6,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.dividerAndInactive.withOpacity(0.3),
        borderRadius: BorderRadius.circular(3),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: progress,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primaryAccent,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }



  Widget _buildQuickActions(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildActionBtn(context, 'ic_chapters.png', 'Chapters', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChaptersScreen()));
          }),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _buildActionBtn(context, 'ic_bookmarks.png', 'Bookmarks', () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const BookmarksScreen()));
          }),
        ),

        const SizedBox(width: 8),
        Expanded(
          child: _buildActionBtn(context, 'ic_search.png', 'Explore', () {
            showSearch(context: context, delegate: GitaSearchDelegate());
          }),
        ),
      ],
    );
  }

  Widget _buildActionBtn(BuildContext context, String iconName, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFCD9A5B).withOpacity(0.6),
                width: 2.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFCD9A5B).withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Image.asset(
              'assets/icons/$iconName',
              width: 28,
              height: 28,
              color: AppColors.primaryAccent,
            ),
          ),
          const SizedBox(height: 8),
          Text(label, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
