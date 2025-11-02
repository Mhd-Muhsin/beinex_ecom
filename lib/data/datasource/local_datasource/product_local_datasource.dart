import 'dart:convert';
import 'package:beinex_ecom/data/datasource/local_datasource/product_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../models/product_model.dart';
import '../../../core/constants.dart';

abstract class ProductLocalDataSource {
  Future<void> saveProducts(List<ProductModel> products);
  Future<void> updateProduct({required int id, required int quantity});
  Future<void> resetProductData();
  Future<List<ProductModel>> getProducts();
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {

  @override
  Future<void> saveProducts(List<ProductModel> products) async{
    final productBox = await Hive.box<ProductHiveModel>(ProductHiveModel.boxKey);

    if (productBox.isEmpty) {

      products.forEach((product)async{
        final hiveModel = product.toProductHiveModel(Constants.initialStock);
        await productBox.put(hiveModel.id, hiveModel);
        }
      );
    }
  }

  @override
  Future<void> updateProduct({required int id, required int quantity}) async{
    final productBox = await Hive.box<ProductHiveModel>(ProductHiveModel.boxKey);
    // productBox.clear();
    ProductHiveModel? productHiveModel = productBox.get(id);
    productHiveModel?.stock = productHiveModel.stock-quantity;
    productBox.put(id, productHiveModel!);
    print('DB updated');
  }

  @override
  Future<List<ProductModel>> getProducts() async{
    final productBox = await Hive.box<ProductHiveModel>(ProductHiveModel.boxKey);
    final productHiveModels = productBox.values.toList();
    return productHiveModels.map((productHiveModel){
      return productHiveModel.toProductModel();
    }).toList();
  }

  @override
  Future<void> resetProductData() async{
    final productBox = await Hive.box<ProductHiveModel>(ProductHiveModel.boxKey);
    final productHiveModels = productBox.values.toList();
    productHiveModels.forEach((productHiveModel)async{
        productHiveModel.stock = Constants.initialStock;
      await productBox.put(productHiveModel.id, productHiveModel);
    });
  }

}
