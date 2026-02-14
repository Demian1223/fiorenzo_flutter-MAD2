import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeWorld extends StatelessWidget {
  const HomeWorld({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> items = [
      {'title': 'Shoes', 'image': 'assets/images/OTHER/HERO_IMAGE_1.png'},
      {'title': 'Bags', 'image': 'assets/images/OTHER/HERO_IMAGE_3.png'},
      {'title': 'Accessories', 'image': 'assets/images/OTHER/HERO_IMAGE_4.png'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          Text(
            'OUR WORLD',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 36,
              fontWeight: FontWeight.w300,
              letterSpacing: 4.0,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 64),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 48),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  AspectRatio(
                    aspectRatio: 3 / 4,
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      child: Image.asset(
                        items[index]['image']!,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          color: Theme.of(context).colorScheme.surface,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    items[index]['title']!.toUpperCase(),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      letterSpacing: 1.0,
                      color: Theme.of(context).colorScheme.onSurface,
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
