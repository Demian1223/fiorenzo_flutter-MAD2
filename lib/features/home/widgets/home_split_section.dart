import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class HomeSplitSection extends StatefulWidget {
  const HomeSplitSection({super.key});

  @override
  State<HomeSplitSection> createState() => _HomeSplitSectionState();
}

class _HomeSplitSectionState extends State<HomeSplitSection> {
  late VideoPlayerController _womenController;
  late VideoPlayerController _menController;
  bool _isWomenInitialized = false;
  bool _isMenInitialized = false;

  @override
  void initState() {
    super.initState();
    // Initialize Women's Video
    _womenController =
        VideoPlayerController.asset(
            'assets/videos/women_subhero.mp4',
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
            ), // Allow concurrent playback
          )
          ..initialize()
              .then((_) {
                _womenController.setLooping(true);
                _womenController.setVolume(0.0); // Ensure muted
                _womenController.play();
                if (mounted)
                  setState(() {
                    _isWomenInitialized = true;
                  });
              })
              .catchError((error) {
                debugPrint("Error initializing women video: $error");
              });

    // Enforce playback for Women
    _womenController.addListener(() {
      if (_womenController.value.isInitialized &&
          !_womenController.value.isPlaying) {
        _womenController.play();
      }
    });

    // Initialize Men's Video
    _menController =
        VideoPlayerController.asset(
            'assets/videos/men_subhero.mp4',
            videoPlayerOptions: VideoPlayerOptions(
              mixWithOthers: true,
            ), // Allow concurrent playback
          )
          ..initialize()
              .then((_) {
                _menController.setLooping(true);
                _menController.setVolume(0.0); // Ensure muted
                _menController.play();
                if (mounted)
                  setState(() {
                    _isMenInitialized = true;
                  });
              })
              .catchError((error) {
                debugPrint("Error initializing men video: $error");
              });

    // Enforce playback for Men
    _menController.addListener(() {
      if (_menController.value.isInitialized &&
          !_menController.value.isPlaying) {
        _menController.play();
      }
    });
  }

  @override
  void dispose() {
    _womenController.dispose();
    _menController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Expanded(
            child: _buildSection(
              context,
              'Women\'s Collection',
              _womenController,
              _isWomenInitialized,
            ),
          ),
          Expanded(
            child: _buildSection(
              context,
              'Men\'s Collection',
              _menController,
              _isMenInitialized,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    VideoPlayerController controller,
    bool isInitialized,
  ) {
    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Video Background
          Positioned.fill(
            child: Container(
              color: Colors.grey[900],
              child: isInitialized
                  ? FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width: controller.value.size.width,
                        height: controller.value.size.height,
                        child: VideoPlayer(controller),
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white10),
                    ),
            ),
          ),

          // 2. Dark Overlay (0.4 opactiy)
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),

          // 3. Content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title.toUpperCase(),
                  style: GoogleFonts.cormorantGaramond(
                    color: Colors.white,
                    fontSize: 28,
                    letterSpacing: 4.0,
                    fontWeight: FontWeight.w300,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    side: BorderSide(color: Colors.white.withOpacity(0.8)),
                    backgroundColor: Colors.white.withOpacity(0.1),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: Text(
                    'EXPLORE',
                    style: GoogleFonts.cormorantGaramond(
                      color: Colors.white,
                      letterSpacing: 3.0,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
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
