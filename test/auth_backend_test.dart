import 'package:flutter_test/flutter_test.dart';
import 'package:sukaapp/services/local_seed_data.dart';

import 'test_bundle.dart';

void main() {
  test('local backend supports sign in with seeded buyer', () async {
    final bundle = await createTestBundle(signedIn: false);

    final signedIn = await bundle.appState.signIn(
      email: LocalSeedData.demoBuyer.email,
      password: LocalSeedData.demoBuyer.password,
    );

    expect(signedIn, isTrue);
    expect(bundle.appState.isAuthenticated, isTrue);

    bundle.appState.dispose();
  });

  test('local backend supports sign up with new account', () async {
    final bundle = await createTestBundle(signedIn: false);
    final email = 'new.user.${DateTime.now().millisecondsSinceEpoch}@frutella.test';

    final created = await bundle.appState.signUp(
      name: 'New User',
      email: email,
      password: 'Test123!',
    );

    expect(created, isTrue);
    expect(bundle.appState.isAuthenticated, isTrue);

    bundle.appState.dispose();
  });
}
