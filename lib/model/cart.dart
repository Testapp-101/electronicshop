// ignore_for_file: file_names

class Cart {
  late final int? id;
  final int? productId;
  final String? productName;
  final String? productImage;
  final String? initialPrice;
  final String? productPrice;
  final int? stock;
  final int? quantity;

  Cart({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.initialPrice,
    required this.productPrice,
    required this.stock,
    required this.quantity,
  });

  Cart.fromMap(Map<dynamic, dynamic> res)
      : id = res['id'],
        productId = res['productId'],
        productName = res['productName'],
        productImage = res['productImage'],
        initialPrice = res['initialPrice'],
        productPrice = res['productPrice'],
        stock = res['stock'],
        quantity = res['quantity'];

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'initialPrice': initialPrice,
      'productPrice': productPrice,
      'stock': stock,
      'quantity': quantity,
    };
  }
}
