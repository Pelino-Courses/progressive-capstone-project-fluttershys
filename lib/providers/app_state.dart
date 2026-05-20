import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/app_user.dart';
import '../models/product.dart';
import '../services/admin_service.dart';
import '../services/auth_service.dart';
import '../services/cart_service.dart';
import '../services/feedback_service.dart';
import '../services/order_service.dart';
import '../services/product_service.dart';

class AppState extends ChangeNotifier {
  AppState({
    AuthService? authService,
    ProductService? productService,
    FeedbackService? feedbackService,
    OrderService? orderService,
    AdminService? adminService,
    CartService? cartService,
    FirebaseFirestore? firestore,
  }) : _authService = authService ?? AuthService(),
       _productService = productService ?? ProductService(),
       _feedbackService = feedbackService ?? FeedbackService(),
       _orderService = orderService ?? OrderService(),
       _adminService = adminService ?? AdminService(),
       _firestore = firestore ?? FirebaseFirestore.instance,
       cartService = cartService ?? CartService() {
    _authSub = _authService.authStateChanges().listen(_onAuthChanged);
    this.cartService.addListener(_onCartChanged);
  }

  final AuthService _authService;
  final ProductService _productService;
  final FeedbackService _feedbackService;
  final OrderService _orderService;
  final AdminService _adminService;
  final FirebaseFirestore _firestore;
  final CartService cartService;

  FirebaseFirestore get firestore => _firestore;

  StreamSubscription<User?>? _authSub;
  StreamSubscription<AppUser?>? _profileSub;

  User? firebaseUser;
  AppUser? profile;
  bool isLoading = true;
  String? errorMessage;
  bool _pendingOpenCart = false;

  ProductService get productService => _productService;
  OrderService get orderService => _orderService;

  String get currentUserId => firebaseUser?.uid ?? '';
  bool get isAuthenticated => firebaseUser != null;
  bool get isAdmin => profile?.isAdmin ?? false;
  bool get isVendor => profile?.isVendor ?? false;
  bool get isBuyer => profile?.isBuyer ?? true;
  int get cartItemCount => cartService.itemCount;

  /// Switch to the cart tab in the current role dashboard (handled by each shell).
  void requestOpenCart() {
    _pendingOpenCart = true;
    notifyListeners();
  }

  bool get hasPendingOpenCart => _pendingOpenCart;

  /// Returns true once when the user asked to open the cart; clears the flag.
  bool takePendingOpenCart() {
    if (!_pendingOpenCart) return false;
    _pendingOpenCart = false;
    return true;
  }

  void _onCartChanged() => notifyListeners();

  Future<void> _onAuthChanged(User? user) async {
    firebaseUser = user;
    errorMessage = null;

    await _profileSub?.cancel();
    if (user == null) {
      profile = null;
      cartService.clear();
      isLoading = false;
      notifyListeners();
      return;
    }

    _profileSub = _authService.userProfileStream(user.uid).listen((nextProfile) {
      profile = nextProfile;
      isLoading = false;
      notifyListeners();
    });
  }

  Future<bool> signIn({required String email, required String password}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authService.signIn(email: email, password: password);
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _friendlyAuthMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      await _authService.signUp(
        email: email,
        password: password,
        displayName: name,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      errorMessage = _friendlyAuthMessage(e);
      isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    cartService.clear();
    await _authService.signOut();
  }

  void addToCart(Product product, {int quantity = 1}) {
    cartService.add(product, quantity: quantity);
  }

  Future<bool> checkoutCart() async {
    final user = firebaseUser;
    if (user == null || cartService.items.isEmpty) return false;

    try {
      for (final item in cartService.items) {
        await _orderService.placeOrder(
          buyerId: user.uid,
          buyerEmail: user.email ?? '',
          product: item.product,
          quantity: item.quantity,
        );
      }
      cartService.clear();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> placeOrder({
    required Product product,
    required int quantity,
    String? note,
  }) async {
    final user = firebaseUser;
    if (user == null) return false;

    try {
      await _orderService.placeOrder(
        buyerId: user.uid,
        buyerEmail: user.email ?? '',
        product: product,
        quantity: quantity,
        note: note,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> submitFeedback(String message) async {
    final user = firebaseUser;
    if (user == null) return false;

    try {
      await _feedbackService.submitFeedback(
        userId: user.uid,
        email: user.email ?? '',
        message: message,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setUserRole({
    required String targetUid,
    required String role,
  }) async {
    try {
      await _adminService.setUserRole(targetUid: targetUid, role: role);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> sendCampaign({
    required String title,
    required String body,
  }) async {
    try {
      await _adminService.sendCampaign(title: title, body: body);
      return true;
    } catch (_) {
      return false;
    }
  }

  String _friendlyAuthMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'That email is already registered.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'operation-not-allowed':
        return 'Email/password sign-in is not enabled in Firebase.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Incorrect email or password.';
      default:
        return e.message ?? 'Authentication failed.';
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _profileSub?.cancel();
    cartService.removeListener(_onCartChanged);
    super.dispose();
  }
}
