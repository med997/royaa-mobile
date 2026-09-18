class ApiResponse<T> {
  final String errorMessage;
  final int errorNo;
  final T data;

  const ApiResponse({required this.errorMessage, required this.errorNo, required this.data});

  bool get isSuccess => errorNo == 0;

  factory ApiResponse.fromJson(Map<String, dynamic> json, T Function(dynamic) fromData) {
    return ApiResponse<T>(
      errorMessage: json['errorMessage'] as String? ?? '',
      errorNo: json['errorNo'] as int? ?? 0,
      data: fromData(json['data']),
    );
  }
}
