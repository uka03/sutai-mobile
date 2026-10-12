// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_products_response.dart';

// ***************************************************************************
// JsonSerializableGenerator
// ***************************************************************************

TagProductsResponse _$TagProductsResponseFromJson(Map<String, dynamic> json) =>
    TagProductsResponse(
      tagName: json['tagName'] as String,
      tagId: (json['tagId'] as num).toInt(),
      tagCount: (json['tagCount'] as num).toInt(),
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TagProductsResponseToJson(
  TagProductsResponse instance,
) => <String, dynamic>{
  'tagName': instance.tagName,
  'tagId': instance.tagId,
  'tagCount': instance.tagCount,
  'products': instance.products.map((e) => e.toJson()).toList(),
};
