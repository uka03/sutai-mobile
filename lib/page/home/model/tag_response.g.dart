// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagResponse _$TagResponseFromJson(Map<String, dynamic> json) => TagResponse(
  data: (json['data'] as List<dynamic>)
      .map((e) => TagResponseData.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TagResponseToJson(TagResponse instance) =>
    <String, dynamic>{'data': instance.data};

TagResponseData _$TagResponseDataFromJson(Map<String, dynamic> json) =>
    TagResponseData(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      productsCount: (json['products_count'] as num).toInt(),
    );

Map<String, dynamic> _$TagResponseDataToJson(TagResponseData instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'products_count': instance.productsCount,
    };
