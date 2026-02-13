import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RelatedProductsGrid extends StatelessWidget {
  const RelatedProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40),
      child: Column(
        children: [
          const Divider(color: Colors.black12, height: 1),
          const SizedBox(height: 40),
          Text(
            "You May Also Like",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 24,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Container(height: 1, width: 60, color: Colors.black26),
          const SizedBox(height: 32),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Image.asset(
                      'assets/images/related_placeholder.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey[200]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "FIORENZO",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      letterSpacing: 1.0,
                    ),
                  ),
                  Text(
                    "Classic Shirt",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    "\$120.00",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
