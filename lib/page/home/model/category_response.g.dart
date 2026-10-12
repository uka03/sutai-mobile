// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_response.dart';

CategoryListResponse _$CategoryListResponseFromJson(
  Map<String, dynamic> json,
) => CategoryListResponse(
  data:
      (json['data'] as List<dynamic>?)
          ?.map((e) => CategoryResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$CategoryListResponseToJson(
  CategoryListResponse instance,
) => <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};

CategoryResponse _$CategoryResponseFromJson(Map<String, dynamic> json) =>
    CategoryResponse(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      image: json['image'] == null
          ? null
          : ProductImageResponse.fromJson(
            json['image'] as Map<String, dynamic>,
            ),
      productsCount: (json['products_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$CategoryResponseToJson(CategoryResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'image': instance.image?.toJson(),
      'products_count': instance.productsCount,
    };
