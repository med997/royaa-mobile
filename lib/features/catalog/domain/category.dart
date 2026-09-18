class Category {
  final String id;
  final String nameAr;
  final String nameEn;

  const Category({required this.id, required this.nameAr, required this.nameEn});

  factory Category.fromJson(Map<String, dynamic> json) =>
      Category(id: json['id'] as String, nameAr: json['nameAr'] as String, nameEn: json['nameEn'] as String);
}
