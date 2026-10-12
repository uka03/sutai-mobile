import 'package:json_annotation/json_annotation.dart';

part 'order_response.g.dart';

enum OrderStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('paid')
  paid,
  @JsonValue('shipped')
  shipped,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
}

enum OrderStatusLabel {
  @JsonValue('Хүлээгдэж буй')
  pending,
  @JsonValue('Төлөгдсөн')
  paid,
  @JsonValue('Хүргэлтэнд гарсан')
  shipped,
  @JsonValue('Дууссан')
  completed,
  @JsonValue('Цуцлагдсан')
  cancelled,
}

extension OrderStatusLabelText on OrderStatusLabel {
  String get text => switch (this) {
    OrderStatusLabel.pending => 'Хүлээгдэж буй',
    OrderStatusLabel.paid => 'Төлөгдсөн',
    OrderStatusLabel.shipped => 'Хүргэлтэнд гарсан',
    OrderStatusLabel.completed => 'Дууссан',
    OrderStatusLabel.cancelled => 'Цуцлагдсан',
  };
}

@JsonSerializable()
class MyOrdersResponse {
  final List<OrderResponse> data;
  final OrderLinksResponse? links;
  final OrderMetaResponse? meta;

  const MyOrdersResponse({
    this.data = const [],
    this.links,
    this.meta,
  });

  factory MyOrdersResponse.fromJson(Map<String, dynamic> json) =>
      _$MyOrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyOrdersResponseToJson(this);
}

@JsonSerializable()
class OrderResponse {
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
  @JsonKey(name: 'items_count')
  final int itemsCount;
  @JsonKey(name: 'cancelled_at')
  final DateTime? cancelledAt;
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  const OrderResponse({
    required this.id,
    required this.number,
    required this.status,
    required this.statusLabel,
    required this.total,
    required this.customerName,
    required this.customerPhone,
    required this.shippingAddress,
    required this.itemsCount,
    this.note,
    this.cancelledAt,
    this.createdAt,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderResponseToJson(this);
}

@JsonSerializable()
class OrderLinksResponse {
  final String? first;
  final String? last;
  final String? prev;
  final String? next;

  const OrderLinksResponse({this.first, this.last, this.prev, this.next});

  factory OrderLinksResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderLinksResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderLinksResponseToJson(this);
}

@JsonSerializable()
class OrderMetaResponse {
  @JsonKey(name: 'current_page')
  final int? currentPage;
  @JsonKey(name: 'last_page')
  final int? lastPage;
  @JsonKey(name: 'per_page')
  final int? perPage;
  final int? total;

  const OrderMetaResponse({
    this.currentPage,
    this.lastPage,
    this.perPage,
    this.total,
  });

  factory OrderMetaResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderMetaResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderMetaResponseToJson(this);
}
