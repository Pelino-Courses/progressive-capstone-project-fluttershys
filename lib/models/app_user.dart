import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { buyer, vendor, admin }

extension UserRoleX on UserRole {
  String get label {
    switch (this) {
      case UserRole.buyer:
        return 'buyer';
      case UserRole.vendor:
        return 'vendor';
      case UserRole.admin:
        return 'admin';
    }
  }

  static UserRole fromString(String? value) {
    switch (value) {
      case 'admin':
        return UserRole.admin;
      case 'vendor':
        return UserRole.vendor;
      case 'user':
      case 'buyer':
      default:
        return UserRole.buyer;
    }
  }
}

class AppUser {
  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.createdAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isVendor => role == UserRole.vendor;
  bool get isBuyer => role == UserRole.buyer;

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.label,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: (map['uid'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      displayName: (map['displayName'] as String?) ?? 'User',
      role: UserRoleX.fromString(map['role'] as String?),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
