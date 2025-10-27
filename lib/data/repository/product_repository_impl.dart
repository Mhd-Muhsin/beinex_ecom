import '../../core/constants.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasource/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    final productModels = await remoteDataSource.fetchProducts();
    final products = productModels.map((model) {
      return model.toEntity(Constants.initialStock);
    }).toList();
    return products;
  }
}
