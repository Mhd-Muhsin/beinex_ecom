import 'package:beinex_ecom/presentation/blocs/product/product_bloc.dart';
import 'package:beinex_ecom/presentation/blocs/theme/theme_cubit.dart';
import 'package:beinex_ecom/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/datasource/product_remote_datasource.dart';
import 'data/repository/product_repository_impl.dart';
import 'domain/usecases/get_products_usecase.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  final remoteDataSource = ProductRemoteDataSourceImpl();
  final productRepository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  final themeCubit = await ThemeCubit.create();

  final getProductsUsecase = GetProductsUseCase(productRepository);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>.value(value: themeCubit),
      BlocProvider<ProductBloc>(
        create: (_) => ProductBloc(getProductsUseCase: getProductsUsecase)..add(LoadProductsEvent()),
      ),
      // BlocProvider<CartBloc>(
      //   create: (_) => CartBloc()..add(LoadCartEvent()),
      // ),
      // BlocProvider<OrderBloc>(
      //   create: (context) => OrderBloc(
      //     cartBloc: BlocProvider.of<CartBloc>(context),
      //     productRepository: productRepository,
      //     flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
      //   ),
      // ),
    ],
    child: MyApp(),
  ));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Beinex E-commerce',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const ProductListPage(),
        );
      },
    );
  }
}
