import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/app_state.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return StreamBuilder<List<AppOrder>>(
      stream: appState.orderService.streamMyOrders(appState.currentUserId),
      initialData: appState.store.orders
          .where((o) => o.buyerId == appState.currentUserId)
          .toList(),
      builder: (context, snapshot) {
        final orders = snapshot.data ?? const <AppOrder>[];
        if (orders.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No orders yet. Place your first order from Marketplace.',
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              child: ListTile(
                title: Text(order.productName),
                subtitle: Text(
                  'Qty ${order.quantity} • ${order.totalPrice.toStringAsFixed(0)} RWF\nStatus: ${order.status}',
                ),
                isThreeLine: true,
                trailing: Text(
                  _formatDate(order.createdAt),
                  textAlign: TextAlign.right,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime value) {
    final month = value.month.toString().padLeft(2, '0');
    final day = value.day.toString().padLeft(2, '0');
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '${value.year}-$month-$day\n$hour:$minute';
  }
}
