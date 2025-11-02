part of 'cart_bloc.dart';

abstract class CartState {}

class CartInitial extends CartState {}
class AddedToCart extends CartState {}
class CartLoading extends CartState {}
class CartLoaded extends CartState {
  List<Product> cartProducts = [];
  CartLoaded(this.cartProducts);
}
class CartError extends CartState {
  final String message;
  CartError(this.message);
}
