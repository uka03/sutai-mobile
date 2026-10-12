import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sutai/connection/dio_client.dart';
import 'package:sutai/core/constants.dart';
import 'package:sutai/core/model/base_response.dart';
import 'package:sutai/page/auth/provider/model/auth_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

sealed class AuthState {
  const AuthState();
}

class AuthStateInitial extends AuthState {
  const AuthStateInitial();
}

class AuthStateLoading extends AuthState {
  const AuthStateLoading();
}

class AuthStateAuthenticated extends AuthState {
  final UserResponse user;
  const AuthStateAuthenticated(this.user);
}

class AuthStateUnathenticated extends AuthState {
  const AuthStateUnathenticated();
}

class AuthStateError extends AuthState {
  final String message;
  const AuthStateError(this.message);
}

class AuthNotifier extends Notifier<AuthState> {
  late final Dio _dio;
  @override
  AuthState build() {
    _dio = ref.read<Dio>(dioProvider);
    _restoreSession();
    return const AuthStateInitial();
  }

  Future<void> _restoreSession() async {
    final storage = FlutterSecureStorage();
    final savedToken = await storage.read(key: AppConst.tokenKey);
    if (savedToken == null || savedToken.isEmpty) {
      state = const AuthStateUnathenticated();
      return;
    }

    try {
      final response = await _dio.get("/me");
      final user = UserResponse.fromJson(response.data);
      state = AuthStateAuthenticated(user);
    } catch (_) {
      await _clearSession();
      state = const AuthStateUnathenticated();
    }
  }

  Future<void> login(String email, String password) async {
    state = const AuthStateLoading();
    try {
      final body = {"email": email, "password": password};

      final response = await _dio.post("/login", data: body);

      final data = AuthResponse.fromJson(response.data);
      await _saveSession(data);

      state = AuthStateAuthenticated(data.user!);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final message = responseData is Map<String, dynamic>
          ? responseData['message'] as String?
          : null;
      state = AuthStateError(message ?? "Алдаа гарлаа.");
    } catch (e) {
      state = AuthStateError(e.toString());
    }
  }

  Future<void> register({
    required String email,
    required String name,
    required String password,
    required String passwordConfirm,
  }) async {
    state = AuthStateLoading();
    try {
      final body = {
        "email": email,
        "name": name,
        "password": password,
        "password_confirmation": passwordConfirm,
      };

      final response = await _dio.post("/register", data: body);
      final data = AuthResponse.fromJson(response.data);
      await _saveSession(data);
      state = AuthStateAuthenticated(data.user!);
    } on DioException catch (e) {
      final responseData = e.response?.data;
      final message = responseData is Map<String, dynamic>
          ? responseData['message'] as String?
          : null;
      state = AuthStateError(message ?? "Алдаа гарлаа.");
    } catch (_) {
      state = AuthStateError("Алдаа гарлаа.");
    }
  }

  Future<void> logout() async {
    try {
      await _dio.post('/logout');
    } catch (_) {
    } finally {
      await _clearSession();
      state = const AuthStateUnathenticated();
    }
  }

  Future<void> updateProfile({
    required String name,
    required String email,
  }) async {
    await _dio.put(
      '/shop/profile',
      data: {'name': name.trim(), 'email': email.trim()},
    );

    final currentUser = state is AuthStateAuthenticated
        ? (state as AuthStateAuthenticated).user
        : null;
    final user = UserResponse(
      id: currentUser?.id,
      name: name.trim(),
      email: email.trim(),
      isAdmin: currentUser?.isAdmin,
    );
    final storage = FlutterSecureStorage();
    await storage.write(
      key: AppConst.userKey,
      value: jsonEncode(user.toJson()),
    );
    state = AuthStateAuthenticated(user);
  }

  Future<String> updatePassword({
    required String currentPassword,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await _dio.put(
      '/shop/profile/password',
      data: {
        'current_password': currentPassword,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    final data = BaseResponse.fromJson(response.data);

    return data.message ?? "Нууц үг амжилттай солигдлоо.";
  }

  Future<void> _saveSession(AuthResponse auth) async {
    final storage = FlutterSecureStorage();
    await storage.write(key: AppConst.tokenKey, value: auth.token ?? "");
    await storage.write(
      key: AppConst.userKey,
      value: jsonEncode(auth.user?.toJson()),
    );
  }
}

final authProvider = NotifierProvider<AuthNotifier, AuthState>(
  AuthNotifier.new,
);

Future<void> _clearSession() async {
  const storage = FlutterSecureStorage();
  await storage.delete(key: AppConst.tokenKey);
  await storage.delete(key: AppConst.userKey);
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(AppConst.tokenKey);
  await prefs.remove(AppConst.userKey);
  await prefs.remove('user_data');
}
