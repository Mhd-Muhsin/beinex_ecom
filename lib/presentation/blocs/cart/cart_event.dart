part of 'cart_bloc.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}
class AddToCartEvent extends CartEvent {
  final Product product;
  final int quantity;
  AddToCartEvent(this.product, this.quantity);
}
class ChangeQuantityEvent extends CartEvent {
  final int productId;
  final int newQty;
  ChangeQuantityEvent(this.productId, this.newQty);
}
class RemoveFromCartEvent extends CartEvent {
  final int productId;
  RemoveFromCartEvent(this.productId);
}
class ClearCartEvent extends CartEvent {}
