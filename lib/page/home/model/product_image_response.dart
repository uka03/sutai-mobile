import 'package:json_annotation/json_annotation.dart';

part 'product_image_response.g.dart';

@JsonSerializable()
class ProductImageResponse {
  final String? url;
  final String? thumbnail;
  final String? preview;

  const ProductImageResponse({this.url, this.thumbnail, this.preview});

  factory ProductImageResponse.fromJson(Map<String, dynamic> json) =>
      _$ProductImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ProductImageResponseToJson(this);
}
