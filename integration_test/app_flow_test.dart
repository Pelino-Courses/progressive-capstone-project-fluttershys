import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:sukaapp/screens/dashboard/cart_page.dart';
import 'package:sukaapp/screens/dashboard/marketplace_page.dart';
import 'package:sukaapp/screens/dashboard/orders_page.dart';

import '../test/test_bundle.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('marketplace cart checkout persists and renders in order history', (
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

    await tester.tap(find.widgetWithText(FilledButton, 'Add to cart').first);
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: bundle.appState,
        child: const MaterialApp(home: Scaffold(body: CartPage())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.widgetWithText(FilledButton, 'Checkout'));
    await tester.pumpAndSettle();

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
