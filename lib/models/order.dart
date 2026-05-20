import 'product.dart';

class AppOrder {
  final String id;
  final String buyerId;
  final String buyerEmail;
  final String productId;
  final String productName;
  final String sellerId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String status;
  final String? note;
  final DateTime createdAt;

  const AppOrder({
    required this.id,
    required this.buyerId,
    required this.buyerEmail,
    required this.productId,
    required this.productName,
    required this.sellerId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.status,
    this.note,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'buyerId': buyerId,
      'buyerEmail': buyerEmail,
      'productId': productId,
      'productName': productName,
      'sellerId': sellerId,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'status': status,
      'note': note,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppOrder.fromJson(Map<String, dynamic> map) {
    return AppOrder(
      id: (map['id'] as String?) ?? '',
      buyerId: (map['buyerId'] as String?) ?? '',
      buyerEmail: (map['buyerEmail'] as String?) ?? '',
      productId: (map['productId'] as String?) ?? '',
      productName: (map['productName'] as String?) ?? 'Unknown Product',
      sellerId: (map['sellerId'] as String?) ?? '',
      quantity: (map['quantity'] as num?)?.toInt() ?? 1,
      unitPrice: (map['unitPrice'] as num?)?.toDouble() ?? 0,
      totalPrice: (map['totalPrice'] as num?)?.toDouble() ?? 0,
      status: (map['status'] as String?) ?? 'placed',
      note: map['note'] as String?,
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  AppOrder copyWith({String? status}) {
    return AppOrder(
      id: id,
      buyerId: buyerId,
      buyerEmail: buyerEmail,
      productId: productId,
      productName: productName,
      sellerId: sellerId,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      status: status ?? this.status,
      note: note,
      createdAt: createdAt,
    );
  }

  factory AppOrder.fromProduct({
    required String id,
    required String buyerId,
    required String buyerEmail,
    required Product product,
    required int quantity,
    String? note,
  }) {
    final total = product.price * quantity;
    return AppOrder(
      id: id,
      buyerId: buyerId,
      buyerEmail: buyerEmail,
      productId: product.id,
      productName: product.name,
      sellerId: product.ownerId,
      quantity: quantity,
      unitPrice: product.price,
      totalPrice: total,
      status: 'placed',
      note: note,
      createdAt: DateTime.now(),
    );
  }
}
