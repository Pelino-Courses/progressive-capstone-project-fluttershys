import '../models/app_user.dart';

class LocalSeedAccount {
  const LocalSeedAccount({
    required this.uid,
    required this.email,
    required this.password,
    required this.displayName,
    required this.role,
  });

  final String uid;
  final String email;
  final String password;
  final String displayName;
  final UserRole role;
}

class LocalSeedProduct {
  const LocalSeedProduct({
    required this.id,
    required this.ownerId,
    required this.ownerName,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.isAvailable,
    required this.popularity,
  });

  final String id;
  final String ownerId;
  final String ownerName;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final bool isAvailable;
  final int popularity;
}

class LocalSeedData {
  /// Product images are bundled under assets/images/products/ (see LocalDataStore).
  static const LocalSeedAccount demoBuyer = LocalSeedAccount(
    uid: 'user-1',
    email: 'demo@frutella.test',
    password: 'Demo123!',
    displayName: 'Demo User',
    role: UserRole.buyer,
  );

  static const LocalSeedAccount admin = LocalSeedAccount(
    uid: 'admin-1',
    email: 'admin@frutella.test',
    password: 'Admin123!',
    displayName: 'Frutella Admin',
    role: UserRole.admin,
  );

  static const List<LocalSeedAccount> vendors = [
    LocalSeedAccount(
      uid: 'seller-1',
      email: 'mama.grace@market.rw',
      password: 'Seller123!',
      displayName: 'Mama Grace',
      role: UserRole.vendor,
    ),
    LocalSeedAccount(
      uid: 'seller-2',
      email: 'uncle.jean@market.rw',
      password: 'Seller123!',
      displayName: 'Uncle Jean',
      role: UserRole.vendor,
    ),
    LocalSeedAccount(
      uid: 'seller-3',
      email: 'auntie.rose@market.rw',
      password: 'Seller123!',
      displayName: 'Auntie Rose',
      role: UserRole.vendor,
    ),
  ];

  static const List<LocalSeedProduct> products = [
    LocalSeedProduct(
      id: 'prod-1',
      ownerId: 'seller-1',
      ownerName: 'Mama Grace',
      name: 'Fresh Mangoes',
      category: 'Fruits',
      price: 1500,
      imageUrl: 'assets/images/products/mango.jpg',
      isAvailable: true,
      popularity: 5,
    ),
    LocalSeedProduct(
      id: 'prod-2',
      ownerId: 'seller-1',
      ownerName: 'Mama Grace',
      name: 'Ripe Avocados',
      category: 'Fruits',
      price: 2000,
      imageUrl: 'assets/images/products/avocado.jpg',
      isAvailable: true,
      popularity: 4,
    ),
    LocalSeedProduct(
      id: 'prod-3',
      ownerId: 'seller-2',
      ownerName: 'Uncle Jean',
      name: 'Fresh Tomatoes (1kg)',
      category: 'Vegetables',
      price: 800,
      imageUrl: 'assets/images/products/tomato.jpg',
      isAvailable: true,
      popularity: 3,
    ),
    LocalSeedProduct(
      id: 'prod-4',
      ownerId: 'seller-2',
      ownerName: 'Uncle Jean',
      name: 'Bell Peppers (Mixed)',
      category: 'Vegetables',
      price: 1200,
      imageUrl: 'assets/images/products/pepper.jpg',
      isAvailable: false,
      popularity: 2,
    ),
    LocalSeedProduct(
      id: 'prod-5',
      ownerId: 'seller-3',
      ownerName: 'Auntie Rose',
      name: 'Cassava (2kg)',
      category: 'Tubers',
      price: 1800,
      imageUrl: 'assets/images/products/cassava.jpg',
      isAvailable: true,
      popularity: 4,
    ),
    LocalSeedProduct(
      id: 'prod-6',
      ownerId: 'seller-3',
      ownerName: 'Auntie Rose',
      name: 'Sweet Potatoes (2kg)',
      category: 'Tubers',
      price: 1600,
      imageUrl: 'assets/images/products/potato.jpg',
      isAvailable: true,
      popularity: 3,
    ),
    LocalSeedProduct(
      id: 'prod-7',
      ownerId: 'seller-1',
      ownerName: 'Mama Grace',
      name: 'Bananas (Bunch)',
      category: 'Fruits',
      price: 1100,
      imageUrl: 'assets/images/products/banana.jpg',
      isAvailable: true,
      popularity: 5,
    ),
    LocalSeedProduct(
      id: 'prod-8',
      ownerId: 'seller-2',
      ownerName: 'Uncle Jean',
      name: 'Carrots (1kg)',
      category: 'Vegetables',
      price: 900,
      imageUrl: 'assets/images/products/carrot.jpg',
      isAvailable: true,
      popularity: 3,
    ),
  ];

  static const List<LocalSeedAccount> allAccounts = [
    demoBuyer,
    admin,
    ...vendors,
  ];

  static LocalSeedAccount? findByEmail(String email) {
    final normalized = email.trim().toLowerCase();
    for (final account in allAccounts) {
      if (account.email.toLowerCase() == normalized) {
        return account;
      }
    }
    return null;
  }
}
