import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/products/models/product_model.dart';
import 'package:mad2/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductInfoPanel extends StatelessWidget {
  final ProductModel product;

  const ProductInfoPanel({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            product.name,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              height: 1.1,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 8),
          // Price
          Text(
            '\$${product.price}',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 40),

          // Section A
          Text(
            "PRODUCT DETAILS",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            product.description ?? "No description available.",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              color: Colors.grey[800],
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),

          // Section B
          Text(
            "SHIPPING & RETURNS",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Complimentary shipping on all orders. Returns accepted within 30 days.",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),

          const SizedBox(height: 48),

          // CTA
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () async {
                debugPrint("ProductInfoPanel: Add to bag clicked");
                final cart = Provider.of<CartProvider>(context, listen: false);
                final messenger = ScaffoldMessenger.of(context);

                messenger.showSnackBar(
                  const SnackBar(
                    content: Text('Adding to bag...'),
                    duration: Duration(milliseconds: 500),
                  ),
                );

                try {
                  final success = await cart.addToCart(product.id, quantity: 1);
                  debugPrint("ProductInfoPanel: addToCart result: $success");

                  if (success) {
                    messenger.showSnackBar(
                      SnackBar(
                        content: const Text('Added to bag'),
                        action: SnackBarAction(
                          label: 'VIEW BAG',
                          onPressed: () =>
                              Navigator.pushNamed(context, '/cart'),
                        ),
                      ),
                    );
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Error"),
                        content: Text("Failed to add to bag: ${cart.error}"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }
                } catch (e, stack) {
                  debugPrint("ProductInfoPanel: Exception $e\n$stack");
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Exception"),
                      content: Text("An error occurred: $e"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("OK"),
                        ),
                      ],
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ADD TO BAG",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
