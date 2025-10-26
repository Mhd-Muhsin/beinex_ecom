import 'package:flutter/material.dart';
import '../../core/colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_entity.dart';
import '../blocs/cart/cart_bloc.dart';

class ProductDetailPage extends StatefulWidget {
  final Product product;
  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int qty = 1;

  @override
  Widget build(BuildContext context) {
    final stock = widget.product.stock;
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          AspectRatio(aspectRatio: 1, child: Image.network(widget.product.image, fit: BoxFit.contain)),
          const SizedBox(height: 12),
          Text(widget.product.title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(widget.product.description),
          const SizedBox(height: 8),
          Text(
            "\$ ${widget.product.price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),          const SizedBox(height: 8),
          Text('Rating: ${widget.product.rating} ⭐'),
          const SizedBox(height: 12),
          Text('In stock: $stock'),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Quantity: ', style: TextStyle(fontWeight: FontWeight.bold),),
              Row(
                children: [
                  IconButton(onPressed: () { if (qty>1) setState((){qty--;}); }, icon: const Icon(Icons.remove_circle_outlined, color: yellowColor,)),
                  Text('$qty'),
                  IconButton(onPressed: () { if (qty<stock) setState((){qty++;}); }, icon: const Icon(Icons.add_circle_outlined, color: yellowColor )),
                  // const Spacer(),
                ],
              ),
            ],
          ),
          ElevatedButton(
            onPressed: stock<=0 ? null : () {
              if (qty > stock) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Not enough stock')));
                return;
              }
              final cartBloc = BlocProvider.of<CartBloc>(context);
              cartBloc.add(AddToCartEvent(widget.product, qty));
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Added to cart')));
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
                  "Add to Cart",
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
    );
  }
}
