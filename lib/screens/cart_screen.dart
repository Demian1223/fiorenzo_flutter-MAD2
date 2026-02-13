import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/providers/cart_provider.dart';
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'YOUR BAG',
          style: GoogleFonts.cormorantGaramond(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false, // Hide back button on main tab
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
                          color: Colors.grey[100],
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
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${product?.price ?? '0'} LKR',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Qty: ${item.quantity}',
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Remove
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
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
                decoration: const BoxDecoration(
                  border: Border(top: BorderSide(color: Colors.black12)),
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
                          ),
                        ),
                        Text(
                          '${cart.total.toStringAsFixed(2)} LKR',
                          style: GoogleFonts.cormorantGaramond(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/checkout/summary');
                        },
                        child: Text(
                          'CHECKOUT',
                          style: GoogleFonts.cormorantGaramond(
                            color: Colors.white,
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
