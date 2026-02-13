import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class HeroVideoSection extends StatefulWidget {
  final String videoAsset;
  final String title;
  final String subtitle;

  const HeroVideoSection({
    super.key,
    required this.videoAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  State<HeroVideoSection> createState() => _HeroVideoSectionState();
}

class _HeroVideoSectionState extends State<HeroVideoSection> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize()
          .then((_) {
            _controller.setLooping(true);
            _controller.setVolume(0.0); // Muted
            _controller.play();
            setState(() {});
          })
          .catchError((error) {
            debugPrint("Video initialization failed: $error");
          });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.85, // 85% of screen height
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Video Background
          _controller.value.isInitialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : Container(color: Colors.black), // Loading state placeholder
          // 2. Black Overlay (20% Opacity)
          Container(color: Colors.black.withOpacity(0.2)),

          // 3. Gradient Overlay (Bottom Up)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black87, // Stronger at bottom
                  Colors.transparent,
                ],
                stops: [0.0, 0.6],
              ),
            ),
          ),

          // 4. Content (Bottom Left)
          Positioned(
            left: 24,
            bottom: 60,
            right: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.subtitle.toUpperCase(),
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 14,
                    letterSpacing: 2.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.title,
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 56,
                    height: 1.0,
                    fontWeight: FontWeight.w400, // Lighter luxury feel
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
