import 'package:bloc/bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../domain/entities/product.dart';
import '../../../core/constants.dart';
part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final Box box = Hive.box(Constants.hiveCartBox);
  final Map<int, Map<String, dynamic>> cart = {};

  CartBloc() : super(CartInitial()) {
    on<LoadCartEvent>((e, emit) {
      final raw = box.get('cart');
      if (raw != null) {
        final Map<String, dynamic> map = Map<String, dynamic>.from(raw);
        map.forEach((k, v) {
          cart[int.parse(k)] = Map<String, dynamic>.from(v);
        });
      }
      emit(CartUpdated(Map.from(cart)));
    });

    on<AddToCartEvent>((e, emit) async {
      final product = e.product;
      final qty = e.quantity;
      final existing = cart[product.id];
      if (existing != null) {
        existing['qty'] = (existing['qty'] as int) + qty;
      } else {
        cart[product.id] = {
          'product': product,
          'qty': qty,
        };
      }
      await _save();
      emit(CartUpdated(Map.from(cart)));
    });

    on<ChangeQuantityEvent>((e, emit) async {
      final id = e.productId;
      if (!cart.containsKey(id)) return;
      if (e.newQty <= 0) {
        cart.remove(id);
      } else {
        cart[id]!['qty'] = e.newQty;
      }
      await _save();
      emit(CartUpdated(Map.from(cart)));
    });

    on<RemoveFromCartEvent>((e, emit) async {
      cart.remove(e.productId);
      await _save();
      emit(CartUpdated(Map.from(cart)));
    });

    on<ClearCartEvent>((e, emit) async {
      cart.clear();
      await box.delete('cart');
      emit(CartUpdated(Map.from(cart)));
    });
  }

  Future<void> _save() async {
    final toSave = <String, dynamic>{};
    cart.forEach((k, v) {
      final p = v['product'] as Product;
      toSave['\$k'] = {
        'product': {
          'id': p.id,
          'title': p.title,
          'price': p.price,
          'image': p.image,
        },
        'qty': v['qty'],
      };
    });
    await box.put('cart', toSave);
  }

  double get total {
    double t = 0.0;
    cart.forEach((k, v) {
      final p = v['product'] as Product;
      t += p.price * (v['qty'] as int);
    });
    return t;
  }
}
