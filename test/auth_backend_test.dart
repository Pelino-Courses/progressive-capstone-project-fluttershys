import 'package:flutter_test/flutter_test.dart';
import 'package:sukaapp/services/local_seed_data.dart';

import 'test_bundle.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('local backend supports sign up and sign in', () async {
    final bundle = await createTestBundle(signedIn: false);

    final created = await bundle.appState.signUp(
      name: 'Integration Tester',
      email: 'integration.tester@frutella.test',
      password: 'Test123!',
    );

    expect(created, isTrue);
    expect(bundle.appState.isAuthenticated, isTrue);

    await bundle.appState.signOut();

    final signedIn = await bundle.appState.signIn(
      email: LocalSeedData.demoBuyer.email,
      password: LocalSeedData.demoBuyer.password,
    );

    expect(signedIn, isTrue);
    expect(bundle.appState.isAuthenticated, isTrue);

    bundle.appState.dispose();
  });
}
