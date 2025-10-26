import '../entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  int getStockForProduct(int id);
  void reduceStock(int id, int amount);
  void increaseStock(int id, int amount);
}
