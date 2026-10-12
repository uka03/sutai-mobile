import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:sutai/connection/dio_client.dart';
import 'package:sutai/page/category/provider/category_provider.dart';
import 'package:sutai/page/home/model/category_response.dart';
import 'package:sutai/page/home/model/product_list_response.dart';
import 'package:sutai/page/home/model/product_response.dart';
import 'package:sutai/page/home/model/tag_response.dart';
import 'package:sutai/page/home/provider/tag_products_provider.dart';

final productSearchProvider =
    NotifierProvider<ProductSearchNotifier, ProductSearchState>(
      ProductSearchNotifier.new,
    );

class ProductSearchState {
  const ProductSearchState({
    required this.pagingState,
    this.categories = const [],
    this.tags = const [],
    this.search = '',
    this.categoryId,
    this.tagId,
    this.minPrice = '',
    this.maxPrice = '',
    this.sort = 'newest',
    this.totalCount,
    this.optionsLoading = false,
  });

  final PagingState<int, ProductResponse> pagingState;
  final List<CategoryResponse> categories;
  final List<TagResponseData> tags;
  final String search;
  final int? categoryId;
  final int? tagId;
  final String minPrice;
  final String maxPrice;
  final String sort;
  final int? totalCount;
  final bool optionsLoading;

  bool get hasActiveFilters =>
      categoryId != null ||
      tagId != null ||
      minPrice.isNotEmpty ||
      maxPrice.isNotEmpty;

  ProductSearchState copyWith({
    PagingState<int, ProductResponse>? pagingState,
    List<CategoryResponse>? categories,
    List<TagResponseData>? tags,
    String? search,
    Object? categoryId = _unset,
    Object? tagId = _unset,
    String? minPrice,
    String? maxPrice,
    String? sort,
    Object? totalCount = _unset,
    bool? optionsLoading,
  }) => ProductSearchState(
    pagingState: pagingState ?? this.pagingState,
    categories: categories ?? this.categories,
    tags: tags ?? this.tags,
    search: search ?? this.search,
    categoryId: identical(categoryId, _unset)
        ? this.categoryId
        : categoryId as int?,
    tagId: identical(tagId, _unset) ? this.tagId : tagId as int?,
    minPrice: minPrice ?? this.minPrice,
    maxPrice: maxPrice ?? this.maxPrice,
    sort: sort ?? this.sort,
    totalCount: identical(totalCount, _unset)
        ? this.totalCount
        : totalCount as int?,
    optionsLoading: optionsLoading ?? this.optionsLoading,
  );
}

const _unset = Object();

class ProductSearchNotifier extends Notifier<ProductSearchState> {
  late final Dio _dio;
  Timer? _debounce;
  int _requestVersion = 0;

  @override
  ProductSearchState build() {
    _dio = ref.read(dioProvider);
    ref.onDispose(() => _debounce?.cancel());
    return ProductSearchState(
      pagingState: PagingState<int, ProductResponse>(
        hasNextPage: true,
        isLoading: false,
      ),
    );
  }

  void initialize({int? initialTagId, int? initialCategoryId}) {
    _requestVersion++;
    state = ProductSearchState(
      pagingState: PagingState<int, ProductResponse>(
        hasNextPage: true,
        isLoading: false,
      ),
      tagId: initialTagId,
      categoryId: initialCategoryId,
      optionsLoading: true,
    );
    _loadOptions();
  }

  Future<void> _loadOptions() async {
    try {
      final categoriesFuture = ref.read(categoryProvider.future);
      final tagsFuture = ref.read(tagListProvider.future);
      final categories = await categoriesFuture;
      final tags = await tagsFuture;
      state = state.copyWith(
        categories: categories,
        tags: tags,
        optionsLoading: false,
      );
    } catch (_) {
      state = state.copyWith(optionsLoading: false);
    }
  }

  void updateSearch(String value) {
    state = state.copyWith(search: value);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), refresh);
  }

  void updateFilters({
    required int? categoryId,
    required int? tagId,
    required String minPrice,
    required String maxPrice,
  }) {
    state = state.copyWith(
      categoryId: categoryId,
      tagId: tagId,
      minPrice: minPrice,
      maxPrice: maxPrice,
    );
    refresh();
  }

  void clearCategory() {
    state = state.copyWith(categoryId: null);
    refresh();
  }

  void clearTag() {
    state = state.copyWith(tagId: null);
    refresh();
  }

  void clearMinPrice() {
    state = state.copyWith(minPrice: '');
    refresh();
  }

  void clearMaxPrice() {
    state = state.copyWith(maxPrice: '');
    refresh();
  }

  void updateSort(String sort) {
    state = state.copyWith(sort: sort);
    refresh();
  }

  void clearSearch() {
    _debounce?.cancel();
    state = state.copyWith(search: '');
    refresh();
  }

  void refresh() {
    _requestVersion++;
    state = state.copyWith(
      pagingState: PagingState<int, ProductResponse>(
        hasNextPage: true,
        isLoading: false,
      ),
      totalCount: null,
    );
  }

  Future<void> fetchNextPage() async {
    final currentPagingState = state.pagingState;
    if (currentPagingState.isLoading || !currentPagingState.hasNextPage) return;

    final requestVersion = _requestVersion;
    final pageKey = currentPagingState.keys?.last ?? 0;
    final nextPage = pageKey + 1;
    state = state.copyWith(
      pagingState: PagingState<int, ProductResponse>(
        pages: currentPagingState.pages,
        keys: currentPagingState.keys,
        hasNextPage: currentPagingState.hasNextPage,
        isLoading: true,
      ),
    );

    final params = <String, dynamic>{
      'page': nextPage,
      'per_page': 12,
      'sort': state.sort,
    };
    if (state.search.trim().isNotEmpty) params['search'] = state.search.trim();
    if (state.categoryId != null) params['category_id'] = state.categoryId;
    if (state.tagId != null) params['tag_id'] = state.tagId;
    final minPrice = int.tryParse(state.minPrice.trim());
    final maxPrice = int.tryParse(state.maxPrice.trim());
    if (minPrice != null) params['min_price'] = minPrice;
    if (maxPrice != null) params['max_price'] = maxPrice;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '/shop/products',
        queryParameters: params,
      );
      if (requestVersion != _requestVersion) return;

      final result = ProductListResponse.fromJson(
        response.data ?? const <String, dynamic>{},
      );
      final currentPage = result.meta?.currentPage ?? nextPage;
      final lastPage = result.meta?.lastPage ?? currentPage;
      final loadedProducts = [...?currentPagingState.items, ...result.data];
      state = state.copyWith(
        pagingState: PagingState<int, ProductResponse>(
          pages: [...?currentPagingState.pages, result.data],
          keys: [...?currentPagingState.keys, currentPage],
          hasNextPage: result.data.isNotEmpty && currentPage < lastPage,
          isLoading: false,
        ),
        totalCount: result.meta?.total ?? loadedProducts.length,
      );
    } catch (error) {
      if (requestVersion == _requestVersion) {
        state = state.copyWith(
          pagingState: PagingState<int, ProductResponse>(
            pages: currentPagingState.pages,
            keys: currentPagingState.keys,
            hasNextPage: currentPagingState.hasNextPage,
            isLoading: false,
            error: error,
          ),
        );
      }
    }
  }
}
