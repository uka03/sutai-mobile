import 'package:json_annotation/json_annotation.dart';
import 'package:sutai/page/home/model/product_image_response.dart';

part 'category_response.g.dart';

@JsonSerializable(explicitToJson: true)
class CategoryListResponse {
  final List<CategoryResponse> data;

  const CategoryListResponse({required this.data});

  factory CategoryListResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryListResponseToJson(this);
}

@JsonSerializable(explicitToJson: true)
class CategoryResponse {
  final int id;
  final String name;
  final String? description;
  final ProductImageResponse? image;
  @JsonKey(name: 'products_count')
  final int? productsCount;

  const CategoryResponse({
    required this.id,
    required this.name,
    this.description,
    this.image,
    this.productsCount,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryResponseToJson(this);
}
