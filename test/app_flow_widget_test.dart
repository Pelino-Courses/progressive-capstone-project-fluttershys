import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sukaapp/models/product.dart';
import 'package:sukaapp/screens/dashboard/cart_page.dart';
import 'package:sukaapp/screens/dashboard/marketplace_page.dart';
import 'package:sukaapp/screens/dashboard/orders_page.dart';

import 'test_bundle.dart';

void main() {
  testWidgets('marketplace cart checkout persists and appears in orders history', (
    tester,
  ) async {
    final bundle = await createTestBundle(signedIn: true, seedProduct: true);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: bundle.appState,
        child: const MaterialApp(home: Scaffold(body: MarketplacePage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fresh Mangoes'), findsWidgets);

    final product = Product(
      id: 'product-1',
      ownerId: 'seller-2',
      ownerName: 'Seller Two',
      name: 'Fresh Mangoes',
      category: 'Fruits',
      price: 1500,
      isAvailable: true,
      popularity: 3,
      createdAt: Timestamp.now().toDate(),
    );
    bundle.appState.addToCart(product);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: bundle.appState,
        child: const MaterialApp(home: Scaffold(body: CartPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fresh Mangoes'), findsOneWidget);

    await tester.tap(find.widgetWithText(FilledButton, 'Checkout'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Checkout complete. Orders placed successfully.'),
      findsOneWidget,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: bundle.appState,
        child: const MaterialApp(home: Scaffold(body: OrdersPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fresh Mangoes'), findsOneWidget);

    bundle.appState.dispose();
  });
}
