import 'package:json_annotation/json_annotation.dart';

part 'create_order_request.g.dart';

@JsonSerializable()
class CreateOrderRequest {
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'customer_phone')
  final String customerPhone;
  @JsonKey(name: 'shipping_address')
  final String shippingAddress;
  final String? note;
  final List<CreateOrderItemRequest> items;

  const CreateOrderRequest({
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.items,
    this.note,
  });

  factory CreateOrderRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderRequestToJson(this);
}

@JsonSerializable()
class CreateOrderItemRequest {
  @JsonKey(name: 'product_id')
  final int productId;
  final int quantity;

  const CreateOrderItemRequest({required this.productId, required this.quantity});

  factory CreateOrderItemRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateOrderItemRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderItemRequestToJson(this);
}
