import 'package:json_annotation/json_annotation.dart';
import 'package:sutai/page/home/model/product_response.dart';
import 'package:sutai/page/home/model/tag_response.dart';

part 'tag_products_response.g.dart';

/// A tag and the products associated with it.
///
/// The API tag list can be mapped to this shape after products are loaded,
/// since the tag JSON itself only contains `products_count`, not product data.
@JsonSerializable(explicitToJson: true)
class TagProductsResponse {
  @JsonKey(name: 'tagName')
  final String tagName;
  final int tagId;
  final int tagCount;
  final List<ProductResponse> products;

  const TagProductsResponse({
    required this.tagName,
    required this.tagId,
    required this.tagCount,
    required this.products,
  });

  factory TagProductsResponse.fromJson(Map<String, dynamic> json) =>
      _$TagProductsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TagProductsResponseToJson(this);

  factory TagProductsResponse.fromTag({
    required TagResponseData tag,
    required List<ProductResponse> products,
  }) => TagProductsResponse(
    tagName: tag.name,
    tagId: tag.id,
    tagCount: tag.productsCount,
    products: products,
  );
}
