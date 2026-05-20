import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sukaapp/models/product.dart';
import 'package:sukaapp/providers/app_state.dart';
import 'package:sukaapp/widgets/product_card.dart';

import 'test_bundle.dart';

void main() {
  testWidgets('product card renders marketplace fields safely', (tester) async {
    final bundle = await createTestBundle(signedIn: false);

    final product = Product(
      id: 'p-1',
      ownerId: 'seller-1',
      ownerName: 'Mama Grace',
      name: 'Fresh Mangoes',
      category: 'Fruits',
      price: 1500,
      imageUrl: 'assets/images/products/mango.jpg',
      isAvailable: true,
      popularity: 3,
      createdAt: DateTime(2024, 1, 1),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: bundle.appState,
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 240,
              height: 360,
              child: ProductCard(product: product),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Fresh Mangoes'), findsOneWidget);
    expect(find.text('Add to cart'), findsOneWidget);

    bundle.appState.dispose();
  });
}
