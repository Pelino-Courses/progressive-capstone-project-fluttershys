import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

import '../models/app_user.dart';
import 'admin_service.dart';
import 'auth_service.dart';
import 'feedback_service.dart';
import 'local_seed_data.dart';
import 'mock_delay.dart';
import 'order_service.dart';
import 'product_service.dart';
import 'seeded_auth_service.dart';

/// Mock services factory for local testing without Firebase.
class MockServicesFactory {
  static Future<MockServices> create() async {
    await mockNetworkDelay(const Duration(milliseconds: 120));

    final firestore = FakeFirebaseFirestore();

    final seedUsers = [
      for (final account in LocalSeedData.allAccounts)
        MockUser(
          uid: account.uid,
          email: account.email,
          displayName: account.displayName,
        ),
    ];

    final auth = MockFirebaseAuth(
      signedIn: false,
      mockUser: seedUsers.first,
    );

    for (final account in LocalSeedData.allAccounts) {
      await firestore.collection('users').doc(account.uid).set({
        'uid': account.uid,
        'email': account.email,
        'displayName': account.displayName,
        'password': account.password,
        'role': account.role.label,
        'createdAt': Timestamp.now(),
      });
    }

    for (final product in LocalSeedData.products) {
      await firestore.collection('products').doc(product.id).set({
        'id': product.id,
        'ownerId': product.ownerId,
        'ownerName': product.ownerName,
        'name': product.name,
        'category': product.category,
        'price': product.price,
        'imageUrl': product.imageUrl,
        'isAvailable': product.isAvailable,
        'popularity': product.popularity,
        'createdAt': Timestamp.now(),
      });
    }

    await mockNetworkDelay(const Duration(milliseconds: 120));

    return MockServices(
      auth: auth,
      firestore: firestore,
      seedUsers: seedUsers,
      authService: SeededAuthService(
        mockAuth: auth,
        firestore: firestore,
      ),
      productService: ProductService(
        firestore: firestore,
        simulateNetworkDelay: true,
      ),
      feedbackService: FeedbackService(firestore: firestore),
      orderService: OrderService(
        firestore: firestore,
        simulateNetworkDelay: true,
      ),
      adminService: AdminService.test(),
    );
  }
}

class MockServices {
  MockServices({
    required this.auth,
    required this.firestore,
    required this.seedUsers,
    required this.authService,
    required this.productService,
    required this.feedbackService,
    required this.orderService,
    required this.adminService,
  });

  final MockFirebaseAuth auth;
  final FakeFirebaseFirestore firestore;
  final List<MockUser> seedUsers;
  final AuthService authService;
  final ProductService productService;
  final FeedbackService feedbackService;
  final OrderService orderService;
  final AdminService adminService;
}
