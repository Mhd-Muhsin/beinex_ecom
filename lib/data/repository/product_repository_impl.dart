import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../../core/constants.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasource/local_datasource/product_local_datasource.dart';
import '../datasource/product_remote_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final ProductLocalDataSource localDataSource;

  ProductRepositoryImpl({required this.remoteDataSource, required this.localDataSource});

  @override
  Future<List<Product>> getProducts() async {
    bool connected = await hasInternetConnection();
    print("INTERNET: $connected");
    final productModels = await localDataSource.getProducts();
    if(!connected || productModels.isNotEmpty){
      final products = productModels.map((model) {
        return model.toEntity();
      }).toList();
      return products;
    }else{
      final productModels = await remoteDataSource.fetchProducts();

      await localDataSource.saveProducts(productModels);

      final products = productModels.map((model) {
        return model.toEntity();
      }).toList();
      return products;
    }
  }


  Future<bool> hasInternetConnection() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      return false;
    } else {
      try {
        final result = await InternetAddress.lookup('google.com');
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (e) {
        return false;
      }
    }
  }


}
