import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {

  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: CartRoute.page, initial: true),
    AutoRoute(page: ProductListRoute.page),
    AutoRoute(page: ProductDetailRoute.page),
    AutoRoute(page: OrderSummaryRoute.page),
  ];
}