import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order.dart';
import '../models/product.dart';
import 'mock_delay.dart';

class OrderService {
  OrderService({
    FirebaseFirestore? firestore,
    this.simulateNetworkDelay = false,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final bool simulateNetworkDelay;

  CollectionReference<Map<String, dynamic>> get _orders =>
      _firestore.collection('orders');

  Future<void> placeOrder({
    required String buyerId,
    required String buyerEmail,
    required Product product,
    required int quantity,
    String? note,
  }) async {
    if (quantity < 1) {
      throw ArgumentError('Quantity must be at least 1');
    }

    if (simulateNetworkDelay) await mockNetworkDelay();

    final ref = _orders.doc();
    final order = AppOrder.fromProduct(
      id: ref.id,
      buyerId: buyerId,
      buyerEmail: buyerEmail,
      product: product,
      quantity: quantity,
      note: note,
    );

    await ref.set(order.toMap());
  }

  Stream<List<AppOrder>> streamMyOrders(String buyerId) {
    return _orders
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => AppOrder.fromMap(doc.data())).toList(),
        );
  }

  Stream<List<AppOrder>> streamAllOrders() {
    return _orders
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => AppOrder.fromMap(doc.data())).toList(),
        );
  }
}
