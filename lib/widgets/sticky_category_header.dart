import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StickyCategoryHeader extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final Function(int) onCategorySelected;

  const StickyCategoryHeader({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.95),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Row(
              children: categories.asMap().entries.map((entry) {
                final index = entry.key;
                final category = entry.value;
                final isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () => onCategorySelected(index),
                  child: Container(
                    margin: const EdgeInsets.only(right: 32),
                    decoration: BoxDecoration(
                      border: isSelected
                          ? const Border(
                              bottom: BorderSide(
                                color: Colors.black,
                                width: 1.0,
                              ),
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      category.toUpperCase(),
                      style: GoogleFonts.cormorantGaramond(
                        fontSize: 13,
                        letterSpacing: 1.5,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? Colors.black : Colors.grey,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE)),
        ],
      ),
    );
  }
}
