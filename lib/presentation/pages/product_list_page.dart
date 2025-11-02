import 'package:auto_route/annotations.dart';
import 'package:beinex_ecom/core/colors.dart';
import 'package:beinex_ecom/presentation/blocs/cart/cart_bloc.dart';
import 'package:beinex_ecom/presentation/widgets/seach_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/product/product_bloc.dart';
import '../blocs/theme/theme_cubit.dart';
import '../widgets/product_tile.dart';
import 'package:badges/badges.dart' as BADGE;

import 'cart_page.dart';

@RoutePage()
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productBloc = BlocProvider.of<ProductBloc>(context,listen: true);

    return GestureDetector(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Beinex E-com', style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
        actions: [
            BlocBuilder<ThemeCubit, ThemeMode>(
              builder: (context, themeMode) {
                return IconButton(
                  icon: Icon(themeMode == ThemeMode.dark ? Icons.wb_sunny : Icons.nightlight_round),
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                );
              },
            ),
            BADGE.Badge(
              position: BADGE.BadgePosition.topEnd(top: 0, end: 3),
              showBadge: BlocProvider.of<CartBloc>(context, listen: true).cartCount != 0 ? true : false,
              badgeContent: Text("${BlocProvider.of<CartBloc>(context, listen: true).cartCount}", style: TextStyle(color: whiteColor, fontSize: 12),),
              child: IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
                }
              ),
            ),
          ],),
        body: Column(
          children: [
            SearchBarWidget(),
            Expanded(
              child: BlocBuilder<ProductBloc, dynamic>(
                builder: (context, state) {
                  if (state is ProductLoading) return const Center(child: CircularProgressIndicator());
                  if (state is ProductLoaded) {
                    final products = state.products;
                    return products.isEmpty ? Center(child: Text('No Products to display')) :
                    Column(
                      children: [
                        SizedBox(height: 12,),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.62),
                            itemCount: products.length,
                            itemBuilder: (context, i) => ProductTile(product: products[i]),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is ProductError) return Center(child: Text(state.message));
                  return const SizedBox.shrink();
              }),
            ),
          ],
        ),
      ),
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      behavior: HitTestBehavior.opaque,
    );
  }
}
