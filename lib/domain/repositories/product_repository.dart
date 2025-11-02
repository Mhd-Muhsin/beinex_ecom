import 'package:beinex_ecom/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  // Future addToCart({required int id, required int quantity});

}
