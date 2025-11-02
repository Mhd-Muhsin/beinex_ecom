import 'package:beinex_ecom/core/routes/app_router.dart';
import 'package:beinex_ecom/data/datasource/local_datasource/product_local_datasource.dart';
import 'package:beinex_ecom/data/repository/cart_repository_impl.dart';
import 'package:beinex_ecom/presentation/blocs/cart/cart_bloc.dart';
import 'package:beinex_ecom/presentation/blocs/product/product_bloc.dart';
import 'package:beinex_ecom/presentation/blocs/theme/theme_cubit.dart';
import 'package:beinex_ecom/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import 'data/datasource/local_datasource/product_hive_model.dart';
import 'data/datasource/product_remote_datasource.dart';
import 'data/repository/product_repository_impl.dart';
import 'domain/usecases/add_to_cart_usecase.dart';
import 'domain/usecases/get_products_usecase.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  if (!Hive.isAdapterRegistered(ProductHiveModelAdapter().typeId)) {
    Hive.registerAdapter(ProductHiveModelAdapter());
  }
  await Hive.openBox<ProductHiveModel>(ProductHiveModel.boxKey);

  final remoteDataSource = ProductRemoteDataSourceImpl();
  final localDataSource = ProductLocalDataSourceImpl();

  final productRepository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource
  );

  final cartRepository = CartRepositoryImpl(localDataSource: localDataSource);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  final themeCubit = await ThemeCubit.create();

  final getProductsUsecase = GetProductsUseCase(productRepository);
  final updateCartUseCase = UpdateCartUseCase(cartRepository);


  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>.value(value: themeCubit),
      BlocProvider<ProductBloc>(
        create: (_) => ProductBloc(getProductsUseCase: getProductsUsecase)..add(LoadProductsEvent()),
      ),
      BlocProvider<CartBloc>(
        create: (_) => CartBloc(updateCartUseCase: updateCartUseCase, getProductsUseCase: getProductsUsecase)..add(LoadCartEvent()),
      ),
    ],
    child: MyApp(),
  ));}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    AppRouter appRouter = AppRouter();
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'Beinex E-commerce',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          routerConfig: appRouter.config(),
          // home: const ProductListPage(),
        );
      },
    );
  }
}
