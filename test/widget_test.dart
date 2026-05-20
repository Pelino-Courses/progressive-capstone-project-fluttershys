import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sukaapp/screens/auth/sign_in_page.dart';

import 'test_bundle.dart';

void main() {
  testWidgets('sign-in screen renders without crashing', (
    WidgetTester tester,
  ) async {
    final bundle = await createTestBundle(signedIn: false);

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: bundle.appState,
        child: const MaterialApp(home: SignInPage()),
      ),
    );
    await tester.pump();

    expect(find.text('Sign In'), findsWidgets);
    expect(find.text('Welcome back'), findsOneWidget);
    expect(find.byType(TextFormField), findsNWidgets(2));

    bundle.appState.dispose();
  });
}
