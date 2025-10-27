import 'package:beinex_ecom/domain/entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
}
