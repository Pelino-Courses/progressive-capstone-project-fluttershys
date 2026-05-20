import 'package:uuid/uuid.dart';

import '../data/local_data_store.dart';
import '../models/order.dart';
import '../models/product.dart';
import 'mock_delay.dart';

class LocalOrderService {
  LocalOrderService(this._store);

  final LocalDataStore _store;
  final _uuid = const Uuid();

  Future<void> placeOrder({
    required String buyerId,
    required String buyerEmail,
    required Product product,
    required int quantity,
    String? note,
  }) async {
    if (quantity < 1) throw ArgumentError('Quantity must be at least 1');
    await mockNetworkDelay();

    final order = AppOrder.fromProduct(
      id: _uuid.v4(),
      buyerId: buyerId,
      buyerEmail: buyerEmail,
      product: product,
      quantity: quantity,
      note: note,
    );
    await _store.saveOrder(order);

    final updatedStock = (product.stockQuantity - quantity).clamp(0, 999999);
    await _store.saveProduct(
      product.copyWith(
        stockQuantity: updatedStock,
        isAvailable: updatedStock > 0,
      ),
    );
  }

  Stream<List<AppOrder>> streamMyOrders(String buyerId) {
    return _store.ordersStream.map(
      (orders) => orders.where((o) => o.buyerId == buyerId).toList(),
    );
  }

  Stream<List<AppOrder>> streamOrdersForSeller(String sellerId) {
    return _store.ordersStream.map(
      (orders) => orders.where((o) => o.sellerId == sellerId).toList(),
    );
  }

  Stream<List<AppOrder>> streamAllOrders() => _store.ordersStream;

  Future<void> updateOrderStatus(String orderId, String status) async {
    await mockNetworkDelay(const Duration(milliseconds: 200));
    await _store.updateOrderStatus(orderId, status);
  }
}
