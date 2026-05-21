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
  final String password;
  final bool isSuspended;
  final String? avatarPath;

  const AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.createdAt,
    this.password = '',
    this.isSuspended = false,
    this.avatarPath,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isVendor => role == UserRole.vendor;
  bool get isBuyer => role == UserRole.buyer;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.label,
      'createdAt': createdAt.toIso8601String(),
      'password': password,
      'isSuspended': isSuspended,
      'avatarPath': avatarPath,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> map) {
    return AppUser(
      uid: (map['uid'] as String?) ?? '',
      email: (map['email'] as String?) ?? '',
      displayName: (map['displayName'] as String?) ?? 'User',
      role: UserRoleX.fromString(map['role'] as String?),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      password: (map['password'] as String?) ?? '',
      isSuspended: (map['isSuspended'] as bool?) ?? false,
      avatarPath: map['avatarPath'] as String?,
    );
  }

  AppUser copyWith({
    String? displayName,
    UserRole? role,
    bool? isSuspended,
    String? avatarPath,
  }) {
    return AppUser(
      uid: uid,
      email: email,
      displayName: displayName ?? this.displayName,
      role: role ?? this.role,
      createdAt: createdAt,
      password: password,
      isSuspended: isSuspended ?? this.isSuspended,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }
}
