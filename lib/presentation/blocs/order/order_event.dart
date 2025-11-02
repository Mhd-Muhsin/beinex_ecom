part of 'order_bloc.dart';

abstract class OrderEvent {}

class LoadOrderEvent extends OrderEvent {}

class PlaceOrder extends OrderEvent {}
