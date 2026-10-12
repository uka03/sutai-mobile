// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetailResponse _$ProductDetailResponseFromJson(
  Map<String, dynamic> json,
) => ProductDetailResponse(
  data: ProductResponse.fromJson(json['data'] as Map<String, dynamic>),
  related: (json['related'] as List<dynamic>?)
          ?.map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$ProductDetailResponseToJson(
  ProductDetailResponse instance,
) => <String, dynamic>{
  'data': instance.data.toJson(),
  'related': instance.related.map((e) => e.toJson()).toList(),
};
