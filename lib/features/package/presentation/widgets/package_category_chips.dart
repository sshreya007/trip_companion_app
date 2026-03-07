import 'package:flutter/material.dart';

class PackageCategoryChips extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const PackageCategoryChips({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  static const List<Map<String, dynamic>> categories = [
    {'name': 'beach', 'icon': Icons.beach_access, 'color': Colors.blue},
    {'name': 'adventure', 'icon': Icons.terrain, 'color': Colors.orange},
    {'name': 'cultural', 'icon': Icons.museum, 'color': Colors.purple},
    {'name': 'luxury', 'icon': Icons.diamond, 'color': Colors.amber},
    {'name': 'budget', 'icon': Icons.savings, 'color': Colors.green},
    {'name': 'family', 'icon': Icons.family_restroom, 'color': Colors.pink},
    {'name': 'honeymoon', 'icon': Icons.favorite, 'color': Colors.red},
    {'name': 'group', 'icon': Icons.groups, 'color': Colors.indigo},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50, // ✅ REDUCED from 60
      margin: const EdgeInsets.symmetric(vertical: 10), // ✅ REDUCED from 16
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = selectedCategory == category['name'];

          return GestureDetector(
            onTap: () => onCategorySelected(category['name']),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ), // ✅ REDUCED vertical padding
              decoration: BoxDecoration(
                color: isSelected ? category['color'] : Colors.white,
                borderRadius: BorderRadius.circular(20), // ✅ REDUCED from 25
                border: Border.all(
                  color: isSelected ? category['color'] : Colors.grey[300]!,
                  width: 2,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: (category['color'] as Color).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    category['icon'],
                    size: 18, // ✅ REDUCED from 20
                    color: isSelected ? Colors.white : category['color'],
                  ),
                  const SizedBox(width: 6), // ✅ REDUCED from 8
                  Text(
                    _capitalize(category['name']),
                    style: TextStyle(
                      fontSize: 13, // ✅ REDUCED from 14
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _capitalize(String text) {
    return text[0].toUpperCase() + text.substring(1);
  }
}
