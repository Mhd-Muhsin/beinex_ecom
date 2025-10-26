import 'package:beinex_ecom/presentation/blocs/product/product_bloc.dart';
import 'package:beinex_ecom/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasource/product_remote_datasource.dart';
import 'data/repository/product_repository_impl.dart';
import 'domain/usecases/get_products_usecase.dart';


void main() {

  final remoteDataSource = ProductRemoteDataSourceImpl();
  final productRepository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  final getProductsUsecase = GetProductsUseCase(productRepository);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ProductBloc>(
        create: (_) => ProductBloc(getProductsUseCase: getProductsUsecase)..add(LoadProductsEvent()),
      ),

    ],
    child: MyApp(),
  ));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const ProductListPage(),
    );
  }
}
