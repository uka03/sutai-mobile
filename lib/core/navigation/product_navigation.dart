import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/page/home/model/product_response.dart';

void openProduct(BuildContext context, ProductResponse product) {
  context.push('/product/${product.id}');
}
