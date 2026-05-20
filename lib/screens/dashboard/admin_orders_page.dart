import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/order.dart';
import '../../providers/app_state.dart';

/// Full marketplace order log (admin only).
class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    if (!appState.isAdmin) {
      return const Center(child: Text('Admin access required.'));
    }

    return StreamBuilder<List<AppOrder>>(
      stream: appState.orderService.streamAllOrders(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data ?? const <AppOrder>[];
        if (orders.isEmpty) {
          return const Center(
            child: Text('No orders in the system yet.'),
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
                  'Seller ID: ${order.sellerId}\n'
                  'Qty ${order.quantity} • ${order.totalPrice.toStringAsFixed(0)} RWF • ${order.status}',
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
