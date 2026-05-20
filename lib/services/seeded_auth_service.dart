import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import 'auth_service.dart';
import 'local_seed_data.dart';
import 'mock_delay.dart';

/// Validates credentials against local seed accounts before mock Firebase sign-in.
class SeededAuthService extends AuthService {
  SeededAuthService({
    required MockFirebaseAuth mockAuth,
    required super.firestore,
  }) : _mockAuth = mockAuth,
       super(auth: mockAuth, simulateNetworkDelay: true);

  final MockFirebaseAuth _mockAuth;

  @override
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    if (simulateNetworkDelay) await mockNetworkDelay();

    final account = LocalSeedData.findByEmail(email);
    if (account != null) {
      if (account.password != password) {
        throw FirebaseAuthException(
          code: 'wrong-password',
          message: 'Incorrect email or password.',
        );
      }
      _mockAuth.mockUser = MockUser(
        uid: account.uid,
        email: account.email,
        displayName: account.displayName,
      );
      return super.signIn(email: email, password: password);
    }

    return super.signIn(email: email, password: password);
  }
}
