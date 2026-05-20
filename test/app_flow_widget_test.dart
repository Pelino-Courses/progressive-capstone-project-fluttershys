import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sukaapp/providers/app_state.dart';
import 'package:sukaapp/screens/dashboard/cart_page.dart';
import 'package:sukaapp/screens/dashboard/marketplace_page.dart';
import 'package:sukaapp/screens/dashboard/orders_page.dart';

import 'test_bundle.dart';

void main() {
  testWidgets('marketplace cart checkout persists and appears in orders history', (
    tester,
  ) async {
    final bundle = await createTestBundle(signedIn: true);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: bundle.appState,
        child: const MaterialApp(home: Scaffold(body: MarketplacePage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fresh Mangoes'), findsWidgets);

    bundle.appState.tryAddToCart(
      bundle.appState.store.products.firstWhere((p) => p.name == 'Fresh Mangoes'),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: bundle.appState,
        child: const MaterialApp(home: Scaffold(body: CartPage())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Checkout'));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('Checkout complete. Orders placed successfully.'),
      findsOneWidget,
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: bundle.appState,
        child: const MaterialApp(home: Scaffold(body: OrdersPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fresh Mangoes'), findsOneWidget);

    bundle.appState.dispose();
  });
}
