import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product.dart';

class ProductGrid extends StatelessWidget {
  final List<Product> products;
  final Function(Product) onProductTap;

  const ProductGrid({
    super.key,
    required this.products,
    required this.onProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      physics: const NeverScrollableScrollPhysics(), // Scroll handled by parent
      shrinkWrap: true,
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65, // Adjust for image aspect ratio
        crossAxisSpacing: 16,
        mainAxisSpacing: 32,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return GestureDetector(
          onTap: () => onProductTap(product),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image
              Expanded(
                child: Container(
                  color: const Color(0xFFF9F9F9),
                  child: Image.network(
                    product.imageUrl ??
                        '', // Use placeholder if empty or handle error
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'assets/images/product_placeholder.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Text
              Text(
                "FIORENZO",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 10,
                  letterSpacing: 1.5,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "LKR ${double.tryParse(product.price)?.toStringAsFixed(0) ?? product.price}",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
