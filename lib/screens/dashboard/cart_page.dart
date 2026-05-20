import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/app_state.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/product_image.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final cart = appState.cartService;
    final items = cart.items;

    if (items.isEmpty) {
      return const EmptyStateView(
        icon: Icons.shopping_cart_outlined,
        title: 'Your cart is empty',
        message: 'Browse the marketplace and add fresh produce to your cart.',
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              final product = item.product;

              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 88,
                        child: ProductImage(
                          imageUrl: product.imageUrl,
                          aspectRatio: 1,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Sold by ${product.ownerName}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${product.price.toStringAsFixed(0)} RWF',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: item.quantity <= 1
                                      ? null
                                      : () => cart.setQuantity(
                                          product.id,
                                          item.quantity - 1,
                                        ),
                                  icon: const Icon(Icons.remove_circle_outline),
                                ),
                                Text('${item.quantity}'),
                                IconButton(
                                  onPressed: () => cart.setQuantity(
                                    product.id,
                                    item.quantity + 1,
                                  ),
                                  icon: const Icon(Icons.add_circle_outline),
                                ),
                                const Spacer(),
                                IconButton(
                                  tooltip: 'Remove',
                                  onPressed: () => cart.remove(product.id),
                                  icon: const Icon(Icons.delete_outline),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Subtotal', style: Theme.of(context).textTheme.titleMedium),
                    Text(
                      '${cart.subtotal.toStringAsFixed(0)} RWF',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () async {
                    final ok = await appState.checkoutCart();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          ok
                              ? 'Checkout complete. Orders placed successfully.'
                              : 'Checkout failed. Please try again.',
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.payment_outlined),
                  label: const Text('Checkout'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
