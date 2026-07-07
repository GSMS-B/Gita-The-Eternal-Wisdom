import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import '../core/theme/app_colors.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _audioError = false;

  @override
  void initState() {
    super.initState();
    
    // Animation for the Sound Wave Ripple
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4), // A slow, deep breath rhythm
    )..repeat();

    // Initialize Audio Player
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.play(AssetSource('audio/om.ogg'));
      if (mounted) {
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
      if (mounted) {
        setState(() {
          _audioError = true;
        });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioPlayer.stop();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF7), // Soothing ivory/cream background
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.primaryAccent),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // Background ambient gradient
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFFF3E0).withOpacity(0.5), // Soft orange/warm center
                  const Color(0xFFFDFBF7), // Cream edges
                ],
                radius: 1.2,
              ),
            ),
          ),
          
          // The Ripple Animation and Deity
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer Ripple 1 (Blue)
                    _buildRipple(_controller.value, const Color(0xFF4A90E2)),
                    // Outer Ripple 2 (Orange)
                    _buildRipple((_controller.value + 0.33) % 1.0, const Color(0xFFF39C12)),
                    // Outer Ripple 3 (Yellow)
                    _buildRipple((_controller.value + 0.66) % 1.0, const Color(0xFFF1C40F)),
                    
                    // Central glowing aura
                    Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFFF39C12).withOpacity(0.2),
                            blurRadius: 40 + (_controller.value * 20),
                            spreadRadius: 10 + (_controller.value * 10),
                          ),
                        ],
                      ),
                    ),
                    
                    // Beautiful Golden Ring around the portrait
                    Container(
                      width: 320,
                      height: 320,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFCD9A5B).withOpacity(0.8), // Rich cream/gold border
                          width: 8.0,
                        ),
                      ),
                      child: ClipOval(
                        child: Align(
                          alignment: Alignment.bottomCenter, // Aligns the cut-off legs to the bottom curve of the circle
                          child: Image.asset(
                            'assets/images/illustrations/meditation_deity.png',
                            width: 300,
                            fit: BoxFit.cover, 
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          // Status indicator or error message at bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                if (_audioError)
                  const Text(
                    'Could not play audio.\nPlease ensure om.ogg is placed in assets/audio/',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.redAccent, fontSize: 14),
                  )
                else
                  Text(
                    _isPlaying ? 'Meditating...' : 'Loading mantra...',
                    style: const TextStyle(
                      color: AppColors.textMain,
                      fontSize: 16,
                      letterSpacing: 2.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRipple(double phase, Color color) {
    // phase goes from 0.0 to 1.0
    // Starts small (behind the 220x220 circle) and grows outwards
    final scale = 0.5 + (phase * 1.5); 
    // Opacity fades out completely as it reaches the edge to prevent snapping
    final opacity = 0.4 * (1.0 - phase);
    
    return Transform.scale(
      scale: scale,
      child: Container(
        width: 320,
        height: 320,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: color.withOpacity(opacity < 0 ? 0 : opacity),
            width: 4.0,
          ),
        ),
      ),
    );
  }
}
