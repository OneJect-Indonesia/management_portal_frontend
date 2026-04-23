import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class CategoryCard extends StatelessWidget {
  final String category;
  final int itemCount;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.category,
    required this.itemCount,
    required this.isSelected,
    required this.onTap,
  });

  IconData _getCategoryIcon(String categoryTitle) {
    switch (categoryTitle.toLowerCase()) {
      case 'sd':
        return Icons.shopping_cart_rounded;
      case 'mm':
        return Icons.inventory_2_rounded;
      case 'fico':
        return Icons.account_balance_wallet_rounded;
      case 'pp':
        return Icons.precision_manufacturing_rounded;
      default:
        return Icons.dashboard_customize_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
        border: Border.all(
          color: isSelected ? AppColors.primary : Colors.cyan.shade50,
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.white.withOpacity(0.2)
                        : AppColors.background,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    _getCategoryIcon(category),
                    color: isSelected ? AppColors.white : AppColors.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.toUpperCase(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? AppColors.white : AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '$itemCount Systems Available',
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected
                              ? AppColors.white.withOpacity(0.8)
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: isSelected
                      ? AppColors.white
                      : AppColors.textSecondary.withOpacity(0.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
