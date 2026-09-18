import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../domain/app_user.dart';

class AuthApi {
  final Dio _dio;
  const AuthApi(this._dio);

  Future<void> register({required String userName, required String mobileNo, required String password}) async {
    await _dio.post('/auth/register', data: {'userName': userName, 'mobileNo': mobileNo, 'password': password});
  }

  Future<void> sendOtp(String mobileNo) async {
    await _dio.post('/auth/otp/send', data: {'mobileNo': mobileNo});
  }

  Future<(String, AppUser)> verifyOtp({required String mobileNo, required String code}) async {
    final res = await _dio.post('/auth/otp/verify', data: {'mobileNo': mobileNo, 'code': code});
    final data = res.data['data'] as Map<String, dynamic>;
    return (data['token'] as String, AppUser.fromJson(data['user'] as Map<String, dynamic>));
  }

  Future<(String, AppUser)> login({required String mobileNo, required String password}) async {
    final res = await _dio.post('/auth/login', data: {'mobileNo': mobileNo, 'password': password});
    final data = res.data['data'] as Map<String, dynamic>;
    return (data['token'] as String, AppUser.fromJson(data['user'] as Map<String, dynamic>));
  }

  Future<AppUser> me() async {
    final res = await _dio.get('/auth/me');
    return AppUser.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}

final authApiProvider = Provider((ref) => AuthApi(ref.watch(dioProvider)));
