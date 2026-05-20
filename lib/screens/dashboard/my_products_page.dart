import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../providers/app_state.dart';
import '../../utils/product_image_storage.dart';
import '../../widgets/product_image.dart';

class MyProductsPage extends StatelessWidget {
  const MyProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final userId = appState.currentUserId;
    final orders = appState.store.orders.where((o) => o.sellerId == userId);
    final revenue = orders.fold<double>(0, (s, o) => s + o.totalPrice);

    return Scaffold(
      body: StreamBuilder<List<Product>>(
        stream: appState.productService.streamProductsByOwner(userId),
        initialData:
            appState.store.products.where((p) => p.ownerId == userId).toList(),
        builder: (context, snapshot) {
          final products = snapshot.data ?? const <Product>[];

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: Row(
                  children: [
                    Expanded(
                      child: _VendorStat(
                        label: 'Listings',
                        value: '${products.length}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _VendorStat(
                        label: 'Sales',
                        value: '${orders.length}',
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _VendorStat(
                        label: 'Revenue',
                        value: '${revenue.toStringAsFixed(0)} RWF',
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: products.isEmpty
                    ? const Center(
                        child: Text(
                          'No listings yet. Tap + to add your first product.',
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          return Card(
                            child: ListTile(
                              leading: SizedBox(
                                width: 56,
                                height: 56,
                                child: ProductImage(
                                  imageUrl: product.imageUrl,
                                  aspectRatio: 1,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              title: Text(product.name),
                              subtitle: Text(
                                '${product.category} • ${product.price.toStringAsFixed(0)} RWF\n'
                                'Stock: ${product.stockQuantity}',
                              ),
                              isThreeLine: true,
                              trailing: Wrap(
                                spacing: 4,
                                children: [
                                  IconButton(
                                    tooltip: 'Edit',
                                    onPressed: () => showVendorProductForm(
                                      context,
                                      existing: product,
                                    ),
                                    icon: const Icon(Icons.edit_outlined),
                                  ),
                                  IconButton(
                                    tooltip: 'Delete',
                                    onPressed: () =>
                                        _deleteProduct(context, product),
                                    icon: const Icon(Icons.delete_outline),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showVendorProductForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Future<void> _deleteProduct(BuildContext context, Product product) async {
    final appState = context.read<AppState>();

    try {
      await appState.productService.deleteProduct(
        productId: product.id,
        productOwnerId: product.ownerId,
        isAdmin: appState.isAdmin,
        currentUserId: appState.currentUserId,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Product deleted.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Delete failed: $e')),
        );
      }
    }
  }
}

class _VendorStat extends StatelessWidget {
  const _VendorStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(label, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

Future<void> showVendorProductForm(
  BuildContext context, {
  Product? existing,
}) async {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController(text: existing?.name ?? '');
  final categoryCtrl = TextEditingController(
    text: existing?.category ?? 'Fruits',
  );
  final priceCtrl = TextEditingController(
    text: existing != null ? existing.price.toStringAsFixed(0) : '',
  );
  final descCtrl = TextEditingController(text: existing?.description ?? '');
  final stockCtrl = TextEditingController(
    text: existing != null ? '${existing.stockQuantity}' : '50',
  );
  String? imagePath = existing?.imageUrl;

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setModalState) {
          return Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      existing == null ? 'Add Product' : 'Edit Product',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    if (imagePath != null)
                      SizedBox(
                        height: 120,
                        child: ProductImage(
                          imageUrl: imagePath,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked =
                            await ProductImageStorage.pickAndSaveProductImage();
                        if (picked != null) {
                          setModalState(() => imagePath = picked);
                        }
                      },
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Choose product photo'),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: const InputDecoration(labelText: 'Product name'),
                      validator: (v) =>
                          v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: categoryCtrl,
                      decoration: const InputDecoration(labelText: 'Category'),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: descCtrl,
                      decoration: const InputDecoration(labelText: 'Description'),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Price (RWF)'),
                      validator: (v) {
                        final p = double.tryParse(v ?? '');
                        if (p == null || p <= 0) return 'Invalid price';
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: stockCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: 'Stock quantity'),
                    ),
                    const SizedBox(height: 14),
                    FilledButton(
                      onPressed: () async {
                        if (!formKey.currentState!.validate()) return;

                        final appState = context.read<AppState>();
                        final stock = int.tryParse(stockCtrl.text) ?? 0;
                        try {
                          if (existing == null) {
                            await appState.productService.createProduct(
                              ownerId: appState.currentUserId,
                              ownerName:
                                  appState.profile?.displayName ?? 'Seller',
                              name: nameCtrl.text.trim(),
                              category: categoryCtrl.text.trim(),
                              price: double.parse(priceCtrl.text),
                              description: descCtrl.text.trim(),
                              imageUrl: imagePath,
                              stockQuantity: stock,
                            );
                          } else {
                            final updated = existing.copyWith(
                              name: nameCtrl.text.trim(),
                              category: categoryCtrl.text.trim(),
                              price: double.parse(priceCtrl.text),
                              description: descCtrl.text.trim(),
                              imageUrl: imagePath,
                              stockQuantity: stock,
                              isAvailable: stock > 0,
                            );
                            await appState.productService.updateProduct(
                              product: updated,
                              isAdmin: appState.isAdmin,
                              currentUserId: appState.currentUserId,
                            );
                          }

                          if (context.mounted) Navigator.of(context).pop();
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Save failed: $e')),
                            );
                          }
                        }
                      },
                      child: Text(existing == null ? 'Create' : 'Save changes'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );

  nameCtrl.dispose();
  categoryCtrl.dispose();
  priceCtrl.dispose();
  descCtrl.dispose();
  stockCtrl.dispose();
}
