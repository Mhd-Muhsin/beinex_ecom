import 'package:beinex_ecom/domain/repositories/cart_repositoy.dart';

import '../datasource/local_datasource/product_local_datasource.dart';

class CartRepositoryImpl implements CartRepository{
  final ProductLocalDataSource localDataSource;

  CartRepositoryImpl({required this.localDataSource});

  @override
  Future addToCart({required int id, required int quantity}) async{
    await localDataSource.updateProduct(id: id, quantity: quantity);
  }
}