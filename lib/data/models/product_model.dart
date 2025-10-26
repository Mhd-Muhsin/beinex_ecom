import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/product.dart';

part 'product_model.g.dart';

@JsonSerializable()
class ProductModel {
  final int id;
  final String title;
  final num price;
  final String description;
  final String category;
  final String image;
  final Rating? rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => _$ProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  Product toEntity(int initialStock) {
    return Product(
      id: id,
      title: title,
      price: (price as num).toDouble(),
      description: description,
      category: category,
      image: image,
      rating: rating?.rateDouble ?? 0.0,
      stock: initialStock,
    );
  }
}

@JsonSerializable()
class Rating {
  final num rate;
  final int count;

  Rating({required this.rate, required this.count});

  double get rateDouble => (rate as num).toDouble();

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
