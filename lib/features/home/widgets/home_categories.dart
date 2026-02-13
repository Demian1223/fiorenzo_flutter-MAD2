import 'package:flutter/material.dart';
import 'package:mad2/core/constants/app_colors.dart';

class HomeCategories extends StatelessWidget {
  const HomeCategories({super.key});

  final List<String> categories = const [
    'Women',
    'Men',
    'Bags',
    'Shoes',
    'Accessories',
    'Jewelry',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: categories.length,
          separatorBuilder: (context, index) => const SizedBox(width: 24),
          itemBuilder: (context, index) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.secondary, width: 1),
                    color: AppColors.cardSurface,
                  ),
                  child: const Center(
                    child: Icon(Icons.checkroom, color: AppColors.primary),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  categories[index].toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(letterSpacing: 1.0),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
