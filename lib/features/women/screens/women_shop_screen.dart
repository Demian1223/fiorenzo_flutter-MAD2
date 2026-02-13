import 'package:flutter/material.dart';
import 'package:mad2/features/shop/screens/shop_screen.dart';

class WomenShopScreen extends StatelessWidget {
  const WomenShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShopScreen(
      gender: 'women',
      videoAsset: 'assets/videos/Valentine_Women.mp4',
      title: 'WOMEN',
      subtitle: "THIS VALENTINE'S JENNIE",
    );
  }
}
