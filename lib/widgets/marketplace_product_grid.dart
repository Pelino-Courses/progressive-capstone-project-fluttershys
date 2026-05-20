import 'package:flutter/material.dart';

import '../core/responsive.dart';
import '../models/product.dart';
import 'product_card.dart';

class MarketplaceProductGrid extends StatelessWidget {
  const MarketplaceProductGrid({
    super.key,
    required this.products,
    this.compactCards = false,
  });

  final List<Product> products;
  final bool compactCards;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final aspectRatio = productGridChildAspectRatio(width);
        final maxExtent = productGridMaxExtent(width);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: maxExtent,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: aspectRatio,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ProductCard(
              product: products[index],
              compact: compactCards,
            );
          },
        );
      },
    );
  }
}

class RecommendedProductsStrip extends StatelessWidget {
  const RecommendedProductsStrip({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox(
        height: 48,
        child: Center(
          child: Text('Recommendations appear as more products are added.'),
        ),
      );
    }

    return SizedBox(
      height: 300,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        itemCount: products.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 220,
            child: ProductCard(product: products[index], compact: true),
          );
        },
      ),
    );
  }
}
