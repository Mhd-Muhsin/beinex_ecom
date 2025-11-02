part of 'cart_bloc.dart';

abstract class CartEvent {}

class LoadCartEvent extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final int id;
  final int quantity;

  AddToCartEvent({required this.id, required this.quantity});
}

class RemoveFromCartEvent extends CartEvent {
  final int id;
  final int quantity;

  RemoveFromCartEvent({required this.id, required this.quantity});
}