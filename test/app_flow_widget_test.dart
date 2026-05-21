import 'package:flutter_test/flutter_test.dart';

import 'test_bundle.dart';

void main() {
  test('cart checkout persists order in local store', () async {
    final bundle = await createTestBundle(signedIn: true);
    final mango = bundle.appState.store.products.firstWhere(
      (p) => p.name == 'Fresh Mangoes',
    );

    expect(bundle.appState.tryAddToCart(mango), isTrue);

    final ok = await bundle.appState.checkoutCart();
    expect(ok, isTrue);

    final orders = bundle.appState.store.orders
        .where((o) => o.buyerId == bundle.appState.currentUserId);
    expect(orders.any((o) => o.productName == 'Fresh Mangoes'), isTrue);

    bundle.appState.dispose();
  });
}
