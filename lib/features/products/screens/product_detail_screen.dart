import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mad2/features/products/models/product_model.dart';
import 'package:mad2/features/shop/widgets/product_detail/product_image_gallery.dart';
import 'package:mad2/features/shop/widgets/product_detail/product_info_panel.dart';
import 'package:mad2/features/shop/widgets/product_detail/related_products_grid.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            iconTheme: IconThemeData(
              color: Theme.of(context).colorScheme.onSurface,
            ),
            pinned: true,
            title: Text(
              product.brandName.toUpperCase(),
              style: GoogleFonts.cormorantGaramond(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              ),
            ),
            centerTitle: true,
          ),
        ],
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. Gallery
              ProductImageGallery(images: product.fullImages),

              // 2. Info Panel
              ProductInfoPanel(product: product),

              const Divider(height: 1, color: Colors.black12),

              // 3. Related Products
              RelatedProductsGrid(currentProduct: product),
            ],
          ),
        ),
      ),
    );
  }
}
