import 'package:bloc/bloc.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<PlaceOrder>((event, emit) {
      emit(OrderPlaced());
    });
  }
}
