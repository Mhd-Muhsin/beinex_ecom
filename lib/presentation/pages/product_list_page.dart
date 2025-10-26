import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/product/product_bloc.dart';
import '../blocs/theme/theme_cubit.dart';
import '../widgets/product_tile.dart';
import 'cart_page.dart';
import 'package:badges/badges.dart' as badges;

class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beinex E-com', style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return IconButton(
                tooltip: themeMode == ThemeMode.dark ? 'Switch to light' : 'Switch to dark',
                icon: Icon(themeMode == ThemeMode.dark ? Icons.wb_sunny : Icons.nightlight_round),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 0, end: 3),
            badgeContent: Text(
              BlocProvider.of<CartBloc>(context, listen: true).cart.length.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
            ),
          )
        ],),
      body: BlocBuilder<ProductBloc, dynamic>(builder: (context, state) {
        if (state is ProductLoading) return const Center(child: CircularProgressIndicator());
        if (state is ProductLoaded) {
          final products = state.products;
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.68),
            itemCount: products.length,
            itemBuilder: (context, i) => ProductTile(product: products[i]),
          );
        }
        if (state is ProductError) return Center(child: Text(state.message));
        return const SizedBox.shrink();
      }),
    );
  }
}
