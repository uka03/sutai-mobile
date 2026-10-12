import 'package:json_annotation/json_annotation.dart';

part 'order_cancel_response.g.dart';

@JsonSerializable()
class OrderCancelResponse {
  final String? message;

  const OrderCancelResponse({this.message});

  factory OrderCancelResponse.fromJson(Map<String, dynamic> json) =>
      _$OrderCancelResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrderCancelResponseToJson(this);
}
