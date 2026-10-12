import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/connection/dio_client.dart';
import 'package:sutai/page/order/model/order_cancel_response.dart';
import 'package:sutai/page/order/model/order_action_exception.dart';
import 'package:sutai/page/order/model/order_response.dart';
import 'package:sutai/page/order/model/order_detail_response.dart';
import 'package:sutai/page/order/model/create_order_request.dart';
import 'package:sutai/page/order/model/create_order_response.dart';

final myOrdersProvider = FutureProvider<MyOrdersResponse>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>('/shop/orders');
  return MyOrdersResponse.fromJson(response.data ?? const {});
});

final orderDetailProvider = FutureProvider.family<OrderDetailData, int>((
  ref,
  orderId,
) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>(
    '/shop/orders/$orderId',
  );
  return OrderDetailResponse.fromJson(response.data ?? const {}).data;
});

final orderActionsProvider = Provider<OrderActions>((ref) {
  return OrderActions(ref: ref, dio: ref.watch(dioProvider));
});

class OrderActions {
  const OrderActions({required this.ref, required this.dio});

  final Ref ref;
  final Dio dio;

  Future<void> cancelOrder(int orderId) async {
    try {
      await dio.post<Map<String, dynamic>>('/shop/orders/$orderId/cancel');
      ref.invalidate(orderDetailProvider(orderId));
      ref.invalidate(myOrdersProvider);
    } on DioException catch (error) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final response = OrderCancelResponse.fromJson(responseData);
        throw OrderActionException(
          response.message ?? 'Захиалгыг цуцлахад алдаа гарлаа.',
        );
      }
      throw const OrderActionException('Захиалгыг цуцлахад алдаа гарлаа.');
    }
  }

  Future<void> createOrder(CreateOrderRequest request) async {
    try {
      await dio.post<Map<String, dynamic>>(
        '/shop/orders',
        data: request.toJson(),
      );
      ref.invalidate(myOrdersProvider);
    } on DioException catch (error) {
      final responseData = error.response?.data;
      if (responseData is Map<String, dynamic>) {
        final response = CreateOrderResponse.fromJson(responseData);
        throw OrderActionException(
          response.message ?? 'Захиалга үүсгэхэд алдаа гарлаа.',
        );
      }
      throw const OrderActionException('Захиалга үүсгэхэд алдаа гарлаа.');
    }
  }
}
