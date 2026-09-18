class Brand {
  final String id;
  final String name;

  const Brand({required this.id, required this.name});

  factory Brand.fromJson(Map<String, dynamic> json) => Brand(id: json['id'] as String, name: json['name'] as String);
}
