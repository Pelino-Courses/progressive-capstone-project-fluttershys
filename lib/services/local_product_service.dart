import 'dart:async';

import '../data/local_data_store.dart';
import '../models/product.dart';
import 'mock_delay.dart';

class LocalProductService {
  LocalProductService(this._store);

  final LocalDataStore _store;

  Stream<List<Product>> streamAllProducts() {
    return _store.productsStream.map(
      (list) => list.where((p) => p.isApproved).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  Stream<List<Product>> streamProductsByOwner(String ownerId) {
    return _store.productsStream.map(
      (list) => list.where((p) => p.ownerId == ownerId).toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt)),
    );
  }

  Stream<List<Product>> streamRecommendedProducts(String viewerId) {
    return _store.productsStream.map((list) {
      final available = list
          .where((p) => p.isAvailable && p.isApproved && p.ownerId != viewerId)
          .toList();
      available.sort((a, b) => b.popularity.compareTo(a.popularity));
      return available.take(8).toList();
    });
  }

  Stream<List<Product>> streamAllProductsAdmin() {
    return _store.productsStream;
  }

  Future<void> createProduct({
    required String ownerId,
    required String ownerName,
    required String name,
    required String category,
    required double price,
    String? description,
    String? imageUrl,
    int stockQuantity = 50,
  }) async {
    await mockNetworkDelay();
    final id = 'prod-${DateTime.now().millisecondsSinceEpoch}';
    final product = Product(
      id: id,
      ownerId: ownerId,
      ownerName: ownerName,
      name: name,
      category: category,
      price: price,
      description: description ?? '',
      imageUrl: imageUrl,
      stockQuantity: stockQuantity,
      isAvailable: stockQuantity > 0,
      popularity: 0,
      createdAt: DateTime.now(),
      isApproved: true,
    );
    await _store.saveProduct(product);
  }

  Future<void> updateProduct({
    required Product product,
    required bool isAdmin,
    required String currentUserId,
  }) async {
    if (!isAdmin && product.ownerId != currentUserId) {
      throw StateError('You can only update your own products.');
    }
    await mockNetworkDelay(const Duration(milliseconds: 200));
    await _store.saveProduct(product);
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
    await _store.deleteProduct(productId);
  }

  Future<void> setProductApproval(String productId, bool approved) async {
    final list = _store.products;
    final index = list.indexWhere((p) => p.id == productId);
    if (index < 0) return;
    await _store.saveProduct(list[index].copyWith(isApproved: approved));
  }
}
