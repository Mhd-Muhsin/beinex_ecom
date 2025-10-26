import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote_data_source.dart';
import '../datasources/local_data_source.dart';
import '../models/product_model.dart';
import '../../core/constants.dart';

class ProductRepositoryImpl implements ProductRepository {
  final RemoteDataSource remoteDataSource;
  final LocalDataSource localDataSource;

  final Map<int, int> _stockMap = {};

  ProductRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<List<Product>> getProducts() async {
    final models = await remoteDataSource.fetchProducts();
    final products = models.map((m) {
      _stockMap.putIfAbsent(m.id, () => Constants.initialStock);
      return m.toEntity(_stockMap[m.id]!);
    }).toList();
    return products;
  }

  @override
  int getStockForProduct(int id) {
    return _stockMap[id] ?? Constants.initialStock;
  }

  @override
  void reduceStock(int id, int amount) {
    final curr = _stockMap[id] ?? Constants.initialStock;
    _stockMap[id] = (curr - amount).clamp(0, Constants.initialStock);
  }

  @override
  void increaseStock(int id, int amount) {
    final curr = _stockMap[id] ?? 0;
    _stockMap[id] = (curr + amount).clamp(0, Constants.initialStock);
  }
}
