import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../pages/product_detail_page.dart';

class ProductTile extends StatelessWidget {
  final Product product;
  const ProductTile({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailPage(product: product))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(aspectRatio: 1, child: Image.network(product.image, fit: BoxFit.contain)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('\$ ${product.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.green),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('In stock: ${product.stock}'),
            ),
          ],
        ),
      ),
    );
  }
}
