class Review {
  final String id;
  final String userName;
  final int rating;
  final String? comment;
  final DateTime createdAt;

  const Review({required this.id, required this.userName, required this.rating, required this.createdAt, this.comment});

  factory Review.fromJson(Map<String, dynamic> json) => Review(
        id: json['id'] as String,
        userName: json['userName'] as String,
        rating: json['rating'] as int,
        comment: json['comment'] as String?,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
