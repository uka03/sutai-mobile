// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_image_response.dart';

ProductImageResponse _$ProductImageResponseFromJson(
  Map<String, dynamic> json,
) => ProductImageResponse(
  url: json['url'] as String?,
  thumbnail: json['thumbnail'] as String?,
  preview: json['preview'] as String?,
);

Map<String, dynamic> _$ProductImageResponseToJson(
  ProductImageResponse instance,
) => <String, dynamic>{
  'url': instance.url,
  'thumbnail': instance.thumbnail,
  'preview': instance.preview,
};
