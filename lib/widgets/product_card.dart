import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../providers/app_state.dart';
import '../screens/dashboard/product_detail_page.dart';
import '../utils/auth_navigation.dart';
import 'product_image.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.product,
    this.compact = false,
  });

  final Product product;
  final bool compact;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final appState = context.watch<AppState>();
    final theme = Theme.of(context);
    final inCart = appState.cartService.contains(product.id);
    final compact = widget.compact;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.02 : 1,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: Card(
          clipBehavior: Clip.antiAlias,
          elevation: _hovered ? 4 : 1,
          child: InkWell(
            onTap: () {
              appState.recordProductView(product.id);
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => ProductDetailPage(product: product),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (compact)
                  SizedBox(
                    height: 96,
                    child: ProductImage(
                      imageUrl: product.imageUrl,
                      aspectRatio: 1,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                  )
                else
                  ProductImage(imageUrl: product.imageUrl),
                Padding(
                  padding: EdgeInsets.all(compact ? 8 : 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        product.name,
                        maxLines: compact ? 1 : 2,
                        overflow: TextOverflow.ellipsis,
                        style: (compact
                                ? theme.textTheme.labelLarge
                                : theme.textTheme.titleSmall)
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.category,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontSize: compact ? 11 : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${product.price.toStringAsFixed(0)} RWF',
                        style: theme.textTheme.titleSmall?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        product.ownerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _stockChip(context, product.isAvailable),
                          const Spacer(),
                          if (inCart)
                            Icon(
                              Icons.check_circle,
                              size: 16,
                              color: theme.colorScheme.tertiary,
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        height: compact ? 34 : 38,
                        child: FilledButton.tonal(
                          onPressed: !product.isAvailable
                              ? null
                              : () => _onAddToCart(context, appState),
                          child: Text(
                            inCart ? 'In cart' : 'Add to cart',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: compact ? 11 : 13),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _stockChip(BuildContext context, bool available) {
    final color = available ? Colors.green.shade700 : Colors.orange.shade800;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        available ? 'In stock' : 'Out of stock',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  void _onAddToCart(BuildContext context, AppState appState) {
    if (!appState.tryAddToCart(widget.product)) {
      promptSignIn(context);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.product.name} added to cart.'),
        behavior: SnackBarBehavior.floating,
        action: appState.isAuthenticated
            ? SnackBarAction(
                label: 'View cart',
                onPressed: appState.openCartTab,
              )
            : null,
      ),
    );
  }
}
