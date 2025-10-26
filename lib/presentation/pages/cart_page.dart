import 'package:beinex_ecom/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/colors.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/order/order_bloc.dart';
import 'order_summary_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final orderBloc = BlocProvider.of<OrderBloc>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Cart')),
      body: BlocBuilder<CartBloc, dynamic>(builder: (context, state) {
        if (state is CartUpdated) {
          final entries = state.cart.entries.toList();
          if (entries.isEmpty) return const Center(child: Text('Cart is empty'));
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, i) {
                    final e = entries[i];
                    final product = e.value['product'];
                    final qty = e.value['qty'] as int;
                    return ListTile(
                      leading: Image.network(product.image, width: 56, height: 56),
                      title: Text(product.title, style: TextStyle(fontWeight: FontWeight.w300),),
                      subtitle: Text('\$ ${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green),),
                      trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                        IconButton(icon: Icon(Icons.remove_circle_outlined, color: yellowColor,), onPressed: () {
                          final cartBloc = BlocProvider.of<CartBloc>(context);
                          cartBloc.add(ChangeQuantityEvent(e.key, qty-1));
                        }),
                        Text('$qty'),
                        IconButton(icon: const Icon(Icons.add_circle_outlined, color: yellowColor ), onPressed: () {
                          final cartBloc = BlocProvider.of<CartBloc>(context);
                          cartBloc.add(ChangeQuantityEvent(e.key, qty+1));
                        }),
                        IconButton(icon: const Icon(Icons.delete_outline, color: redColor,), onPressed: () {
                          final cartBloc = BlocProvider.of<CartBloc>(context);
                          cartBloc.add(RemoveFromCartEvent(e.key));
                        }),
                      ]),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Total: ', style: TextStyle(fontSize: 20),),
                        Text('\$ ${BlocProvider.of<CartBloc>(context).total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        orderBloc.add(PlaceOrderEvent());
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order placed')));
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderSummaryPage())).then((_){
                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                              ProductListPage()), (Route<dynamic> route) => false);
                        });
                        },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: greenColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: Size(double.infinity, 55),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_cart_outlined,
                            color: whiteColor,
                          ),
                          SizedBox(width: 12),
                          Text(
                            "Place Order",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: whiteColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      }),
    );
  }
}
