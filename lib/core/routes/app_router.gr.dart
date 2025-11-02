// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i5;
import 'package:beinex_ecom/domain/entities/product_entity.dart' as _i7;
import 'package:beinex_ecom/presentation/pages/cart_page.dart' as _i1;
import 'package:beinex_ecom/presentation/pages/order_summar_page.dart' as _i2;
import 'package:beinex_ecom/presentation/pages/product_detail_page.dart' as _i3;
import 'package:beinex_ecom/presentation/pages/product_list_page.dart' as _i4;
import 'package:flutter/material.dart' as _i6;

/// generated route for
/// [_i1.CartPage]
class CartRoute extends _i5.PageRouteInfo<CartRouteArgs> {
  CartRoute({
    _i6.Key? key,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          CartRoute.name,
          args: CartRouteArgs(key: key),
          initialChildren: children,
        );

  static const String name = 'CartRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args =
          data.argsAs<CartRouteArgs>(orElse: () => const CartRouteArgs());
      return _i1.CartPage(key: args.key);
    },
  );
}

class CartRouteArgs {
  const CartRouteArgs({this.key});

  final _i6.Key? key;

  @override
  String toString() {
    return 'CartRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i2.OrderSummaryPage]
class OrderSummaryRoute extends _i5.PageRouteInfo<OrderSummaryRouteArgs> {
  OrderSummaryRoute({
    _i6.Key? key,
    required List<_i7.Product> products,
    int topN = 8,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          OrderSummaryRoute.name,
          args: OrderSummaryRouteArgs(
            key: key,
            products: products,
            topN: topN,
          ),
          initialChildren: children,
        );

  static const String name = 'OrderSummaryRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<OrderSummaryRouteArgs>();
      return _i2.OrderSummaryPage(
        key: args.key,
        products: args.products,
        topN: args.topN,
      );
    },
  );
}

class OrderSummaryRouteArgs {
  const OrderSummaryRouteArgs({
    this.key,
    required this.products,
    this.topN = 8,
  });

  final _i6.Key? key;

  final List<_i7.Product> products;

  final int topN;

  @override
  String toString() {
    return 'OrderSummaryRouteArgs{key: $key, products: $products, topN: $topN}';
  }
}

/// generated route for
/// [_i3.ProductDetailPage]
class ProductDetailRoute extends _i5.PageRouteInfo<ProductDetailRouteArgs> {
  ProductDetailRoute({
    _i6.Key? key,
    required _i7.Product product,
    List<_i5.PageRouteInfo>? children,
  }) : super(
          ProductDetailRoute.name,
          args: ProductDetailRouteArgs(
            key: key,
            product: product,
          ),
          initialChildren: children,
        );

  static const String name = 'ProductDetailRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<ProductDetailRouteArgs>();
      return _i3.ProductDetailPage(
        key: args.key,
        product: args.product,
      );
    },
  );
}

class ProductDetailRouteArgs {
  const ProductDetailRouteArgs({
    this.key,
    required this.product,
  });

  final _i6.Key? key;

  final _i7.Product product;

  @override
  String toString() {
    return 'ProductDetailRouteArgs{key: $key, product: $product}';
  }
}

/// generated route for
/// [_i4.ProductListPage]
class ProductListRoute extends _i5.PageRouteInfo<void> {
  const ProductListRoute({List<_i5.PageRouteInfo>? children})
      : super(
          ProductListRoute.name,
          initialChildren: children,
        );

  static const String name = 'ProductListRoute';

  static _i5.PageInfo page = _i5.PageInfo(
    name,
    builder: (data) {
      return const _i4.ProductListPage();
    },
  );
}
