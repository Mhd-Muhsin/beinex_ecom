import 'package:beinex_ecom/core/constants.dart';
import 'package:beinex_ecom/domain/entities/product_entity.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../domain/usecases/add_to_cart_usecase.dart';
import '../../../domain/usecases/get_products_usecase.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final UpdateCartUseCase updateCartUseCase;
  final GetProductsUseCase getProductsUseCase;
  int _cartCount = 0;
  double cartTotalPrice = 0;

  int get cartCount => _cartCount;

  CartBloc({required this.updateCartUseCase, required this.getProductsUseCase}) : super(CartInitial()) {

  on<AddToCartEvent>((event, emit) async {
    cartTotalPrice = 0;
    await updateCartUseCase.call(id: event.id, quantity: event.quantity);
    final allProducts = await getProductsUseCase.call();
    final cartProducts = allProducts.where((product){

      if (product.stock < Constants.initialStock) {
        final quantity = Constants.initialStock - product.stock;
        cartTotalPrice = cartTotalPrice + (product.price*quantity);
      }

      return product.stock < Constants.initialStock;
    }).toList();
    _cartCount = cartProducts.length;
    emit(CartLoaded(cartProducts));
  });

  on<RemoveFromCartEvent>((event, emit) async {
    cartTotalPrice = 0;
    await updateCartUseCase.call(id: event.id, quantity: event.quantity);
    final allProducts = await getProductsUseCase.call();
    final cartProducts = allProducts.where((product){

      if (product.stock < Constants.initialStock) {
        final quantity = Constants.initialStock - product.stock;
        cartTotalPrice = cartTotalPrice - (product.price*quantity);
      }

      return product.stock < Constants.initialStock;
    }).toList();
    _cartCount = cartProducts.length;
    emit(CartLoaded(cartProducts));
  });

  on<LoadCartEvent>((event, emit) async {
    cartTotalPrice = 0;
    emit(CartLoading());
    try {
      final allProducts = await getProductsUseCase.call();
      final cartProducts = allProducts.where((product){

        if (product.stock < Constants.initialStock) {
          final quantity = Constants.initialStock - product.stock;
          cartTotalPrice = cartTotalPrice + (product.price*quantity);
        }

        return product.stock < Constants.initialStock;
      }).toList();
      _cartCount = cartProducts.length;
      emit(CartLoaded(cartProducts));
    } catch (e) {
      emit(CartError('Failed to load products'));
    }
  });

  }
}
