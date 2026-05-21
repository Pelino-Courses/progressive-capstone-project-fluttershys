import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/app_state.dart';
import '../../utils/auth_navigation.dart';
import '../../widgets/product_image.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appState = context.watch<AppState>();
    final isFav = appState.isFavorite(product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          if (appState.isAuthenticated)
            IconButton(
              onPressed: () => appState.toggleFavorite(product.id),
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ProductImage(
              imageUrl: product.imageUrl,
              aspectRatio: 16 / 9,
              borderRadius: BorderRadius.circular(16),
            ),
            const SizedBox(height: 16),
            Text(product.name, style: theme.textTheme.headlineSmall),
            const SizedBox(height: 4),
            Text(product.category, style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            Text(
              '${product.price.toStringAsFixed(0)} RWF',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            if (product.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(product.description),
            ],
            const SizedBox(height: 12),
            _infoRow('Seller', product.ownerName),
            _infoRow('Stock', '${product.stockQuantity} units'),
            _infoRow(
              'Availability',
              product.isAvailable ? 'In stock' : 'Out of stock',
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: !product.isAvailable
                  ? null
                  : () {
                      if (!appState.tryAddToCart(product)) {
                        promptSignIn(context);
                        return;
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${product.name} added to cart.'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to cart'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 110,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
