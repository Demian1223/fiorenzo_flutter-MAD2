import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/products/models/product_model.dart';
import 'package:mad2/features/products/providers/product_provider.dart';
import 'package:mad2/features/products/screens/product_detail_screen.dart';
import 'package:mad2/features/shop/widgets/hero_video_section.dart';
import 'package:provider/provider.dart';

class ShopScreen extends StatefulWidget {
  final String gender; // 'men' or 'women'
  final String videoAsset;
  final String title;
  final String subtitle;

  const ShopScreen({
    super.key,
    required this.gender,
    required this.videoAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (provider.items.isEmpty) {
        provider.fetchProducts();
      }
    });
  }

  void _onScroll() {
    final provider = Provider.of<ProductProvider>(context, listen: false);
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!provider.isLoading && provider.hasMore) {
        provider.loadMore();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Consumer<ProductProvider>(
        builder: (context, provider, child) {
          final filteredProducts = provider.getByGender(widget.gender);

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // 1. Hero Section
              SliverToBoxAdapter(
                child: HeroVideoSection(
                  videoAsset: widget.videoAsset,
                  title: widget.title,
                  subtitle: widget.subtitle,
                ),
              ),

              // 2. Offline Mode Banner
              if (provider.isOffline)
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Offline Mode – Showing Cached Products',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.cormorantGaramond(
                        color: Colors.white,
                        fontSize: 12,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),

              // 3. Product Grid
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55, // Luxury proportion
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 24,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      if (index == filteredProducts.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return ProductCard(product: filteredProducts[index]);
                    },
                    childCount:
                        filteredProducts.length + (provider.hasMore ? 1 : 0),
                  ),
                ),
              ),

              // Bottom padding
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductModel product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        color: Theme.of(context).colorScheme.surface, // Card background
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: CachedNetworkImage(
                  imageUrl: product.fullImageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Container(color: Theme.of(context).colorScheme.surface),
                  errorWidget: (context, url, error) => Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Icon(
                      Icons.broken_image,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Brand
                  Text(
                    product.brandName.toUpperCase(),
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.0,
                      color: Theme.of(
                        context,
                      ).colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Name
                  Text(
                    product.name,
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Price
                  Text(
                    '\$${product.price}',
                    style: GoogleFonts.cormorantGaramond(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
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
