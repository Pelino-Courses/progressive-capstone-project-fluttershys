import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:sukaapp/providers/app_state.dart';
import 'package:sukaapp/screens/dashboard/cart_page.dart';
import 'package:sukaapp/screens/dashboard/marketplace_page.dart';

import '../test/test_bundle.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('marketplace cart checkout flow', (tester) async {
    final bundle = await createTestBundle(signedIn: true);

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: bundle.appState,
        child: const MaterialApp(home: Scaffold(body: MarketplacePage())),
      ),
    );
    await tester.pumpAndSettle();

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

    bundle.appState.dispose();
  });
}
