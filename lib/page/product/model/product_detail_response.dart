import 'package:json_annotation/json_annotation.dart';
import 'package:sutai/page/home/model/product_response.dart';

part 'product_detail_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductDetailResponse {
  final ProductResponse data;
  final List<ProductResponse> related;

  const ProductDetailResponse({
    required this.data,
    this.related = const [],
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDetailResponseToJson(this);
}
