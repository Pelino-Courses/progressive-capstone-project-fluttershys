import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/app_state.dart';

/// Incoming orders for products sold by the signed-in vendor (`sellerId`).
class VendorOrdersPage extends StatelessWidget {
  const VendorOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return StreamBuilder<List<AppOrder>>(
      stream: appState.orderService.streamOrdersForSeller(appState.currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data ?? const <AppOrder>[];
        if (orders.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'No sales yet. When buyers order your listings, they appear here.',
                textAlign: TextAlign.center,
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
                  'Buyer: ${order.buyerEmail}\n'
                  'Qty ${order.quantity} • ${order.totalPrice.toStringAsFixed(0)} RWF\n'
                  'Status: ${order.status}',
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
