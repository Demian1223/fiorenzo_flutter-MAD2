import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/men/screens/men_shop_screen.dart';
import 'package:mad2/features/products/providers/product_provider.dart';
import 'package:mad2/features/products/screens/product_detail_screen.dart';
import 'package:mad2/features/women/screens/women_shop_screen.dart';
import 'package:provider/provider.dart';

class HomeSignatureStyles extends StatelessWidget {
  const HomeSignatureStyles({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      color: Theme.of(context).scaffoldBackgroundColor,
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 64),

          // Product Grid (Real Data)
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              final products = provider.items.take(4).toList();

              if (products.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.55,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 32,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Container(
                            color: Theme.of(context).colorScheme.surface,
                            child: product.fullImageUrl.isNotEmpty
                                ? CachedNetworkImage(
                                    imageUrl: product.fullImageUrl,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) =>
                                        Container(color: Colors.grey[200]),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                          color: Colors.grey[200],
                                          child: const Icon(
                                            Icons.broken_image,
                                            size: 40,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  )
                                : const Center(
                                    child: Icon(Icons.image_not_supported),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          product.brandName.toUpperCase(),
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 10,
                            color: Theme.of(
                              context,
                            ).colorScheme.onSurface.withValues(alpha: 0.6),
                            letterSpacing: 2.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.name,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product
                              .price, // Assuming price is a formatted string or add 'LKR' if needed
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 14,
                            color: const Color(0xFF8B0000),
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 64),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: _buildViewMoreButton(
                  context,
                  'VIEW MORE MEN\'S',
                  const MenShopScreen(),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildViewMoreButton(
                  context,
                  'VIEW MORE WOMEN\'S',
                  const WomenShopScreen(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildViewMoreButton(BuildContext context, String text, Widget page) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: BorderSide(color: Colors.black.withOpacity(0.1)),
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: GoogleFonts.cormorantGaramond(
          fontSize: 10,
          color: Colors.black,
          letterSpacing: 2.0, // Reduced slightly to help fit
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
