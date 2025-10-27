import 'package:bloc/bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/get_products_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  ProductBloc({required this.getProductsUseCase}) : super(ProductInitial()) {
    on<LoadProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        final products = await getProductsUseCase.call();
        emit(ProductLoaded(products));
      } catch (e) {
        emit(ProductError('Failed to load products'));
      }
    });
  }
}
