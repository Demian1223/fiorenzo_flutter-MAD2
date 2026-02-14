import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/cart/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    debugPrint("CartScreen: initState");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint("CartScreen: Fetching cart...");
      Provider.of<CartProvider>(context, listen: false).fetchCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("CartScreen: build");
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'YOUR BAG',
          style: GoogleFonts.cormorantGaramond(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        automaticallyImplyLeading:
            true, // Show back button when pushed as a sub-page
      ),
      body: Consumer<CartProvider>(
        builder: (context, cart, child) {
          debugPrint(
            "CartScreen: Consumer build isLoading=${cart.isLoading} error=${cart.error} items=${cart.items.length}",
          );

          if (cart.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (cart.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text("Error loading cart: ${cart.error}"),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => cart.fetchCart(),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            );
          }

          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: Colors.grey[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your bag is empty',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: cart.items.length,
                  separatorBuilder: (c, i) => const Divider(height: 32),
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final product = item.product;
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        Container(
                          width: 80,
                          height: 100,
                          color: Theme.of(context).colorScheme.surface,
                          child:
                              product != null && product.fullImageUrl.isNotEmpty
                              ? Image.network(
                                  product.fullImageUrl,
                                  fit: BoxFit.cover,
                                )
                              : const Icon(Icons.image_not_supported),
                        ),
                        const SizedBox(width: 16),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product?.name ?? 'Unknown Product',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product?.price ?? '0'} LKR',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 14,
                                  color: Theme.of(context).colorScheme.onSurface
                                      .withValues(alpha: 0.6),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Text(
                                    'QUANTITY',
                                    style: GoogleFonts.cormorantGaramond(
                                      fontSize: 12,
                                      color: Colors.grey,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    height: 30,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<int>(
                                        value: item.quantity,
                                        icon: const Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 16,
                                        ),
                                        style: GoogleFonts.cormorantGaramond(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        onChanged: (newValue) {
                                          if (newValue != null &&
                                              newValue != item.quantity) {
                                            cart.updateQuantity(
                                              item.id,
                                              newValue,
                                            );
                                          }
                                        },
                                        items:
                                            List.generate(
                                              10,
                                              (index) => index + 1,
                                            ).map<DropdownMenuItem<int>>((
                                              int value,
                                            ) {
                                              return DropdownMenuItem<int>(
                                                value: value,
                                                child: Text(
                                                  value.toString(),
                                                  style:
                                                      GoogleFonts.cormorantGaramond(
                                                        color: Colors.black,
                                                      ),
                                                ),
                                              );
                                            }).toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Remove
                        IconButton(
                          icon: Icon(
                            Icons.close,
                            size: 20,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                          onPressed: () {
                            cart.removeFromCart(item.id);
                          },
                        ),
                      ],
                    );
                  },
                ),
              ),
              // Footer
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Theme.of(context).dividerColor),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'TOTAL',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          '${cart.total.toStringAsFixed(2)} LKR',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout');
                        },
                        child: Text(
                          'CHECKOUT',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 16,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
