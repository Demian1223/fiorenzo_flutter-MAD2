import 'package:flutter/material.dart';
import 'package:mad2/features/home/widgets/home_featured_article.dart';
import 'package:mad2/features/home/widgets/home_hero.dart';
import 'package:mad2/features/home/widgets/home_signature_styles.dart';
import 'package:mad2/features/home/widgets/home_split_section.dart';
import 'package:mad2/features/home/widgets/home_world.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        children: [
          HomeHero(),
          HomeSignatureStyles(),
          HomeWorld(),
          HomeSplitSection(),
          HomeFeaturedArticle(),
          SizedBox(height: 40),
        ],
      ),
    );
  }
}
