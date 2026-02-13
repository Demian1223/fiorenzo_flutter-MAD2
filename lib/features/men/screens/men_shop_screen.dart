import 'package:flutter/material.dart';
import 'package:mad2/features/shop/screens/shop_screen.dart';

class MenShopScreen extends StatelessWidget {
  const MenShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const ShopScreen(
      gender: 'men',
      videoAsset: 'assets/videos/Valentine_Men.mp4',
      title: 'MEN',
      subtitle: "THIS VALENTINE'S RYAN GOSLING",
    );
  }
}
