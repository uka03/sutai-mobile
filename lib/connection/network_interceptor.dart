import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkStatusProvider = StateProvider<bool>((ref) => true);

class NetworkInterceptor extends Interceptor {
  NetworkInterceptor(this._onConnectivityChanged);

  final void Function(bool isOnline) _onConnectivityChanged;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    _onConnectivityChanged(true);
    const storage = FlutterSecureStorage();
    try {
      final accessToken = await storage.read(key: 'token');
      if (accessToken != null) {
        options.headers['Authorization'] = "Bearer $accessToken";
      }
    } on PlatformException catch (_) {
      await storage.deleteAll();
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    debugPrint(
      'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}',
    );
    return super.onResponse(response, handler);
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      _onConnectivityChanged(false);
    }
    debugPrint(
      'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}',
    );
    debugPrint("error message:  ${err.response?.data}");
    if (err.requestOptions.path.contains("cart")) {
      if (err.response?.statusCode == 403) {
        const storage = FlutterSecureStorage();
        storage.deleteAll();
        return handler.reject(err);
      }
    }

    if (err.response?.statusCode == 401) {
      const storage = FlutterSecureStorage();
      storage.deleteAll();
      return handler.reject(err);
    }
    return handler.next(err);
  }
}
