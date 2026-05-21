import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/responsive.dart';
import '../../models/product.dart';
import '../../providers/app_state.dart';
import '../../widgets/async_state_view.dart';
import '../../widgets/marketplace_product_grid.dart';

class MarketplacePage extends StatefulWidget {
  const MarketplacePage({super.key, this.publicMode = false});

  final bool publicMode;

  @override
  State<MarketplacePage> createState() => _MarketplacePageState();
}

class _MarketplacePageState extends State<MarketplacePage> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = productGridCrossAxisCount(constraints.maxWidth);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search products, categories, sellers...',
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value.trim().toLowerCase());
                  if (value.trim().isNotEmpty) {
                    appState.addSearchTerm(value.trim());
                  }
                },
              ),
            ),
            Expanded(
              child: StreamBuilder<List<Product>>(
                stream: appState.productService.streamAllProducts(),
                initialData: appState.store.products
                    .where((p) => p.isApproved)
                    .toList(),
                builder: (context, snapshot) {
                  return AsyncStateView<List<Product>>(
                    snapshot: snapshot,
                    loading: ProductListLoadingView(crossAxisCount: crossAxisCount),
                    emptyTitle: 'No products yet',
                    emptyMessage: widget.publicMode
                        ? 'Check back soon for fresh marketplace listings.'
                        : 'Add your first product from My Products.',
                    builder: (context, products) {
                      final categories = <String>{
                        'All',
                        ...products.map((p) => p.category),
                      }.toList()
                        ..sort();

                      final filtered = products.where((product) {
                        final matchesCategory = _selectedCategory == 'All' ||
                            product.category == _selectedCategory;
                        if (!matchesCategory) return false;
                        if (_searchQuery.isEmpty) return true;

                        final haystack =
                            '${product.name} ${product.category} ${product.ownerName}'
                                .toLowerCase();
                        return haystack.contains(_searchQuery);
                      }).toList();

                      if (filtered.isEmpty) {
                        return const Center(
                          child: Text('No products match your filters.'),
                        );
                      }

                      return constrainContent(
                        ListView(
                          padding: const EdgeInsets.all(12),
                          children: [
                            Text(
                              'Recommended for you',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            StreamBuilder<List<Product>>(
                              stream: appState.productService.streamRecommendedProducts(
                                appState.currentUserId,
                              ),
                              builder: (context, recSnapshot) {
                                final recs = recSnapshot.data ?? const <Product>[];
                                return RecommendedProductsStrip(products: recs);
                              },
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 42,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: categories.length,
                                separatorBuilder: (_, __) => const SizedBox(width: 8),
                                itemBuilder: (context, index) {
                                  final category = categories[index];
                                  return FilterChip(
                                    label: Text(category),
                                    selected: _selectedCategory == category,
                                    onSelected: (_) {
                                      setState(() => _selectedCategory = category);
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'All products (${filtered.length})',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            MarketplaceProductGrid(products: filtered),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
