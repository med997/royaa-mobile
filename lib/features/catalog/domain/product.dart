class ProductImage {
  final String id;
  final String url;
  const ProductImage({required this.id, required this.url});
  factory ProductImage.fromJson(Map<String, dynamic> json) => ProductImage(id: json['id'] as String, url: json['url'] as String);
}

class ProductVariant {
  final String id;
  final String colorNameAr;
  final String colorNameEn;
  final String colorHex;
  final int stock;

  const ProductVariant({
    required this.id,
    required this.colorNameAr,
    required this.colorNameEn,
    required this.colorHex,
    required this.stock,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json['id'] as String,
        colorNameAr: json['colorNameAr'] as String,
        colorNameEn: json['colorNameEn'] as String,
        colorHex: json['colorHex'] as String,
        stock: json['stock'] as int,
      );
}

class Product {
  final String id;
  final String nameAr;
  final String nameEn;
  final String? descriptionAr;
  final String? descriptionEn;
  final num price;
  final String currency;
  final int? widthMm;
  final int? bridgeMm;
  final int? armMm;
  final double rating;
  final int ratingCount;
  final String? categoryNameEn;
  final String? brandName;
  final List<ProductImage> images;
  final List<ProductVariant> variants;

  const Product({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.price,
    required this.currency,
    required this.rating,
    required this.ratingCount,
    required this.images,
    required this.variants,
    this.descriptionAr,
    this.descriptionEn,
    this.widthMm,
    this.bridgeMm,
    this.armMm,
    this.categoryNameEn,
    this.brandName,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        nameAr: json['nameAr'] as String,
        nameEn: json['nameEn'] as String,
        descriptionAr: json['descriptionAr'] as String?,
        descriptionEn: json['descriptionEn'] as String?,
        price: json['price'] as num,
        currency: json['currency'] as String,
        widthMm: json['widthMm'] as int?,
        bridgeMm: json['bridgeMm'] as int?,
        armMm: json['armMm'] as int?,
        rating: (json['rating'] as num).toDouble(),
        ratingCount: json['ratingCount'] as int,
        categoryNameEn: (json['category'] as Map<String, dynamic>?)?['nameEn'] as String?,
        brandName: (json['brand'] as Map<String, dynamic>?)?['name'] as String?,
        images: (json['images'] as List).map((e) => ProductImage.fromJson(e as Map<String, dynamic>)).toList(),
        variants: (json['variants'] as List).map((e) => ProductVariant.fromJson(e as Map<String, dynamic>)).toList(),
      );
}
