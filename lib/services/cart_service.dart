import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

/// In-memory cart for local mock mode. Replace with remote cart repository later.
class CartService extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items =>
      _items.values.toList()..sort((a, b) => a.product.name.compareTo(b.product.name));

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      _items.values.fold(0, (sum, item) => sum + item.lineTotal);

  bool contains(String productId) => _items.containsKey(productId);

  int quantityFor(String productId) => _items[productId]?.quantity ?? 0;

  void add(Product product, {int quantity = 1}) {
    if (!product.isAvailable || quantity < 1) return;

    final existing = _items[product.id];
    if (existing == null) {
      _items[product.id] = CartItem(product: product, quantity: quantity);
    } else {
      _items[product.id] = existing.copyWith(
        quantity: existing.quantity + quantity,
      );
    }
    notifyListeners();
  }

  void setQuantity(String productId, int quantity) {
    final existing = _items[productId];
    if (existing == null) return;

    if (quantity < 1) {
      _items.remove(productId);
    } else {
      _items[productId] = existing.copyWith(quantity: quantity);
    }
    notifyListeners();
  }

  void remove(String productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  void clear() {
    if (_items.isEmpty) return;
    _items.clear();
    notifyListeners();
  }
}
