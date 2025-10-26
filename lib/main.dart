import 'package:beinex_ecom/presentation/blocs/theme/theme_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'core/constants.dart';
import 'data/datasources/remote_data_source.dart';
import 'data/datasources/local_data_source.dart';
import 'data/repositories/product_repository_impl.dart';
import 'domain/usecases/get_products_usecase.dart';
import 'presentation/blocs/product/product_bloc.dart';
import 'presentation/blocs/cart/cart_bloc.dart';
import 'presentation/blocs/order/order_bloc.dart';
import 'presentation/pages/product_list_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  await Hive.openBox(Constants.hiveCartBox);

  final themeCubit = await ThemeCubit.create();

  final remoteDataSource = RemoteDataSourceImpl();
  final localDataSource = LocalDataSourceImpl();
  final productRepository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );

  final getProductsUsecase = GetProductsUseCase(productRepository);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ThemeCubit>.value(value: themeCubit),
      BlocProvider<ProductBloc>(
        create: (_) => ProductBloc(getProductsUseCase: getProductsUsecase)..add(LoadProductsEvent()),
      ),
      BlocProvider<CartBloc>(
        create: (_) => CartBloc()..add(LoadCartEvent()),
      ),
      BlocProvider<OrderBloc>(
        create: (context) => OrderBloc(
          cartBloc: BlocProvider.of<CartBloc>(context),
          productRepository: productRepository,
          flutterLocalNotificationsPlugin: flutterLocalNotificationsPlugin,
        ),
      ),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Clean E-commerce',
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: themeMode,
          home: const ProductListPage(),
        );
      },
    );
  }
}
