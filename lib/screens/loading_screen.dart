import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/asset_paths.dart';
import '../core/theme/app_colors.dart';
import '../core/theme/app_spacing.dart';
import '../core/theme/app_text_styles.dart';
import '../providers/chapters_provider.dart';
import 'home_screen.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    
    // Setup the progress animation to take exactly 3 seconds for a smooth effect
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Start the progress bar animation
    _progressController.forward();
    
    // Wait for initial build to complete
    await Future.microtask(() {});
    
    // Load database and chapters
    await context.read<ChaptersProvider>().loadChapters();
    
    // Wait for the animation to complete before transitioning
    await _progressController.forward();
    
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      // Wrap in SafeArea so the camera notch and bottom nav don't cover our floral borders!
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image: using contain ensures the whole image (including borders) is visible
            Center(
              child: Image.asset(
                AssetPaths.loadingBg,
                fit: BoxFit.contain, 
              ),
            ),
            
            // Loader positioned at the bottom, moved down to avoid overlapping the illustration
            Positioned(
              left: AppSpacing.xl,
              right: AppSpacing.xl,
              bottom: 20, 
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final double trackWidth = constraints.maxWidth;
                          const double chariotWidth = 120.0;
                          
                          // Current X position for chariot
                          final double currentX = _progressAnimation.value * (trackWidth - chariotWidth);
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Transform.translate(
                                offset: Offset(currentX, 0),
                                child: Image.asset(
                                  AssetPaths.loadingChariot,
                                  width: chariotWidth,
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Simple, clean loader track
                              Container(
                                height: 8,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: AppColors.cardSurface,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: AppColors.primaryAccent.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: FractionallySizedBox(
                                  alignment: Alignment.centerLeft,
                                  widthFactor: _progressAnimation.value,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryAccent,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }
                      );
                    }
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Loading your spiritual journey...',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontStyle: FontStyle.italic,
                      fontFamily: 'Serif', 
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
