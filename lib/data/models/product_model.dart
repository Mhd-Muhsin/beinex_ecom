import 'package:beinex_ecom/domain/entities/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../core/constants.dart';
import '../datasource/local_datasource/product_hive_model.dart';

part 'product_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductModel{
  final int id;
  final String title;
  final double price;
  final String description;
  final String category;
  final String image;
  final Rating rating;
  int? stock;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
    this.stock,
  });

  Product toEntity() {
    return Product(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating?.rateDouble ?? 0.0,
      stock: stock ?? Constants.initialStock,
    );
  }

  ProductHiveModel toProductHiveModel(int initialStock) {
    return ProductHiveModel(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: rating?.rateDouble ?? 0.0,
      stock: initialStock,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}

@JsonSerializable()
class Rating {
  final double rate;
  final int count;

  Rating({
    required this.rate,
    required this.count,
  });
  double get rateDouble => (rate as num).toDouble();

  factory Rating.fromJson(Map<String, dynamic> json) =>
      _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
