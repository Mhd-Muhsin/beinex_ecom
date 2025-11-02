import 'package:auto_route/annotations.dart';
import 'package:beinex_ecom/core/constants.dart';
import 'package:beinex_ecom/presentation/pages/order_summar_page.dart';
import 'package:beinex_ecom/presentation/pages/product_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

import '../../core/colors.dart';
import '../../domain/entities/product_entity.dart';
import '../blocs/cart/cart_bloc.dart';
import '../blocs/product/product_bloc.dart';

@RoutePage()
class CartPage extends StatefulWidget {
  CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {

  @override
  void initState() {
    BlocProvider.of<CartBloc>(context,listen: false).add(LoadCartEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final cartBloc = BlocProvider.of<CartBloc>(context,listen: true);

    return Scaffold(
      appBar: AppBar(
        title: Text("Cart", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: BlocConsumer<CartBloc, CartState>(
        builder: (context, state) {
          if (state is CartLoading) return const Center(child: CircularProgressIndicator());
          if(state is CartLoaded)
            if (state.cartProducts.isEmpty) {
              return _buildEmptyCart(context);
            } else
            return OrientationBuilder(
              builder: (context, orientation) {
                if(orientation == Orientation.portrait) return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: state.cartProducts.length,
                        itemBuilder: (context, index) {
                          final cartProduct = state.cartProducts[index];
                          return buildCartItemCard(context, cartBloc, cartProduct);
                        },
                      ),
                    ),
                    buildCartSummary(context, cartBloc, state.cartProducts),
                  ],
                ); else return Row(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.all(16),
                        itemCount: state.cartProducts.length,
                        itemBuilder: (context, index) {
                          final cartProduct = state.cartProducts[index];
                          return buildCartItemCard(context, cartBloc, cartProduct);
                        },
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width/3,
                      child: buildCartSummary(context, cartBloc, state.cartProducts)),
                  ],
                );
              }
            );
          if (state is CartError) return Center(child: Text(state.message));
          return const SizedBox.shrink();
        },
        listener: (context, state) {
          if (state is CartLoaded) {
            final productBloc = BlocProvider.of<ProductBloc>(context,listen: false);
            productBloc.add(LoadProductsEvent());
          }
        },
      )
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 100, color: greyColor),
          SizedBox(height: 20),
          Text(
            "Your cart is empty",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: greyColor,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Add some products to get started",
            style: TextStyle(fontSize: 16, color: greyColor),
          ),
          SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => ProductListPage()),
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: greenColor,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Start Shopping",
              style: TextStyle(
                color: whiteColor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCartItemCard(
      BuildContext context,
      CartBloc cartBloc,
      Product cartProduct,
      ) {

    int quantity = Constants.initialStock - cartProduct.stock;
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    cartProduct.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: greyColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.image, color: purple, size: 40,),
                      );
                    },
                  ),
                ),
                SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cartProduct.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Text(
                        cartProduct.category,
                        style: TextStyle(color: greyColor, fontSize: 14),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "\$${cartProduct.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: greenColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    cartBloc.add(RemoveFromCartEvent(id: cartProduct.id, quantity: -quantity));
                  },
                  icon: Icon(Icons.delete_outline, color: Colors.red),
                ),
              ],
            ),

            SizedBox(height: 16),
            Divider(color: greyColor.withValues(alpha: 0.3)),
            SizedBox(height: 8),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Quantity:",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (quantity>1) {
                          cartBloc.add(RemoveFromCartEvent(id: cartProduct.id, quantity: -1));
                        }
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.remove, color: whiteColor, size: 18),
                      ),
                    ),

                    SizedBox(width: 16),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: greyColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "$quantity",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),

                    SizedBox(width: 16),

                    GestureDetector(
                      onTap: () {
                        cartBloc.add(AddToCartEvent(id: cartProduct.id, quantity: 1));
                      },
                      child: Container(
                        width: 35,
                        height: 35,
                        decoration: BoxDecoration(
                          color: greenColor,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.add, color: whiteColor, size: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCartSummary(BuildContext context, CartBloc cartBloc, List<Product> products) {
    return Column(
      children: [
        Divider(thickness: 2, color: greyColor),
        Container(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total Items:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "${cartBloc.cartCount} items",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              SizedBox(height: 12),
              //
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(
              //       "Subtotal:",
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              //     ),
              //     Text(
              //       "\$${cartBloc.cartTotalPrice.abs().toStringAsFixed(2)}",
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              //     ),
              //   ],
              // ),

              SizedBox(height: 8),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Shipping:",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "Free",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: greenColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 16),
              Divider(thickness: 2, color: greyColor),
              SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "TOTAL:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "\$${cartBloc.cartTotalPrice.abs().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: greenColor,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 24),

              ElevatedButton(
                onPressed: () async{
                  _showNotification();
                  await Future.delayed(Duration(milliseconds: 300),(){
                    products.forEach((product){
                      product.stock = Constants.initialStock - product.stock;
                    });
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (_) => OrderSummaryPage(products: products,)));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: greenColor,
                  minimumSize: Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  "Proceed to Checkout",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _showNotification() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    const androidDetails = AndroidNotificationDetails('orders', 'Orders', channelDescription: 'Order notifications', importance: Importance.max, priority: Priority.high);
    const details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Order placed', 'Your order has been placed successfully', details);
  }

}
