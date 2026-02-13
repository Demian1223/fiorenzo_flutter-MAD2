import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/product.dart';
import '../widgets/hero_video_section.dart';
import '../widgets/sticky_category_header.dart';
import '../widgets/product_grid.dart';
import 'product_detail_screen.dart';

class MenShopScreen extends StatefulWidget {
  const MenShopScreen({super.key});

  @override
  State<MenShopScreen> createState() => _MenShopScreenState();
}

class _MenShopScreenState extends State<MenShopScreen> {
  final ApiService _apiService = ApiService();
  List<Product> _products = [];
  bool _isLoading = true;
  int _selectedCategoryIndex = 0;

  final List<String> _categories = [
    "All",
    "Shirts",
    "Pants",
    "Shoes",
    "Accessories",
  ];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    // Fetch Mens products. filtering by category if implemented on API
    // For now, fetch gender='men'
    final products = await _apiService.getProducts(gender: 'men');
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
              videoAsset: 'assets/videos/Valentine_Men.mp4',
              title: "Men",
              subtitle: "This Valentine’s Ryan Gosling",
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
                  // TODO: Implement category filtering logic
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
                    products:
                        _products, // Filter locally if needed based on _categories[_selectedCategoryIndex]
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
