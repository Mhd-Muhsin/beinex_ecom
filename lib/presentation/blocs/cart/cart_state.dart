part of 'cart_bloc.dart';

abstract class CartState {}

class CartInitial extends CartState {}
class CartUpdated extends CartState {
  final Map<int, Map<String, dynamic>> cart;
  CartUpdated(this.cart);
}
