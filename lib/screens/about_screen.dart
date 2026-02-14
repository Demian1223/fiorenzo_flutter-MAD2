import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/widgets/video_hero.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Section
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: const VideoHero(
                videoAsset: 'assets/videos/OurStory.mp4',
                title: 'Our Story',
                height: double.infinity,
              ),
            ),

            // Content Section
            Container(
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
              child: Column(
                children: [
                  // Intro
                  Text(
                    '"Luxury fashion has always been admired but not always accessible."',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 100,
                    height: 1,
                    color: const Color(0xFF8B0000),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'At FIORENZO, we noticed a gap. A gap where premium design, global fashion houses, and timeless style existed — yet remained out of reach for many who truly appreciated it. Luxury should not feel distant. It should feel possible.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.8,
                      letterSpacing: 0.5,
                      fontFamily: 'Inter', // Fallback to default sans
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Mission
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Redefining Access'.toUpperCase(),
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          color: const Color(0xFF8B0000),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.8,
                          ),
                          children: const [
                            TextSpan(
                              text:
                                  'Inspired by iconic fashion houses such as ',
                            ),
                            TextSpan(
                              text: 'Gucci, Dior, Louis Vuitton, and Chanel',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text:
                                  ', FIORENZO was founded with one clear purpose: to make elevated fashion more accessible, transparent, and fair for Sri Lanka.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'We carefully curate luxury-inspired collections that reflect international trends, refined craftsmanship, and timeless elegance — without unnecessary markups.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Quote Box
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE5E5E5)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Text(
                          '"We carefully curate luxury-inspired collections that reflect international trends."',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 64),

                  // Sourcing
                  Column(
                    children: [
                      Text(
                        'Sourced Globally.\nDelivered Locally.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          color: Colors.grey[900],
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Our products are sourced and shipped directly from the United States, allowing us to maintain strict quality standards while reducing intermediaries.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Grid
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildGridItem('Better Pricing'),
                          _buildGridItem('Authentic Materials'),
                          _buildGridItem('Careful Logistics'),
                          _buildGridItem('No Compromise'),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Delivery
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 64, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'ISLAND-WIDE DELIVERY',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 28,
                      color: Colors.grey[800],
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Whether you’re in Colombo or anywhere across Sri Lanka, FIORENZO delivers island-wide, bringing global fashion directly to your doorstep.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.8,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    '"Luxury is not a location. It’s a feeling."',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 26,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF8B0000),
                    ),
                  ),
                ],
              ),
            ),

            // Values / Closing
            Container(
              color: const Color(0xFFFAFAFA),
              padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 24),
              child: Column(
                children: [
                  Text(
                    'THE FIORENZO PROMISE',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 32,
                      color: Colors.grey[900],
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),
                  _buildPromiseItem('Confidence without excess'),
                  const SizedBox(height: 16),
                  _buildPromiseItem('Elegance without barriers'),
                  const SizedBox(height: 16),
                  _buildPromiseItem('Style without compromise'),
                  const SizedBox(height: 80),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 64),
                  Text(
                    'Welcome to a new standard of luxury.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 28,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FIORENZO',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 48,
                      color: const Color(0xFF8B0000),
                      letterSpacing: 4.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(String text) {
    return Container(
      width:
          150, // Approx roughly almost half width for 2 column feel on mobile
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: GoogleFonts.cormorantGaramond(
          fontSize: 18,
          color: const Color(0xFF8B0000),
        ),
      ),
    );
  }

  Widget _buildPromiseItem(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: const BoxDecoration(
            color: Color(0xFF8B0000),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(text, style: TextStyle(fontSize: 18, color: Colors.grey[600])),
      ],
    );
  }
}
