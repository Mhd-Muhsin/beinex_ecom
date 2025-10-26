part of 'order_bloc.dart';

abstract class OrderState {}

class OrderInitial extends OrderState {}
class OrderPlaced extends OrderState {}
class OrderFailed extends OrderState {
  final String message;
  OrderFailed(this.message);
}
