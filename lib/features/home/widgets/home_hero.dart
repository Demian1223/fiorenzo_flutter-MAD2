import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class HomeHero extends StatefulWidget {
  const HomeHero({super.key});

  @override
  State<HomeHero> createState() => _HomeHeroState();
}

class _HomeHeroState extends State<HomeHero> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  final Map<int, VideoPlayerController> _videoControllers = {};

  final List<Map<String, String>> _slides = [
    {
      'type': 'video',
      'path': 'assets/videos/hero_female.mp4',
      'subtitle': 'DISCOVER THE COLLECTION',
      'title': 'The Shop',
      'cta': 'DISCOVER THE WOMEN',
    },
    {
      'type': 'video',
      'path': 'assets/videos/hero_male.mp4',
      'subtitle': 'NEW ARRIVALS',
      'title': 'Men\'s Collection',
      'cta': 'DISCOVER THE MEN',
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeVideos();
    _startAutoPlay();
  }

  Future<void> _initializeVideos() async {
    for (int i = 0; i < _slides.length; i++) {
      final slide = _slides[i];
      if (slide['type'] == 'video') {
        // Dispose existing if any (safety)
        _videoControllers[i]?.dispose();

        final controller = VideoPlayerController.asset(slide['path']!);
        _videoControllers[i] = controller;

        try {
          await controller.initialize();
          await controller.setLooping(true);
          await controller.setVolume(0.0); // Mute for autoplay
          await controller.play();
          if (mounted) setState(() {});
        } catch (e) {
          debugPrint('Error initializing video ${slide['path']}: $e');
        }
      }
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_currentPage < _slides.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 1500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    for (var controller in _videoControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
              // Ensure video is playing when page changes
              if (_videoControllers.containsKey(index)) {
                _videoControllers[index]?.play();
              }
            },
            itemBuilder: (context, index) {
              final slide = _slides[index];
              final isVideo = slide['type'] == 'video';
              final controller = _videoControllers[index];

              return ClipRect(
                // Ensure no overflow
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // 1. Media Background
                    if (isVideo)
                      Positioned.fill(
                        child: Container(
                          color: Colors.black,
                          child:
                              (controller != null &&
                                  controller.value.isInitialized)
                              ? FittedBox(
                                  fit: BoxFit.cover,
                                  child: SizedBox(
                                    width: controller.value.size.width,
                                    height: controller.value.size.height,
                                    child: VideoPlayer(controller),
                                  ),
                                )
                              : const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white10,
                                  ),
                                ),
                        ),
                      )
                    else
                      Positioned.fill(
                        child: Image.asset(
                          slide['path']!,
                          fit: BoxFit.cover,
                          errorBuilder: (c, e, s) =>
                              Container(color: Colors.grey[900]),
                        ),
                      ),

                    // 2. Dark Overlay (Increased opacity to 0.4 for better visibility)
                    Positioned.fill(
                      child: Container(color: Colors.black.withOpacity(0.4)),
                    ),

                    // 3. Content
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slide['subtitle']!,
                            style: GoogleFonts.cormorantGaramond(
                              color: Colors.white,
                              fontSize: 14,
                              letterSpacing: 4.0,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            slide['title']!,
                            style: GoogleFonts.cormorantGaramond(
                              color: Colors.white,
                              fontSize: 56,
                              letterSpacing: 2.0,
                              fontWeight: FontWeight.w300,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 48),

                          OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 40,
                                vertical: 20,
                              ),
                              side: BorderSide(
                                color: Colors.white.withOpacity(0.6),
                              ),
                              backgroundColor: Colors.white.withOpacity(0.1),
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                            child: Text(
                              slide['cta']!,
                              style: GoogleFonts.cormorantGaramond(
                                color: Colors.white,
                                fontSize: 12,
                                letterSpacing: 3.0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Indicators
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 2,
                    width: 48,
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
