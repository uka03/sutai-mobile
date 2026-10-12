import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/connection/dio_client.dart';
import 'package:sutai/page/product/model/product_detail_response.dart';

final productDetailProvider =
    FutureProvider.family<ProductDetailResponse, int>((ref, productId) async {
      final dio = ref.watch(dioProvider);
      final response = await dio.get<Map<String, dynamic>>(
        '/shop/products/$productId',
      );
      return ProductDetailResponse.fromJson(response.data ?? const {});
    });
