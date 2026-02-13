import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_fonts/google_fonts.dart';

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
            _controller.setVolume(0.0);
            _controller.play();
            setState(() {});
          })
          .catchError((error) {
            debugPrint("Video Error: $error");
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
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          _controller.value.isInitialized
              ? VideoPlayer(_controller)
              : Container(color: Colors.black), // Placeholder while loading
          // Overlays
          Container(color: Colors.black.withOpacity(0.2)),

          // Gradient from Left
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),

          // Gradient from Bottom
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.black.withOpacity(0.6), Colors.transparent],
              ),
            ),
          ),

          // Content
          Positioned(
            bottom: 120,
            left: 32,
            right: 32,
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
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 64,
                    height: 1.0,
                    fontWeight: FontWeight.w300,
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
