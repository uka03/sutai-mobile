import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/connection/dio_client.dart';
import 'package:sutai/page/home/model/product_list_response.dart';
import 'package:sutai/page/home/model/tag_products_response.dart';
import 'package:sutai/page/home/model/tag_response.dart';

final tagListProvider = FutureProvider<List<TagResponseData>>((ref) async {
  final dio = ref.watch(dioProvider);
  final response = await dio.get<Map<String, dynamic>>('/shop/tags');
  return TagResponse.fromJson(response.data ?? const <String, dynamic>{}).data;
});

final tagProductsProvider = FutureProvider<List<TagProductsResponse>>((ref) async {
  final dio = ref.watch(dioProvider);
  final tags = await ref.watch(tagListProvider.future);
  return TagProductsRepository(dio).fetchProductsGroupedByTag(tags);
});

class TagProductsRepository {
  const TagProductsRepository(this._dio);

  final Dio _dio;

  Future<List<TagProductsResponse>> fetchProductsGroupedByTag(
    List<TagResponseData> tags,
  ) async {
    final groups = await Future.wait(
      tags.map((tag) async {
        final productsResponse = await _dio.get<Map<String, dynamic>>(
          '/shop/products',
          queryParameters: {'tag_id': tag.id},
        );
        final products = ProductListResponse.fromJson(
          productsResponse.data ?? const <String, dynamic>{},
        ).data;

        return TagProductsResponse.fromTag(tag: tag, products: products);
      }),
    );
    groups.sort((first, second) => first.tagId.compareTo(second.tagId));
    return groups;
  }
}
