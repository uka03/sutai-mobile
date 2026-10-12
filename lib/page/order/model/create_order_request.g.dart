// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_order_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateOrderRequest _$CreateOrderRequestFromJson(Map<String, dynamic> json) =>
    CreateOrderRequest(
      customerName: json['customer_name'] as String,
      customerPhone: json['customer_phone'] as String,
      shippingAddress: json['shipping_address'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => CreateOrderItemRequest.fromJson(e as Map<String, dynamic>))
          .toList(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$CreateOrderRequestToJson(CreateOrderRequest instance) =>
    <String, dynamic>{
      'customer_name': instance.customerName,
      'customer_phone': instance.customerPhone,
      'shipping_address': instance.shippingAddress,
      'note': instance.note,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

CreateOrderItemRequest _$CreateOrderItemRequestFromJson(
  Map<String, dynamic> json,
) => CreateOrderItemRequest(
  productId: (json['product_id'] as num).toInt(),
  quantity: (json['quantity'] as num).toInt(),
);

Map<String, dynamic> _$CreateOrderItemRequestToJson(
  CreateOrderItemRequest instance,
) => <String, dynamic>{
  'product_id': instance.productId,
  'quantity': instance.quantity,
};
