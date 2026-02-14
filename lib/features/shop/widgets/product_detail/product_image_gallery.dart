import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;

  const ProductImageGallery({super.key, required this.images});

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      height: 500, // Min height as requested
      constraints: const BoxConstraints(minHeight: 500),
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              return CachedNetworkImage(
                imageUrl: widget.images[index],
                fit: BoxFit.contain,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Center(
                  child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
                ),
              );
            },
          ),

          // Dots Indicator
          if (widget.images.length > 1)
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(widget.images.length, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentIndex == index
                          ? Colors.black
                          : Colors.grey.withOpacity(0.5),
                    ),
                  );
                }),
              ),
            ),

          // Arrows
          if (widget.images.length > 1) ...[
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 16),
                    onPressed: () => _controller.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
