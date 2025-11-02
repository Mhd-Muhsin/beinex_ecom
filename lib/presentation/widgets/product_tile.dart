import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../domain/entities/product_entity.dart';
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
            SizedBox(height: 8,),
            AspectRatio(aspectRatio: 1, child: Image.network(product.image, fit: BoxFit.contain, errorBuilder: (_,_,_) => Icon(Icons.image, size: 50, color: purple,),)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('\$ ${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),),
                  Text('${product.rating} ⭐'),
                ],
              ),
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
