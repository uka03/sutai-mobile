import 'package:json_annotation/json_annotation.dart';
import 'package:sutai/page/home/model/category_response.dart';
import 'package:sutai/page/home/model/product_image_response.dart';

part 'product_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductResponse {
  final int id;
  final String name;
  final String? description;
  final int price;
  final ProductImageResponse? image;
  final List<CategoryResponse> categories;
  final List<ProductTagResponse> tags;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const ProductResponse({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.image,
    this.categories = const [],
    this.tags = const [],
    this.createdAt,
  });

  factory ProductResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductResponseToJson(this);
}

@JsonSerializable()
class ProductTagResponse {
  final int id;
  final String name;

  const ProductTagResponse({required this.id, required this.name});

  factory ProductTagResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductTagResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductTagResponseToJson(this);
}
