import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StickyCategoryHeader extends SliverPersistentHeaderDelegate {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onSelect;

  StickyCategoryHeader({
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
  });

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.white.withOpacity(0.9), // Slightly transparent white
          alignment: Alignment.center,
          child: Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.black12, width: 0.5),
              ),
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = index == selectedIndex;
                return GestureDetector(
                  onTap: () => onSelect(index),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: isSelected
                        ? const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black, width: 2),
                            ),
                          )
                        : null,
                    child: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: GoogleFonts.cormorantGaramond(
                        color: isSelected ? Colors.black : Colors.grey,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        letterSpacing: 1.0,
                      ),
                      child: Text(categories[index].toUpperCase()),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => 60.0;

  @override
  double get minExtent => 60.0;

  @override
  bool shouldRebuild(covariant StickyCategoryHeader oldDelegate) {
    return selectedIndex != oldDelegate.selectedIndex ||
        categories != oldDelegate.categories;
  }
}
