import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/app_user.dart';
import '../models/order.dart';
import '../models/product.dart';
import '../services/local_seed_data.dart';

/// Local-first persistence (SharedPreferences). No Firebase.
class LocalDataStore {
  LocalDataStore._();
  static final LocalDataStore instance = LocalDataStore._();

  static const _keyUsers = 'frutella_users_v1';
  static const _keyProducts = 'frutella_products_v1';
  static const _keyOrders = 'frutella_orders_v1';
  static const _keySessionUid = 'frutella_session_uid';
  static const _keyCart = 'frutella_cart_v1';
  static const _keyInitialized = 'frutella_initialized_v1';
  static const _keyFavoritesPrefix = 'frutella_favorites_';
  static const _keySearchPrefix = 'frutella_search_';
  static const _keyRecentPrefix = 'frutella_recent_';

  SharedPreferences? _prefs;
  final _productsController = StreamController<List<Product>>.broadcast();
  final _ordersController = StreamController<List<AppOrder>>.broadcast();
  final _usersController = StreamController<List<AppUser>>.broadcast();
  final _sessionController = StreamController<AppUser?>.broadcast();

  List<AppUser> _users = [];
  List<Product> _products = [];
  List<AppOrder> _orders = [];
  AppUser? _sessionUser;

  /// Emits current value first so new [StreamBuilder] listeners are not stuck waiting.
  Stream<List<Product>> get productsStream =>
      _seeded(_products, _productsController);
  Stream<List<AppOrder>> get ordersStream =>
      _seeded(_orders, _ordersController);
  Stream<List<AppUser>> get usersStream => _seeded(_users, _usersController);
  Stream<AppUser?> get sessionStream => _seededSession();

  Stream<T> _seeded<T>(T initial, StreamController<T> controller) async* {
    yield initial;
    yield* controller.stream;
  }

  Stream<AppUser?> _seededSession() async* {
    yield _sessionUser;
    yield* _sessionController.stream;
  }

  AppUser? get sessionUser => _sessionUser;
  List<Product> get products => List.unmodifiable(_products);
  List<AppOrder> get orders => List.unmodifiable(_orders);
  List<AppUser> get users => List.unmodifiable(_users);

