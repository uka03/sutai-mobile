import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sutai/page/cart/model/cart_entry.dart';
import 'package:sutai/page/home/model/product_response.dart';

final cartProvider = NotifierProvider<CartNotifier, CartState>(CartNotifier.new);

class CartState {
  const CartState({this.items = const []});

  final List<CartEntry> items;

  int get itemCount => items.fold(0, (count, entry) => count + entry.quantity);
  int get total => items.fold(0, (sum, entry) => sum + entry.subtotal);
  bool get isEmpty => items.isEmpty;

  CartState copyWith({List<CartEntry>? items}) => CartState(
    items: items ?? this.items,
  );
}

class CartNotifier extends Notifier<CartState> {
  @override
  CartState build() => const CartState();

  void addProduct(ProductResponse product, {int quantity = 1}) {
    if (quantity < 1) return;

    final index = state.items.indexWhere(
      (entry) => entry.product.id == product.id,
    );
    if (index == -1) {
      state = state.copyWith(
        items: [...state.items, CartEntry(product: product, quantity: quantity)],
      );
      return;
    }

    final items = [...state.items];
    items[index] = items[index].copyWith(
      quantity: items[index].quantity + quantity,
    );
    state = state.copyWith(items: items);
  }

  void increase(int productId) => _changeQuantity(productId, 1);

  void decrease(int productId) => _changeQuantity(productId, -1);

  void removeProduct(int productId) {
    state = state.copyWith(
      items: state.items
          .where((entry) => entry.product.id != productId)
          .toList(),
    );
  }

  void clear() => state = const CartState();

  void _changeQuantity(int productId, int change) {
    final index = state.items.indexWhere(
      (entry) => entry.product.id == productId,
    );
    if (index == -1) return;

    final nextQuantity = state.items[index].quantity + change;
    if (nextQuantity < 1) return;

    final items = [...state.items];
    items[index] = items[index].copyWith(quantity: nextQuantity);
    state = state.copyWith(items: items);
  }
}
