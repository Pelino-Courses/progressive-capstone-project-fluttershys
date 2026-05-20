import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/app_state.dart';

class VendorOrdersPage extends StatelessWidget {
  const VendorOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final sellerId = appState.currentUserId;

    return StreamBuilder<List<AppOrder>>(
      stream: appState.orderService.streamOrdersForSeller(sellerId),
      initialData: appState.store.orders
          .where((o) => o.sellerId == sellerId)
          .toList(),
      builder: (context, snapshot) {
        final orders = snapshot.data ?? const <AppOrder>[];
        if (orders.isEmpty) {
          return const Center(
            child: Text('No customer orders yet for your listings.'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.productName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Qty ${order.quantity} • ${order.totalPrice.toStringAsFixed(0)} RWF',
                    ),
                    Text('Buyer: ${order.buyerEmail}'),
                    Text('Status: ${order.status}'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: [
                        if (order.status == 'placed')
                          FilledButton.tonal(
                            onPressed: () => _update(
                              context,
                              order.id,
                              'processing',
                            ),
                            child: const Text('Processing'),
                          ),
                        if (order.status == 'processing')
                          FilledButton.tonal(
                            onPressed: () => _update(
                              context,
                              order.id,
                              'shipped',
                            ),
                            child: const Text('Shipped'),
                          ),
                        if (order.status == 'shipped')
                          FilledButton(
                            onPressed: () => _update(
                              context,
                              order.id,
                              'delivered',
                            ),
                            child: const Text('Delivered'),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _update(BuildContext context, String id, String status) async {
    await context.read<AppState>().orderService.updateOrderStatus(id, status);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order marked as $status')),
      );
    }
  }
}
