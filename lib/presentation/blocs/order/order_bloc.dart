import 'package:bloc/bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../../domain/repositories/product_repository.dart';
import '../cart/cart_bloc.dart';
part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CartBloc cartBloc;
  final ProductRepository productRepository;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  OrderBloc({
    required this.cartBloc,
    required this.productRepository,
    required this.flutterLocalNotificationsPlugin,
  }) : super(OrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
  }

  Future<void> _onPlaceOrder(PlaceOrderEvent event, Emitter<OrderState> emit) async {
    final state = cartBloc.state;
    if (state is! CartUpdated || state.cart.isEmpty) {
      emit(OrderFailed('Cart is empty'));
      return;
    }

    for (final entry in state.cart.entries) {
      final productId = entry.key;
      final qty = entry.value['qty'] as int;
      productRepository.reduceStock(productId, qty);
    }

    cartBloc.add(ClearCartEvent());

    await _showNotification();

    emit(OrderPlaced());
  }

  Future<void> _showNotification() async {
    const androidDetails = AndroidNotificationDetails('orders', 'Orders', channelDescription: 'Order notifications', importance: Importance.max, priority: Priority.high);
    const details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(0, 'Order placed', 'Your order has been placed successfully', details);
  }
}
