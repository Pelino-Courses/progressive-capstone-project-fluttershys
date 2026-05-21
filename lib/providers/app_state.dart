import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../data/local_data_store.dart';
import '../models/app_user.dart';
import '../models/product.dart';
import '../services/app_services.dart';
import '../services/cart_service.dart';
import '../services/local_admin_service.dart';
import '../services/local_feedback_service.dart';
import '../services/local_order_service.dart';
import '../services/local_product_service.dart';

class AppState extends ChangeNotifier {
  AppState({required AppServices services, CartService? cart})
    : store = services.store,
      productService = services.productService,
      orderService = services.orderService,
      feedbackService = services.feedbackService,
      adminService = services.adminService,
      cartService = cart ?? CartService() {
    this.cartService.addListener(_onCartChanged);
    _sessionSub = store.sessionStream.listen(_onSessionChanged);
    _init();
  }

  final LocalDataStore store;
  final LocalProductService productService;
  final LocalOrderService orderService;
  final LocalFeedbackService feedbackService;
  final LocalAdminService adminService;
  final CartService cartService;

  StreamSubscription<AppUser?>? _sessionSub;
  final Completer<void> _ready = Completer<void>();
  Future<void> get ready => _ready.future;

  AppUser? profile;
  bool isLoading = true;
  String? errorMessage;
  int shellTabRequest = 0;
  Set<String> _favoriteIds = {};

  String get currentUserId => profile?.uid ?? '';
  bool get isAuthenticated => profile != null;
  bool get isAdmin => profile?.isAdmin ?? false;
  bool get isVendor => profile?.isVendor ?? false;
  bool get isBuyer => profile?.isBuyer ?? true;
  int get cartItemCount => cartService.itemCount;

  Future<void> _init() async {
    await _loadCartFromDisk();
    profile = store.sessionUser;
    if (profile != null) {
      await _loadFavorites();
    }
    isLoading = false;
    notifyListeners();
    if (!_ready.isCompleted) _ready.complete();
  }

  void openCartTab() {
    shellTabRequest = 1;
    notifyListeners();
  }

  void clearShellTabRequest() {
    if (shellTabRequest == 0) return;
    shellTabRequest = 0;
  }

  void _onCartChanged() {
    _persistCart();
    notifyListeners();
  }

  Future<void> _onSessionChanged(AppUser? user) async {
    profile = user;
    errorMessage = null;
    if (user == null) {
      _favoriteIds = {};
    } else {
      await _loadFavorites();
      await _loadCartFromDisk();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> _loadCartFromDisk() async {
    final raw = await store.loadCartJson();
    if (raw == null || raw.isEmpty) return;
    try {
      final list = jsonDecode(raw) as List;
      cartService.loadFromJson(
        list,
        productResolver: (id) {
          for (final p in store.products) {
            if (p.id == id) return p;
          }
          return null;
        },
      );
    } catch (_) {}
  }

  Future<void> _persistCart() async {
    await store.saveCartJson(cartService.toJson());
  }

  Future<void> _loadFavorites() async {
    final uid = currentUserId;
    if (uid.isEmpty) return;
    _favoriteIds = (await store.loadFavoriteIds(uid)).toSet();
  }

  bool isFavorite(String productId) => _favoriteIds.contains(productId);

  Future<void> toggleFavorite(String productId) async {
    final uid = currentUserId;
    if (uid.isEmpty) return;
    await store.toggleFavorite(uid, productId);
    await _loadFavorites();
    notifyListeners();
  }

  List<Product> get favoriteProducts =>
      store.productsByIds(_favoriteIds.toList());

  Future<bool> signIn({required String email, required String password}) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();
      await store.signIn(email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
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
      await store.signUp(name: name, email: email, password: password);
      isLoading = false;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      errorMessage = e.message;
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
    await store.saveCartJson(null);
    await store.signOut();
  }

  Future<void> updateProfile({String? displayName, String? avatarPath}) async {
    final user = profile;
    if (user == null) return;
    final updated = user.copyWith(
      displayName: displayName ?? user.displayName,
      avatarPath: avatarPath ?? user.avatarPath,
    );
    await store.updateUser(updated);
  }

  /// Guest add-to-cart: returns false and caller shows sign-in prompt.
  bool tryAddToCart(Product product, {int quantity = 1}) {
    if (!isAuthenticated) return false;
    cartService.add(product, quantity: quantity);
    return true;
  }


  Future<bool> checkoutCart() async {
    final user = profile;
    if (user == null || cartService.items.isEmpty) return false;

    try {
      for (final item in cartService.items) {
        await orderService.placeOrder(
          buyerId: user.uid,
          buyerEmail: user.email,
          product: item.product,
          quantity: item.quantity,
        );
      }
      cartService.clear();
      await _persistCart();
      store.refreshStreams();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> submitFeedback(String message) async {
    final user = profile;
    if (user == null) return false;
    try {
      await feedbackService.submitFeedback(
        userId: user.uid,
        email: user.email,
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
      await adminService.setUserRole(targetUid: targetUid, role: role);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setUserSuspended({
    required String targetUid,
    required bool suspended,
  }) async {
    try {
      await adminService.setUserSuspended(
        targetUid: targetUid,
        suspended: suspended,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setProductApproval(String productId, bool approved) async {
    try {
      await productService.setProductApproval(productId, approved);
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
      await adminService.sendCampaign(title: title, body: body);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> recordProductView(String productId) async {
    final uid = currentUserId;
    if (uid.isEmpty) return;
    await store.recordProductView(uid, productId);
  }

  Future<void> addSearchTerm(String term) async {
    final uid = currentUserId;
    if (uid.isEmpty) return;
    await store.addSearchTerm(uid, term);
  }

  Future<List<Product>> loadRecentlyViewedProducts() async {
    final uid = currentUserId;
    if (uid.isEmpty) return const [];
    final ids = await store.loadRecentlyViewed(uid);
    return store.productsByIds(ids);
  }

  @override
  void dispose() {
    _sessionSub?.cancel();
    cartService.removeListener(_onCartChanged);
    super.dispose();
  }
}
