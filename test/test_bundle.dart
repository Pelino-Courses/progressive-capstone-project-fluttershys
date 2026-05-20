import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:sukaapp/providers/app_state.dart';
import 'package:sukaapp/services/admin_service.dart';
import 'package:sukaapp/services/auth_service.dart';
import 'package:sukaapp/services/feedback_service.dart';
import 'package:sukaapp/services/order_service.dart';
import 'package:sukaapp/services/product_service.dart';

class TestBundle {
  TestBundle({required this.appState, required this.firestore});

  final AppState appState;
  final FakeFirebaseFirestore firestore;
}

Future<TestBundle> createTestBundle({
  bool signedIn = true,
  bool isAdmin = false,
  bool seedProduct = false,
}) async {
  final firestore = FakeFirebaseFirestore();

  const uid = 'user-1';
  const email = 'user1@frutella.test';
  const displayName = 'User One';

  final auth = MockFirebaseAuth(
    signedIn: signedIn,
    mockUser: MockUser(uid: uid, email: email, displayName: displayName),
  );

  if (signedIn) {
    await firestore.collection('users').doc(uid).set({
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': isAdmin ? 'admin' : 'buyer',
      'createdAt': Timestamp.now(),
    });
  }

  if (seedProduct) {
    await firestore.collection('products').doc('product-1').set({
      'id': 'product-1',
      'ownerId': 'seller-2',
      'ownerName': 'Seller Two',
      'name': 'Fresh Mangoes',
      'category': 'Fruits',
      'price': 1500.0,
      'isAvailable': true,
      'popularity': 3,
      'createdAt': Timestamp.now(),
    });
  }

  final appState = AppState(
    authService: AuthService(auth: auth, firestore: firestore),
    productService: ProductService(firestore: firestore),
    feedbackService: FeedbackService(firestore: firestore),
    orderService: OrderService(firestore: firestore),
    adminService: AdminService.test(),
    firestore: firestore,
  );

  return TestBundle(appState: appState, firestore: firestore);
}
