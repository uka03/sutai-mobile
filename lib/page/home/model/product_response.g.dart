// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

ProductResponse _$ProductResponseFromJson(
  Map<String, dynamic> json,
) => ProductResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  description: json['description'] as String?,
  price: (json['price'] as num).toInt(),
  image: json['image'] == null
      ? null
      : ProductImageResponse.fromJson(json['image'] as Map<String, dynamic>),
  categories:
      (json['categories'] as List<dynamic>?)
          ?.map((e) => CategoryResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  tags:
      (json['tags'] as List<dynamic>?)
          ?.map((e) => ProductTagResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ProductResponseToJson(ProductResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'image': instance.image?.toJson(),
      'categories': instance.categories.map((e) => e.toJson()).toList(),
      'tags': instance.tags.map((e) => e.toJson()).toList(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

ProductTagResponse _$ProductTagResponseFromJson(Map<String, dynamic> json) =>
    ProductTagResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
    );

Map<String, dynamic> _$ProductTagResponseToJson(ProductTagResponse instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};
