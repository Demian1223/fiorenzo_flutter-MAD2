import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/products/models/product_model.dart';
import 'package:mad2/features/products/providers/product_provider.dart';
import 'package:mad2/features/products/screens/product_detail_screen.dart';
import 'package:mad2/providers/connectivity_provider.dart';
import 'package:provider/provider.dart';

class ProductsScreen extends StatefulWidget {
  final String? genderFilter; // 'men' or 'women' or null for all

  const ProductsScreen({super.key, this.genderFilter});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Fetch products on init if empty
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ProductProvider>(context, listen: false);
      if (provider.items.isEmpty) {
        provider.fetchProducts();
      }

      // Listener for Connectivity Restoration
      final connectivity = Provider.of<ConnectivityProvider>(
        context,
        listen: false,
      );
      connectivity.addListener(() {
        if (!connectivity.isOffline) {
          debugPrint("Connection restored! Refreshing products...");
          // If we are back online, refresh the data to replace cache/dummy
          provider.refresh();
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.genderFilter != null
              ? widget.genderFilter!.toUpperCase()
              : 'PRODUCTS',
          style: GoogleFonts.cormorantGaramond(
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onSurface,
        ),
        actions: [
          Consumer<ProductProvider>(
            builder: (context, provider, child) {
              if (provider.isSyncing) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                );
              }
              return IconButton(
                icon: const Icon(Icons.sync),
                tooltip: 'Sync Offline',
                onPressed: () async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Syncing all products for offline use...'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  await provider.syncAllProducts();
                  if (mounted && provider.error == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('All products synced successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else if (mounted && provider.error != null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Sync failed: ${provider.error}'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              );
            },
          ),
        ],
      ),
      body: Consumer2<ProductProvider, ConnectivityProvider>(
        builder: (context, productProvider, connectivityProvider, child) {
          final filteredProducts = productProvider.getByGender(
            widget.genderFilter,
          );

          final isOffline =
              connectivityProvider.isOffline || productProvider.isOffline;

          return Column(
            children: [
              if (isOffline)
                Container(
                  width: double.infinity,
                  color: const Color(0xFF8b0000), // Deep Red
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: const Text(
                    "Offline Mode – Showing Stored Products",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              if (productProvider.error != null && !isOffline)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    productProvider.error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              Expanded(
                child: filteredProducts.isEmpty && productProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : NotificationListener<ScrollNotification>(
                        onNotification: (ScrollNotification scrollInfo) {
                          if (scrollInfo is ScrollEndNotification &&
                              _scrollController.position.extentAfter == 0) {
                            if (!productProvider.isLoading &&
                                productProvider.hasMore) {
                              productProvider.loadMore();
                            }
                          }
                          return false; // allow up bubbling
                        },
                        child: RefreshIndicator(
                          onRefresh: () => productProvider.fetchProducts(
                            page: 1,
                            refresh: true,
                          ),
                          color: Theme.of(context).colorScheme.primary,
                          child: GridView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.65,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                ),
                            itemCount:
                                filteredProducts.length +
                                (productProvider.hasMore ? 1 : 0),
                            itemBuilder: (context, index) {
                              if (index == filteredProducts.length) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              final product = filteredProducts[index];
                              return ProductCard(product: product);
                            },
                          ),
                        ),
                      ),
              ),
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
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: SizedBox(
                width: double.infinity,
                child: product.fullImageUrl.startsWith('assets/')
                    ? Image.asset(
                        product.fullImageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      )
                    : CachedNetworkImage(
                        imageUrl: product.fullImageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey[200]),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.grey[200],
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Brand
          Text(
            product.brandName.toUpperCase(),
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
              color: Colors.grey,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          // Name
          Text(
            product.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          // Price
          Text(
            '\$${product.price}',
            style: GoogleFonts.cormorantGaramond(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
