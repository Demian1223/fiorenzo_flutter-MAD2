import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ApiService _apiService = ApiService();
  Product? _product;
  bool _isLoading = true;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _fetchProductDetails();
  }

  Future<void> _fetchProductDetails() async {
    final product = await _apiService.getProduct(widget.productId);
    setState(() {
      _product = product;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_product == null) {
      return const Scaffold(body: Center(child: Text("Product not found")));
    }

    // Placeholder image list (since API might return single URL)
    final images = [
      _product!.imageUrl ?? 'assets/images/product_placeholder.jpg',
    ];
    // If API provided multiple images, we would use them here.

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(""), // Transparent
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 1) Image Gallery Section
            Container(
              height: 500, // or 60% of screen height
              width: double.infinity,
              color: const Color(0xFFF5F5F5),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    itemCount: images.length,
                    onPageChanged: (index) =>
                        setState(() => _currentImageIndex = index),
                    itemBuilder: (context, index) {
                      return Image.network(
                        images[index],
                        fit: BoxFit.contain, // Luxury look
                        errorBuilder: (c, e, s) => Image.asset(
                          'assets/images/product_placeholder.jpg',
                        ),
                      );
                    },
                  ),
                  if (images.length > 1)
                    Positioned(
                      bottom: 20,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: images.asMap().entries.map((entry) {
                          return Container(
                            width: 6,
                            height: 6,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _currentImageIndex == entry.key
                                  ? Colors.black
                                  : Colors.grey.withOpacity(0.5),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                ],
              ),
            ),

            // 2) Details Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "FIORENZO",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 12,
                      letterSpacing: 2.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _product!.name,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 42,
                      height: 1.1,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "LKR ${(_product!.price).toStringAsFixed(0)}",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 20,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Info Section A
                  Text(
                    "PRODUCT DETAILS",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _product!.description ?? "No description available.",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Info Section B
                  Text(
                    "SHIPPING & RETURNS",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 12,
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Complimentary shipping on all orders. Returns accepted within 30 days.",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 16,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // 3) Primary CTA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Add to Cart
                    Provider.of<CartProvider>(
                      context,
                      listen: false,
                    ).addToCart(_product!.id, 1);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Added to Bag")),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ADD TO BAG",
                        style: GoogleFonts.cormorantGaramond(
                          fontSize: 14,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(Icons.arrow_forward, size: 16),
                    ],
                  ),
                ),
              ),
            ),

            // 4) You May Also Like
            const Divider(height: 64, thickness: 1, color: Color(0xFFEEEEEE)),
            Padding(
              padding: const EdgeInsets.only(bottom: 64),
              child: Column(
                children: [
                  Text(
                    "You May Also Like",
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 8, bottom: 32),
                    width: 40,
                    height: 1,
                    color: Colors.black,
                  ),
                  // Placeholder Related Products
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 160,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  color: Colors.grey[100],
                                  child: Image.asset(
                                    'assets/images/related_placeholder.jpg',
                                    fit: BoxFit.cover,
                                    errorBuilder: (c, e, s) => const SizedBox(),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "FIORENZO",
                                style: GoogleFonts.cormorantGaramond(
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                  color: Colors.grey,
                                ),
                              ),
                              const Text("Related Item ..."),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
