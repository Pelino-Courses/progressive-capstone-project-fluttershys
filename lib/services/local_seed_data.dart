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
  /// Product photos: real subject-matching images (Wikimedia Commons). Do not use
  /// picsum-style placeholders — their "seed" only affects random selection, not the subject.
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
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/9/90/Mango_-_single.jpg',
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
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/c/c9/Persea_americana_fruit_2.jpg',
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
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/8/88/Bright_red_tomato_and_cross_section02.jpg',
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
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/e/e5/Bell_peppers_in_basket.jpg',
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
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/2/26/Yuca_root.jpg',
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
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/5/59/Sweet_potato_pile.jpg',
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
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/8/8a/Banana-Single.jpg',
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
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/a/a2/Vegetable-Carrot-Bundle-wGreenStalk-Bag-Covers.jpg',
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
