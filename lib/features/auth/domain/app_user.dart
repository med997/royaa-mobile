class AppUser {
  final String id;
  final String userName;
  final String mobileNo;
  final String? email;
  final bool isVerified;

  const AppUser({
    required this.id,
    required this.userName,
    required this.mobileNo,
    required this.isVerified,
    this.email,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        userName: json['userName'] as String,
        mobileNo: json['mobileNo'] as String,
        email: json['email'] as String?,
        isVerified: json['isVerified'] as bool? ?? false,
      );
}
