import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/products/models/product_model.dart';
import 'package:mad2/features/cart/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class ProductInfoPanel extends StatefulWidget {
  final ProductModel product;

  const ProductInfoPanel({super.key, required this.product});

  @override
  State<ProductInfoPanel> createState() => _ProductInfoPanelState();
}

class _ProductInfoPanelState extends State<ProductInfoPanel> {
  int _quantity = 1;

  double get _totalPrice {
    final price = double.tryParse(widget.product.price) ?? 0;
    return price * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(
            widget.product.name,
            style: GoogleFonts.cormorantGaramond(
              fontSize: 32,
              height: 1.1,
              fontWeight: FontWeight.w400,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          // Price
          Text(
            '\$${widget.product.price}',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 40),

          // Quantity Selector
          Row(
            children: [
              Text(
                "QUANTITY",
                style: GoogleFonts.cormorantGaramond(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                height: 36,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: _quantity,
                    icon: const Icon(Icons.keyboard_arrow_down, size: 16),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onChanged: (newValue) {
                      if (newValue != null) {
                        setState(() {
                          _quantity = newValue;
                        });
                      }
                    },
                    items: List.generate(10, (index) => index + 1)
                        .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text(value.toString()),
                          );
                        })
                        .toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

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
            widget.product.description ?? "No description available.",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.8),
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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Complimentary shipping on all orders. Returns accepted within 30 days.",
            style: GoogleFonts.cormorantGaramond(
              fontSize: 16,
              color: Theme.of(
                context,
              ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                  final success = await cart.addToCart(
                    widget.product.id,
                    quantity: _quantity,
                  );
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
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ADD TO BAG - \$${_totalPrice.toStringAsFixed(2)}",
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
