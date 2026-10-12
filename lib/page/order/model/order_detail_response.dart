import 'package:json_annotation/json_annotation.dart';
import 'package:sutai/page/home/model/product_image_response.dart';
import 'package:sutai/page/order/model/order_response.dart';

part 'order_detail_response.g.dart';

@JsonSerializable()
class OrderDetailResponse {
  final OrderDetailData data;

  const OrderDetailResponse({required this.data});

  factory OrderDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailResponseToJson(this);
}

@JsonSerializable()
class OrderDetailData {
  final int id;
  final String number;
  final OrderStatus status;
  @JsonKey(name: 'status_label')
  final OrderStatusLabel statusLabel;
  final int total;
  @JsonKey(name: 'customer_name')
  final String customerName;
  @JsonKey(name: 'customer_phone')
  final String customerPhone;
  @JsonKey(name: 'shipping_address')
  final String shippingAddress;
  final String? note;
  final List<OrderItemResponse> items;
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const OrderDetailData({
    required this.id,
    required this.number,
    required this.status,
    required this.statusLabel,
    required this.total,
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    this.note,
    this.items = const [],
    this.cancelledAt,
    this.createdAt,
  });

  factory OrderDetailData.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailDataFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDetailDataToJson(this);
}

@JsonSerializable()
class OrderItemResponse {
  final int id;
  @JsonKey(name: 'product_id')
  final int productId;
  @JsonKey(name: 'product_name')
  final String productName;
  final ProductImageResponse? image;
  @JsonKey(name: 'unit_price')
  final int unitPrice;
  final int quantity;
  @JsonKey(name: 'line_total')
  final int lineTotal;

  const OrderItemResponse({
    required this.id,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    required this.lineTotal,
    this.image,
  });

  factory OrderItemResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderItemResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemResponseToJson(this);
}
