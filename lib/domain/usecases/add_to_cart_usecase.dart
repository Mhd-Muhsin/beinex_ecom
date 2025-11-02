import '../entities/product_entity.dart';
import '../repositories/cart_repositoy.dart';
import '../repositories/product_repository.dart';

class UpdateCartUseCase {
  final CartRepository repository;
  UpdateCartUseCase(this.repository);

  Future call({required int id, required int quantity}) async {
    return await repository.addToCart(id: id, quantity: quantity);
  }
}
