// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_list_response.dart';

ProductListResponse _$ProductListResponseFromJson(Map<String, dynamic> json) =>
    ProductListResponse(
      data:
          (json['data'] as List<dynamic>?)
              ?.map((e) => ProductResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      meta: json['meta'] == null
          ? null
          : ProductPaginationMeta.fromJson(
              json['meta'] as Map<String, dynamic>,
            ),
    );

Map<String, dynamic> _$ProductListResponseToJson(
  ProductListResponse instance,
) => <String, dynamic>{
  'data': instance.data.map((e) => e.toJson()).toList(),
  'meta': instance.meta?.toJson(),
};

ProductPaginationMeta _$ProductPaginationMetaFromJson(
  Map<String, dynamic> json,
) => ProductPaginationMeta(
  currentPage: (json['current_page'] as num?)?.toInt(),
  lastPage: (json['last_page'] as num?)?.toInt(),
  total: (json['total'] as num?)?.toInt(),
);

Map<String, dynamic> _$ProductPaginationMetaToJson(
  ProductPaginationMeta instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'last_page': instance.lastPage,
  'total': instance.total,
};
