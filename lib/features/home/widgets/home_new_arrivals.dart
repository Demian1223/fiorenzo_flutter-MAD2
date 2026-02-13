import 'package:flutter/material.dart';
import 'package:mad2/core/constants/app_colors.dart';

class HomeNewArrivals extends StatelessWidget {
  const HomeNewArrivals({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Text(
              'NEW ARRIVALS',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(letterSpacing: 1.5),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 16,
              mainAxisSpacing: 24,
            ),
            itemCount: 4, // Display 4 products for now
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Container(
                      color: AppColors.cardSurface,
                      child: const Center(
                        child: Icon(Icons.image, size: 50, color: Colors.grey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'LUXURY HANDBAG',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '\$ 2,450.00',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
