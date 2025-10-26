import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';
import '../../core/constants.dart';

abstract class RemoteDataSource {
  Future<List<ProductModel>> fetchProducts();
}

class RemoteDataSourceImpl implements RemoteDataSource {
  final client = http.Client();

  @override
  Future<List<ProductModel>> fetchProducts() async {
    final uri = Uri.parse('${Constants.baseUrl}/products');
    try {
      final res = await client.get(uri).timeout(const Duration(seconds: 15));
      if (res.statusCode == 200) {
        final List data = json.decode(res.body) as List<dynamic>;
        return data
            .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch products: ${res.statusCode} ${res.reasonPhrase}');
      }
    } catch (e, st) {
      rethrow;
    }
  }
}
