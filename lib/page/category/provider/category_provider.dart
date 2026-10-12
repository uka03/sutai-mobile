import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/connection/dio_client.dart';
import 'package:sutai/page/home/model/category_response.dart';

final categoryProvider = FutureProvider<List<CategoryResponse>>((ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRepository(dio).fetchCategories();
});

class CategoryRepository {
  const CategoryRepository(this._dio);

  final Dio _dio;

  Future<List<CategoryResponse>> fetchCategories() async {
    final response = await _dio.get<Map<String, dynamic>>('/shop/categories');
    return CategoryListResponse.fromJson(
      response.data ?? const <String, dynamic>{},
    ).data;
  }
}
