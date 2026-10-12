import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sutai/page/home/model/product_response.dart';

final wishlistProvider = AsyncNotifierProvider<WishlistNotifier, List<ProductResponse>>(
  WishlistNotifier.new,
);

class WishlistNotifier extends AsyncNotifier<List<ProductResponse>> {
  static const _storageKey = 'wishlist_products_v1';

  @override
  Future<List<ProductResponse>> build() async {
    final preferences = await SharedPreferences.getInstance();
    final encodedProducts = preferences.getStringList(_storageKey) ?? const [];
    return encodedProducts
        .map(
          (encodedProduct) => ProductResponse.fromJson(
            jsonDecode(encodedProduct) as Map<String, dynamic>,
          ),
        )
        .toList();
  }

  bool contains(int productId) =>
      state.valueOrNull?.any((product) => product.id == productId) ?? false;

  Future<bool> toggle(ProductResponse product) async {
    final products = state.valueOrNull ?? await future;
    final alreadySaved = products.any((saved) => saved.id == product.id);
    final updatedProducts = alreadySaved
        ? products.where((saved) => saved.id != product.id).toList()
        : [...products, product];
    await _save(updatedProducts);
    return !alreadySaved;
  }

  Future<void> remove(int productId) async {
    final products = state.valueOrNull ?? await future;
    await _save(
      products.where((product) => product.id != productId).toList(),
    );
  }

  Future<void> _save(List<ProductResponse> products) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setStringList(
      _storageKey,
      products.map((product) => jsonEncode(product.toJson())).toList(),
    );
    state = AsyncData(products);
  }
}
