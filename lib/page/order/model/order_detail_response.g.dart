// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDetailResponse _$OrderDetailResponseFromJson(Map<String, dynamic> json) =>
    OrderDetailResponse(
      data: OrderDetailData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$OrderDetailResponseToJson(
  OrderDetailResponse instance,
) => <String, dynamic>{'data': instance.data.toJson()};

OrderDetailData _$OrderDetailDataFromJson(Map<String, dynamic> json) =>
    OrderDetailData(
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
      note: json['note'] as String?,
      items: (json['items'] as List<dynamic>?)
              ?.map((e) => OrderItemResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      cancelledAt: json['cancelled_at'] == null
          ? null
          : DateTime.parse(json['cancelled_at'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$OrderDetailDataToJson(OrderDetailData instance) =>
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
      'items': instance.items.map((e) => e.toJson()).toList(),
      'cancelled_at': instance.cancelledAt?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
    };

OrderItemResponse _$OrderItemResponseFromJson(Map<String, dynamic> json) =>
    OrderItemResponse(
      id: (json['id'] as num).toInt(),
      productId: (json['product_id'] as num).toInt(),
      productName: json['product_name'] as String,
      image: json['image'] == null
          ? null
          : ProductImageResponse.fromJson(json['image'] as Map<String, dynamic>),
      unitPrice: (json['unit_price'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      lineTotal: (json['line_total'] as num).toInt(),
    );

Map<String, dynamic> _$OrderItemResponseToJson(OrderItemResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'image': instance.image?.toJson(),
      'unit_price': instance.unitPrice,
      'quantity': instance.quantity,
      'line_total': instance.lineTotal,
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
