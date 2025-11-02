
import 'package:hive/hive.dart';

import '../../models/product_model.dart';
part 'product_hive_model.g.dart';

@HiveType(typeId: 0)
class ProductHiveModel {

  static const String boxKey = 'productDB';

  ProductHiveModel({
    required this.stock,
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
});

  @HiveField(0)
  late int id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late double price;

  @HiveField(3)
  late String description;

  @HiveField(4)
  late String category;

  @HiveField(5)
  late String image;

  @HiveField(6)
  late double rating;

  @HiveField(7)
  late int stock;

  ProductModel toProductModel() {
    return ProductModel(
      id: id,
      title: title,
      price: price,
      description: description,
      category: category,
      image: image,
      rating: Rating(rate: rating, count: 0),
      stock: stock
    );
  }

}