  /// Clears persisted state and re-seeds — for tests only.
  Future<void> resetForTests() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs!.clear();
    await init(resetSeed: true);
  }

  Future<void> init({bool resetSeed = false}) async {
    _prefs ??= await SharedPreferences.getInstance();
    final initialized = _prefs!.getBool(_keyInitialized) ?? false;

    if (!initialized || resetSeed) {
      await _seedDefaults();
      await _prefs!.setBool(_keyInitialized, true);
    } else {
      await _loadAll();
    }

    final savedUid = _prefs!.getString(_keySessionUid);
    if (savedUid != null) {
      for (final u in _users) {
        if (u.uid == savedUid) {
          _sessionUser = u;
          break;
        }
      }
    }
    _emitAll();
  }

  Future<void> _seedDefaults() async {
    _users = [
      for (final a in LocalSeedData.allAccounts)
        AppUser(
          uid: a.uid,
          email: a.email,
          displayName: a.displayName,
          role: a.role,
          createdAt: DateTime.now(),
          password: a.password,
        ),
    ];

    _products = [
      for (final p in LocalSeedData.products)
        Product(
          id: p.id,
          ownerId: p.ownerId,
          ownerName: p.ownerName,
          name: p.name,
          category: p.category,
          price: p.price,
          description: 'Fresh ${p.name} from ${p.ownerName}.',
          imageUrl: _assetForProductId(p.id),
          stockQuantity: p.isAvailable ? 50 : 0,
          isAvailable: p.isAvailable,
          popularity: p.popularity,
          createdAt: DateTime.now(),
          isApproved: true,
        ),
    ];

    _orders = [];
    await _persistAll();
  }

  static String _assetForProductId(String id) {
    const map = {
      'prod-1': 'assets/images/products/mango.jpg',
      'prod-2': 'assets/images/products/avocado.jpg',
      'prod-3': 'assets/images/products/tomato.jpg',
      'prod-4': 'assets/images/products/pepper.jpg',
      'prod-5': 'assets/images/products/cassava.jpg',
      'prod-6': 'assets/images/products/potato.jpg',
      'prod-7': 'assets/images/products/banana.jpg',
      'prod-8': 'assets/images/products/carrot.jpg',
    };
    return map[id] ?? 'assets/images/products/tomato.jpg';
  }

  Future<void> _loadAll() async {
    final usersJson = _prefs!.getString(_keyUsers);
    final productsJson = _prefs!.getString(_keyProducts);
    final ordersJson = _prefs!.getString(_keyOrders);

    if (usersJson != null) {
      _users = (jsonDecode(usersJson) as List)
          .map((e) => AppUser.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (productsJson != null) {
      _products = (jsonDecode(productsJson) as List)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    if (ordersJson != null) {
      _orders = (jsonDecode(ordersJson) as List)
          .map((e) => AppOrder.fromJson(e as Map<String, dynamic>))
          .toList();
    }
  }

  Future<void> _persistAll() async {
    await _prefs!.setString(
      _keyUsers,
      jsonEncode(_users.map((u) => u.toJson()).toList()),
    );
    await _prefs!.setString(
      _keyProducts,
      jsonEncode(_products.map((p) => p.toJson()).toList()),
    );
    await _prefs!.setString(
      _keyOrders,
      jsonEncode(_orders.map((o) => o.toJson()).toList()),
    );
  }

  void _emitAll() {
    refreshStreams();
  }

  void refreshStreams() {
    _productsController.add(List.from(_products));
    _ordersController.add(List.from(_orders));
    _usersController.add(List.from(_users));
    _sessionController.add(_sessionUser);
  }

  AppUser? findUserByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    for (final u in _users) {
      if (u.email.toLowerCase() == normalized) return u;
    }
    return null;
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final user = findUserByEmail(email);
    if (user == null || user.password != password) {
      throw AuthException('Incorrect email or password.');
    }
    if (user.isSuspended) {
      throw AuthException('This account is suspended.');
    }
    _sessionUser = user;
    await _prefs!.setString(_keySessionUid, user.uid);
    _sessionController.add(_sessionUser);
    return user;
  }

  Future<AppUser> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (findUserByEmail(email) != null) {
      throw AuthException('That email is already registered.');
    }
    final user = AppUser(
      uid: 'user-${DateTime.now().millisecondsSinceEpoch}',
      email: email.trim(),
      displayName: name.trim(),
      role: UserRole.buyer,
      createdAt: DateTime.now(),
      password: password,
    );
    _users.add(user);
    await _persistAll();
    _usersController.add(List.from(_users));
    _sessionUser = user;
    await _prefs!.setString(_keySessionUid, user.uid);
    _sessionController.add(_sessionUser);
    return user;
  }

  Future<void> signOut() async {
    _sessionUser = null;
    await _prefs!.remove(_keySessionUid);
    _sessionController.add(null);
  }

  Future<void> updateUserRole(String uid, String role) async {
    final index = _users.indexWhere((u) => u.uid == uid);
    if (index < 0) return;
    _users[index] = _users[index].copyWith(role: UserRoleX.fromString(role));
    await _persistAll();
    _usersController.add(List.from(_users));
    if (_sessionUser?.uid == uid) {
      _sessionUser = _users[index];
      _sessionController.add(_sessionUser);
    }
  }

  Future<void> updateUser(AppUser user) async {
    final index = _users.indexWhere((u) => u.uid == user.uid);
    if (index < 0) return;
    _users[index] = user;
    await _persistAll();
    _usersController.add(List.from(_users));
    if (_sessionUser?.uid == user.uid) {
      _sessionUser = user;
      _sessionController.add(_sessionUser);
    }
  }

  Future<void> setUserSuspended(String uid, bool suspended) async {
    final index = _users.indexWhere((u) => u.uid == uid);
    if (index < 0) return;
    _users[index] = _users[index].copyWith(isSuspended: suspended);
    await _persistAll();
    _usersController.add(List.from(_users));
  }

  Future<Product> saveProduct(Product product) async {
    final index = _products.indexWhere((p) => p.id == product.id);
    if (index >= 0) {
      _products[index] = product;
    } else {
      _products.insert(0, product);
    }
    await _persistAll();
    _productsController.add(List.from(_products));
    return product;
  }

  Future<void> deleteProduct(String id) async {
    _products.removeWhere((p) => p.id == id);
    await _persistAll();
    _productsController.add(List.from(_products));
  }

  Future<AppOrder> saveOrder(AppOrder order) async {
    _orders.insert(0, order);
    await _persistAll();
    _ordersController.add(List.from(_orders));
    return order;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index < 0) return;
    _orders[index] = _orders[index].copyWith(status: status);
    await _persistAll();
    _ordersController.add(List.from(_orders));
  }

  Future<String?> loadCartJson() async => _prefs?.getString(_keyCart);

  Future<void> saveCartJson(String? json) async {
    if (json == null) {
      await _prefs?.remove(_keyCart);
    } else {
      await _prefs?.setString(_keyCart, json);
    }
  }

  Future<List<String>> loadFavoriteIds(String uid) async {
    final raw = _prefs?.getString('$_keyFavoritesPrefix$uid');
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<String>();
  }

  Future<void> toggleFavorite(String uid, String productId) async {
    final ids = await loadFavoriteIds(uid);
    if (ids.contains(productId)) {
      ids.remove(productId);
    } else {
      ids.insert(0, productId);
    }
    await _prefs?.setString(
      '$_keyFavoritesPrefix$uid',
      jsonEncode(ids.take(50).toList()),
    );
  }

  Future<List<String>> loadSearchHistory(String uid) async {
    final raw = _prefs?.getString('$_keySearchPrefix$uid');
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<String>();
  }

  Future<void> addSearchTerm(String uid, String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;
    final history = await loadSearchHistory(uid);
    history.removeWhere((h) => h.toLowerCase() == trimmed.toLowerCase());
    history.insert(0, trimmed);
    await _prefs?.setString(
      '$_keySearchPrefix$uid',
      jsonEncode(history.take(12).toList()),
    );
  }

  Future<List<String>> loadRecentlyViewed(String uid) async {
    final raw = _prefs?.getString('$_keyRecentPrefix$uid');
    if (raw == null) return [];
    return (jsonDecode(raw) as List).cast<String>();
  }

  Future<void> recordProductView(String uid, String productId) async {
    final recent = await loadRecentlyViewed(uid);
    recent.remove(productId);
    recent.insert(0, productId);
    await _prefs?.setString(
      '$_keyRecentPrefix$uid',
      jsonEncode(recent.take(20).toList()),
    );
  }

  List<Product> productsByIds(List<String> ids) {
    final map = {for (final p in _products) p.id: p};
    return [
      for (final id in ids)
        if (map[id] != null) map[id]!,
    ];
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
