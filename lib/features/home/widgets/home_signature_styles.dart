import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeSignatureStyles extends StatelessWidget {
  const HomeSignatureStyles({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      color: Colors.white,
      child: Column(
        children: [
          // Header
          Text(
            'SELECTED PIECES',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 10,
              color: const Color(0xFF8B0000), // Dark Red
              letterSpacing: 4.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'SIGNATURE STYLES',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 36,
              fontWeight: FontWeight.w300,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 64),

          // Product Grid (Placeholder logic)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.55,
              crossAxisSpacing: 16,
              mainAxisSpacing: 32,
            ),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                      color: Colors.grey[50], // Placeholder bg
                      child: Image.asset(
                        'assets/images/product_${index + 1}.jpg', // Placeholder
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[300],
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'FIORENZO',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 10,
                      color: Colors.grey,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Luxury Item ${index + 1}',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'LKR ${25000 + (index * 5000)}',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 14,
                      color: const Color(0xFF8B0000),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 64),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildViewMoreButton('VIEW MORE MEN\'S'),
              const SizedBox(width: 16),
              _buildViewMoreButton('VIEW MORE WOMEN\'S'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewMoreButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text(
        text,
        style: GoogleFonts.cormorantGaramond(
          fontSize: 10,
          color: Colors.black,
          letterSpacing: 3.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
