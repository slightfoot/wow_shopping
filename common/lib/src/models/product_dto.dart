import 'package:json_annotation/json_annotation.dart';

part 'product_dto.g.dart';

@JsonSerializable()
class ProductDto {
  const ProductDto({
    required this.id,
    required this.category,
    required this.title,
    required this.subTitle,
    required this.price,
    required this.priceWithTax,
    required this.photos,
    required this.description,
    this.options = const [],
  });

  final String id;
  final String category;
  final String title;
  final String subTitle;
  final String price;
  final String priceWithTax;
  final List<String> photos;
  final String description;
  final List<ProductOptionDto> options;

  static ProductDto fromJson(Map<String, dynamic> json) => _$ProductDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductDtoToJson(this);

  @override
  String toString() => 'ProductDto{${toJson()}}';
}

@JsonSerializable()
class ProductOptionDto {
  const ProductOptionDto({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  static const none = ProductOptionDto(id: '', name: '');

  static ProductOptionDto fromJson(Map<String, dynamic> json) => _$ProductOptionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductOptionDtoToJson(this);

  @override
  String toString() => 'ProductOptionDto{${toJson()}}';
}
