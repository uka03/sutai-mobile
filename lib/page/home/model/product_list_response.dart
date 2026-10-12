import 'package:json_annotation/json_annotation.dart';
import 'package:sutai/page/home/model/product_response.dart';

part 'product_list_response.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductListResponse {
  final List<ProductResponse> data;
  final ProductPaginationMeta? meta;

  const ProductListResponse({required this.data, this.meta});

  factory ProductListResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductListResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListResponseToJson(this);
}

@JsonSerializable()
class ProductPaginationMeta {
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @JsonKey(name: 'last_page')
  final int? lastPage;
  final int? total;

  const ProductPaginationMeta({this.currentPage, this.lastPage, this.total});

  factory ProductPaginationMeta.fromJson(Map<String, dynamic> json) =>
      _$ProductPaginationMetaFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPaginationMetaToJson(this);
}
