import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_exception.dart';
import '../../../core/storage/secure_storage.dart';
import '../data/auth_api.dart';
import '../domain/app_user.dart';
import 'auth_status.dart';

class AuthState {
  final AuthStatus status;
  final AppUser? user;
  const AuthState({this.status = AuthStatus.unknown, this.user});

  AuthState copyWith({AuthStatus? status, AppUser? user}) =>
      AuthState(status: status ?? this.status, user: user ?? this.user);
}

class AuthController extends StateNotifier<AuthState> {
  final AuthApi _api;
  final TokenStorage _storage;
  final AuthStatusNotifier _statusNotifier;

  AuthController(this._api, this._storage, this._statusNotifier) : super(const AuthState()) {
    _restore();
  }

  void _setStatus(AuthStatus status, {AppUser? user}) {
    state = state.copyWith(status: status, user: user);
    _statusNotifier.value = status;
  }

  Future<void> _restore() async {
    final token = await _storage.read();
    if (token == null) return _setStatus(AuthStatus.unauthenticated);
    try {
      final user = await _api.me();
      _setStatus(AuthStatus.authenticated, user: user);
    } catch (_) {
      await _storage.clear();
      _setStatus(AuthStatus.unauthenticated);
    }
  }

  Future<void> register({required String userName, required String mobileNo, required String password}) async {
    try {
      await _api.register(userName: userName, mobileNo: mobileNo, password: password);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> requestOtp(String mobileNo) async {
    try {
      await _api.sendOtp(mobileNo);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> verifyOtp({required String mobileNo, required String code}) async {
    try {
      final (token, user) = await _api.verifyOtp(mobileNo: mobileNo, code: code);
      await _storage.save(token);
      _setStatus(AuthStatus.authenticated, user: user);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> login({required String mobileNo, required String password}) async {
    try {
      final (token, user) = await _api.login(mobileNo: mobileNo, password: password);
      await _storage.save(token);
      _setStatus(AuthStatus.authenticated, user: user);
    } on DioException catch (e) {
      throw mapDioError(e);
    }
  }

  Future<void> logout() async {
    await _storage.clear();
    _setStatus(AuthStatus.unauthenticated);
  }
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    ref.watch(authApiProvider),
    ref.watch(tokenStorageProvider),
    ref.watch(authStatusNotifierProvider),
  );
});
