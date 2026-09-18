class CartItemProduct {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? image;
  final num price;

  const CartItemProduct({required this.id, required this.nameAr, required this.nameEn, required this.price, this.image});

  factory CartItemProduct.fromJson(Map<String, dynamic> json) => CartItemProduct(
        id: json['id'] as String,
        nameAr: json['nameAr'] as String,
        nameEn: json['nameEn'] as String,
        image: json['image'] as String?,
        price: json['price'] as num,
      );
}

class CartItemVariant {
  final String id;
  final String colorNameAr;
  final String colorNameEn;
  final String colorHex;
  const CartItemVariant({required this.id, required this.colorNameAr, required this.colorNameEn, required this.colorHex});

  factory CartItemVariant.fromJson(Map<String, dynamic> json) => CartItemVariant(
        id: json['id'] as String,
        colorNameAr: json['colorNameAr'] as String,
        colorNameEn: json['colorNameEn'] as String,
        colorHex: json['colorHex'] as String,
      );
}

class CartItem {
  final String id;
  final int quantity;
  final CartItemProduct product;
  final CartItemVariant? variant;
  final num lineTotal;

  const CartItem({required this.id, required this.quantity, required this.product, required this.lineTotal, this.variant});

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'] as String,
        quantity: json['quantity'] as int,
        product: CartItemProduct.fromJson(json['product'] as Map<String, dynamic>),
        variant: json['variant'] != null ? CartItemVariant.fromJson(json['variant'] as Map<String, dynamic>) : null,
        lineTotal: json['lineTotal'] as num,
      );
}

class Cart {
  final List<CartItem> items;
  final num subtotal;
  final String currency;

  const Cart({required this.items, required this.subtotal, required this.currency});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        items: (json['items'] as List).map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList(),
        subtotal: json['subtotal'] as num,
        currency: json['currency'] as String,
      );
}
