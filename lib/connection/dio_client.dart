import 'package:dio/dio.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sutai/connection/network_interceptor.dart';
import 'package:sutai/core/constants.dart';

final dioProvider = Provider<Dio>((ref) {
  final networkStatus = ref.read(networkStatusProvider.notifier);
  final dioClient = Dio(BaseOptions(baseUrl: AppConst.baseUrl))
    ..interceptors.add(
      NetworkInterceptor((isOnline) => networkStatus.state = isOnline),
    );
  return dioClient;
});
