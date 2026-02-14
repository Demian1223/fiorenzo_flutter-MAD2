import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/products/models/product_model.dart';
import 'package:mad2/features/products/providers/product_provider.dart';
import 'package:mad2/features/products/screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class RelatedProductsGrid extends StatelessWidget {
  final ProductModel currentProduct;

  const RelatedProductsGrid({super.key, required this.currentProduct});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, child) {
        // Get 4 products, excluding the current one
        final relatedProducts = provider.items
            .where((p) => p.id != currentProduct.id)
            .take(4)
            .toList();

        if (relatedProducts.isEmpty) {
          return const SizedBox.shrink();
        }

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
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Container(height: 1, width: 60, color: Colors.black26),
              const SizedBox(height: 32),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: relatedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                ),
                itemBuilder: (context, index) {
                  final product = relatedProducts[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to this product
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: product.fullImageUrl.startsWith('assets/')
                              ? Image.asset(
                                  product.fullImageUrl,
                                  fit: BoxFit.cover,
                                )
                              : CachedNetworkImage(
                                  imageUrl: product.fullImageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: Colors.grey[200]),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image),
                                      ),
                                ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          product.brandName.toUpperCase(),
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            letterSpacing: 1.0,
                          ),
                        ),
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${product.price} LKR',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
