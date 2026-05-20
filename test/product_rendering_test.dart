import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sukaapp/models/product.dart';
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
      imageUrl: 'https://example.com/mango.jpg',
      isAvailable: true,
      popularity: 3,
      createdAt: DateTime(2024, 1, 1),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
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
    expect(find.text('Fruits'), findsOneWidget);
    expect(find.text('1500 RWF'), findsOneWidget);
    expect(find.text('Mama Grace'), findsOneWidget);
    expect(find.text('In stock'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);

    bundle.appState.dispose();
  });
}
