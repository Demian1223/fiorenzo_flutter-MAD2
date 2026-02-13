import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeFeaturedArticle extends StatelessWidget {
  const HomeFeaturedArticle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      child: Column(
        children: [
          // Image
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Container(
              color: Colors.grey[100],
              child: Image.asset(
                'assets/images/OTHER/heroside.png',
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(color: Colors.grey[300]),
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Text Content
          Text(
            'THE SEASON OF LOVE',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            'FIORENZO turns the dating ritual inward in a new campaign that reframes love as a relationship with oneself. Through intimate silhouettes and quiet moments, the House explores self-connection as the most enduring form of romance.',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              height: 1.6,
              fontWeight: FontWeight.w300,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
