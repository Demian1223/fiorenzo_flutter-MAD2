import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/widgets/video_hero.dart';

class EthicsScreen extends StatelessWidget {
  const EthicsScreen({super.key});

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
                videoAsset: 'assets/videos/Ethics.mp4',
                title: 'Ethics & Responsibility',
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
                    '"At FIORENZO, ethics are not a trend. They are the foundation of everything we do."',
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
                    'Luxury should feel good — not just in how it looks, but in how it is made, sourced, and delivered.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.8,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Responsible Sourcing
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Responsible Sourcing'.toUpperCase(),
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          color: const Color(0xFF8B0000),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Our collections are carefully sourced through trusted suppliers, with a focus on quality materials, responsible production, and thoughtful selection. We value craftsmanship over mass production and quality over excess.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildBulletPoint('Craftsmanship over mass production'),
                      _buildBulletPoint('Quality over excess'),
                      _buildBulletPoint(
                        'Long-lasting design over fast fashion cycles',
                      ),
                    ],
                  ),
                  const SizedBox(height: 48),
                  // Image/Quote Placeholder
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
                      '"Each piece is chosen with intention — not volume."',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 28,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Fair Pricing
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFEEEEEE)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'FAIR PRICING, WITHOUT COMPROMISE',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 30, // Slightly smaller to fit mobile
                            color: Colors.grey[900],
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'We believe ethical fashion also means honest pricing. By sourcing directly and minimizing unnecessary intermediaries, we avoid inflated markups that disconnect price from real value.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            height: 1.8,
                          ),
                        ),
                        const SizedBox(height: 32),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          alignment: WrapAlignment.center,
                          children: [
                            _buildBadge('Premium Quality'),
                            _buildBadge('Transparent Value'),
                            _buildBadge('Fair Access'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        Text(
                          '"Luxury should not rely on exploitation."',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 24,
                            fontStyle: FontStyle.italic,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 64),

                  // Conscious Logistics
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
                      '"Efficiency is part of sustainability."',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 28,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[400],
                      ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CONSCIOUS LOGISTICS',
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 32,
                          color: const Color(0xFF8B0000),
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Our products are shipped directly from the United States to Sri Lanka, using efficient logistics to reduce waste, delays, and unnecessary handling.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.8,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'We focus on streamlined shipping, responsible packaging, and careful handling from origin to delivery.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                          height: 1.8,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 64),
                  const Divider(color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 64),

                  // Community & Closing
                  Text(
                    'RESPECT FOR OUR CUSTOMERS & COMMUNITY',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 28,
                      color: Colors.grey[800],
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'We are committed to honest product descriptions, clear communication, and reliable island-wide delivery. Trust is earned — and we protect it.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      height: 1.8,
                    ),
                  ),

                  const SizedBox(height: 48),
                  Text(
                    'OUR COMMITMENT',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      color: const Color(0xFF8B0000),
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '"Ethical fashion is a journey — not a claim.\nAt FIORENZO, we continue to evolve, improve, and choose responsibility wherever possible."',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 28,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[800],
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'TRUE LUXURY IS BUILT ON INTEGRITY, INTENTION, AND RESPECT.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                      letterSpacing: 2.0,
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

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0),
            child: Icon(Icons.circle, size: 6, color: Color(0xFF8B0000)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.cormorantGaramond(
                fontSize: 20,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Text(
        text,
        style: GoogleFonts.cormorantGaramond(
          fontSize: 18,
          color: const Color(0xFF8B0000),
        ),
      ),
    );
  }
}
