import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoHero extends StatefulWidget {
  final String videoAsset;
  final String title;
  final double height;

  const VideoHero({
    super.key,
    required this.videoAsset,
    required this.title,
    this.height =
        500, // Default height, can be set to MediaQuery.of(context).size.height for fullscreen
  });

  @override
  State<VideoHero> createState() => _VideoHeroState();
}

class _VideoHeroState extends State<VideoHero> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize()
          .then((_) {
            setState(() {
              _isInitialized = true;
            });
            _controller.setLooping(true);
            _controller.setVolume(0.0);
            _controller.play();
          })
          .catchError((error) {
            debugPrint("Video initialization error: $error");
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
      height: widget.height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Video Background
          if (_isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _controller.value.size.width,
                height: _controller.value.size.height,
                child: VideoPlayer(_controller),
              ),
            )
          else
            Container(color: Colors.black), // Placeholder
          // Overlay
          Container(color: Colors.black.withValues(alpha: 0.3)),

          // Text
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                widget.title.toUpperCase(),
                textAlign: TextAlign.center,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 56, // Adjusted for mobile
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2.0,
                  shadows: [
                    const Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(2.0, 2.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
