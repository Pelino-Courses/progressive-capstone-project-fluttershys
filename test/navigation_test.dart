import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:sukaapp/providers/app_state.dart';
import 'package:sukaapp/screens/auth/auth_gate.dart';

import 'test_bundle.dart';

void main() {
  testWidgets('visitor sees public marketplace shell', (tester) async {
    final bundle = await createTestBundle(signedIn: false);

    await tester.binding.setSurfaceSize(const Size(1280, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>.value(
        value: bundle.appState,
        child: const MaterialApp(home: AuthGate()),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Frutella Marketplace'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    bundle.appState.dispose();
  });
}
