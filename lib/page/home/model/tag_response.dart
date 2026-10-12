import 'package:json_annotation/json_annotation.dart';

part 'tag_response.g.dart';

@JsonSerializable()
class TagResponse {
  final List<TagResponseData> data;

  const TagResponse({required this.data});

  factory TagResponse.fromJson(Map<String, dynamic> json) =>
      _$TagResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TagResponseToJson(this);
}

@JsonSerializable()
class TagResponseData {
  final int id;
  final String name;
  @JsonKey(name: 'products_count')
  final int productsCount;

  const TagResponseData({
    required this.id,
    required this.name,
    required this.productsCount,
  });

  factory TagResponseData.fromJson(Map<String, dynamic> json) =>
      _$TagResponseDataFromJson(json);

  Map<String, dynamic> toJson() => _$TagResponseDataToJson(this);
}
