// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyOrdersResponse _$MyOrdersResponseFromJson(Map<String, dynamic> json) =>
    MyOrdersResponse(
      data: (json['data'] as List<dynamic>?)
              ?.map((e) => OrderResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      links: json['links'] == null
          ? null
          : OrderLinksResponse.fromJson(json['links'] as Map<String, dynamic>),
      meta: json['meta'] == null
          ? null
          : OrderMetaResponse.fromJson(json['meta'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MyOrdersResponseToJson(MyOrdersResponse instance) =>
    <String, dynamic>{
      'data': instance.data.map((e) => e.toJson()).toList(),
      'links': instance.links?.toJson(),
      'meta': instance.meta?.toJson(),
    };

OrderResponse _$OrderResponseFromJson(Map<String, dynamic> json) =>
    OrderResponse(
      id: (json['id'] as num).toInt(),
      number: json['number'] as String,
      status: $enumDecode(_$OrderStatusEnumMap, json['status']),
      statusLabel: $enumDecode(
        _$OrderStatusLabelEnumMap,
        json['status_label'],
      ),
      total: (json['total'] as num).toInt(),
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
      shippingAddress: json['shipping_address'] as String,
      itemsCount: (json['items_count'] as num).toInt(),
      note: json['note'] as String?,
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$OrderResponseToJson(OrderResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'number': instance.number,
      'status': _$OrderStatusEnumMap[instance.status]!,
      'status_label': _$OrderStatusLabelEnumMap[instance.statusLabel]!,
      'total': instance.total,
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'shipping_address': instance.shippingAddress,
      'note': instance.note,
      'items_count': instance.itemsCount,
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

OrderLinksResponse _$OrderLinksResponseFromJson(Map<String, dynamic> json) =>
    OrderLinksResponse(
      first: json['first'] as String?,
      last: json['last'] as String?,
      prev: json['prev'] as String?,
      next: json['next'] as String?,
    );

Map<String, dynamic> _$OrderLinksResponseToJson(OrderLinksResponse instance) =>
    <String, dynamic>{
      'first': instance.first,
      'last': instance.last,
      'prev': instance.prev,
      'next': instance.next,
    };

OrderMetaResponse _$OrderMetaResponseFromJson(Map<String, dynamic> json) =>
    OrderMetaResponse(
      currentPage: (json['current_page'] as num?)?.toInt(),
      lastPage: (json['last_page'] as num?)?.toInt(),
      perPage: (json['per_page'] as num?)?.toInt(),
      total: (json['total'] as num?)?.toInt(),
    );

Map<String, dynamic> _$OrderMetaResponseToJson(OrderMetaResponse instance) =>
    <String, dynamic>{
      'current_page': instance.currentPage,
      'last_page': instance.lastPage,
      'per_page': instance.perPage,
      'total': instance.total,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.paid: 'paid',
  OrderStatus.shipped: 'shipped',
  OrderStatus.completed: 'completed',
  OrderStatus.cancelled: 'cancelled',
};

const _$OrderStatusLabelEnumMap = {
  OrderStatusLabel.pending: 'Хүлээгдэж буй',
  OrderStatusLabel.paid: 'Төлөгдсөн',
  OrderStatusLabel.shipped: 'Хүргэлтэнд гарсан',
  OrderStatusLabel.completed: 'Дууссан',
  OrderStatusLabel.cancelled: 'Цуцлагдсан',
};
