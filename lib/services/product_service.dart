import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/product.dart';
import 'mock_delay.dart';

class ProductService {
  ProductService({
    FirebaseFirestore? firestore,
    this.simulateNetworkDelay = false,
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;
  final bool simulateNetworkDelay;

  CollectionReference<Map<String, dynamic>> get _products =>
      _firestore.collection('products');

  Stream<List<Product>> streamAllProducts() {
    return _products.orderBy('createdAt', descending: true).snapshots().map((
      snap,
    ) {
      return snap.docs.map((doc) => Product.fromMap(doc.data())).toList();
    });
  }

  Stream<List<Product>> streamProductsByOwner(String ownerId) {
    return _products
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Product.fromMap(doc.data())).toList(),
        );
  }

  Stream<List<Product>> streamRecommendedProducts(String ownerId) {
    return _products
        .where('ownerId', isNotEqualTo: ownerId)
        .where('isAvailable', isEqualTo: true)
        .orderBy('ownerId')
        .orderBy('popularity', descending: true)
        .limit(8)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => Product.fromMap(doc.data())).toList(),
        );
  }

  Future<void> createProduct({
    required String ownerId,
    required String ownerName,
    required String name,
    required String category,
    required double price,
    String? imageUrl,
  }) async {
    if (simulateNetworkDelay) await mockNetworkDelay();
    final ref = _products.doc();
    final product = Product(
      id: ref.id,
      ownerId: ownerId,
      ownerName: ownerName,
      name: name,
      category: category,
      price: price,
      imageUrl: imageUrl,
      isAvailable: true,
      popularity: 0,
      createdAt: DateTime.now(),
    );
    await ref.set(product.toMap());
  }

  Future<void> updateProduct({
    required Product product,
    required bool isAdmin,
    required String currentUserId,
  }) async {
    if (!isAdmin && product.ownerId != currentUserId) {
      throw StateError('You can only update your own products.');
    }
    await _products.doc(product.id).update(product.toMap());
  }

  Future<void> deleteProduct({
    required String productId,
    required String productOwnerId,
    required bool isAdmin,
    required String currentUserId,
  }) async {
    if (!isAdmin && productOwnerId != currentUserId) {
      throw StateError('You can only delete your own products.');
    }
    await _products.doc(productId).delete();
  }
}
