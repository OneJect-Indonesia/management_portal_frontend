import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flip_card/flip_card.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/dashboard_model.dart';
import '../../core/app_colors.dart';

class FlipCategoryCard extends StatelessWidget {
  final String category;
  final List<MenuItem> items;
  final GlobalKey<FlipCardState> cardKey;
  final VoidCallback onCardTapped;
  final VoidCallback onHeaderTapped;

  const FlipCategoryCard({
    super.key,
    required this.category,
    required this.items,
    required this.cardKey,
    required this.onCardTapped,
    required this.onHeaderTapped,
  });

  IconData _getCategoryIcon(String categoryTitle) {
    switch (categoryTitle.toLowerCase()) {
      case 'sd':
        return Icons.shopping_cart_outlined;
      case 'mm':
        return Icons.inventory_2_outlined;
      case 'fico':
        return Icons.attach_money;
      case 'pp':
        return Icons.factory_outlined;
      default:
        return Icons.grid_view;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      front: GestureDetector(
        onTap: onCardTapped,
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withOpacity(0.7),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_getCategoryIcon(category), size: 64, color: AppColors.white),
                const SizedBox(height: 16),
                Text(
                  category.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${items.length} Systems',
                    style: const TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      back: Card(
        child: Column(
          children: [
            GestureDetector(
              onTap: onHeaderTapped,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      category.toUpperCase(),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.close, size: 16, color: AppColors.textSecondary),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(8),
                itemCount: items.length,
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(
                    title: Text(
                      item.module.moduleName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      item.module.moduleDescription,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () async {
                      if (kIsWeb) {
                        final uri = Uri.parse(item.content.repo);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, webOnlyWindowName: '_self');
                        } else {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Could not open ${item.module.moduleName}')),
                            );
                          }
                        }
                      } else {
                        // TODO: Implement mobile native launcher here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Mobile: Membuka ${item.module.moduleName}'),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
