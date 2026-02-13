import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/hero_video_section.dart';
import '../widgets/sticky_category_header.dart';
import '../widgets/product_grid.dart';
import 'product_detail_screen.dart';

class WomenShopScreen extends StatefulWidget {
  const WomenShopScreen({super.key});

  @override
  State<WomenShopScreen> createState() => _WomenShopScreenState();
}

class _WomenShopScreenState extends State<WomenShopScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = ["All", "Dresses", "Tops", "Shoes", "Bags"];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    final products = await _apiService.getProducts(gender: 'women');
    setState(() {
      _products = products;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: HeroVideoSection(
              videoAsset: 'assets/videos/Valentine_Women.mp4',
              title: "Women",
              subtitle: "This Valentine’s JENNIE",
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _StickyHeaderDelegate(
              child: StickyCategoryHeader(
                categories: _categories,
                selectedIndex: _selectedCategoryIndex,
                onCategorySelected: (index) {
                  setState(() => _selectedCategoryIndex = index);
                },
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: _isLoading
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : ProductGrid(
                    products: _products,
                    onProductTap: (product) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(productId: product.id),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _StickyHeaderDelegate({required this.child});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => child;

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      true;
}
