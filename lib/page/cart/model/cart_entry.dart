import 'package:sutai/page/home/model/product_response.dart';

class CartEntry {
  const CartEntry({required this.product, required this.quantity});

  final ProductResponse product;
  final int quantity;

  int get subtotal => product.price * quantity;

  CartEntry copyWith({int? quantity}) => CartEntry(
    product: product,
    quantity: quantity ?? this.quantity,
  );
}
