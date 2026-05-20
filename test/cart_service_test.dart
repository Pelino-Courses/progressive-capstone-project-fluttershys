import 'package:flutter_test/flutter_test.dart';
import 'package:sukaapp/models/product.dart';
import 'package:sukaapp/services/cart_service.dart';

void main() {
  test('cart service adds, updates, and clears items', () {
    final cart = CartService();
    final product = Product(
      id: 'p-1',
      ownerId: 'seller-1',
      ownerName: 'Seller',
      name: 'Mangoes',
      category: 'Fruits',
      price: 1000,
      isAvailable: true,
      popularity: 1,
      createdAt: DateTime(2024, 1, 1),
    );

    cart.add(product, quantity: 2);
    expect(cart.itemCount, 2);
    expect(cart.subtotal, 2000);

    cart.setQuantity('p-1', 3);
    expect(cart.itemCount, 3);

    cart.remove('p-1');
    expect(cart.items, isEmpty);

    cart.dispose();
  });
}
