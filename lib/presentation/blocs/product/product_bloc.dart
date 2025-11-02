import 'package:bloc/bloc.dart';

import '../../../domain/entities/product_entity.dart';
import '../../../domain/usecases/add_to_cart_usecase.dart';
import '../../../domain/usecases/get_products_usecase.dart';

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProductsUseCase getProductsUseCase;

  List<Product> _products = [];

  final List<String> categories = [
    'All',
    "men's clothing",
    'jewelery',
    'electronics',
    "women's clothing",
  ];

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<double> ratings = [
    0,1,2,3,4
  ];

  double _selectedRating = 0;
  double get selectedRating => _selectedRating;

  final List<String> sortList = [
    'Relevance',
    'Price ascending',
    'Price descending',
    'Rating ascending',
    'Rating descending',
  ];

  String? _selectedSort = 'Relevance';
  String? get selectedSort => _selectedSort;

  String _searchProduct = '';

  List<Product> get filteredProducts {
    //filter
    List<Product> filteredProducts = _products;
      if( _selectedCategory == 'All'){
      filteredProducts = _products.where((product) =>
        product.rating >= _selectedRating
      ).toList();
    } else {
      filteredProducts = _products.where((product) =>
        product.category.toLowerCase() == _selectedCategory.toLowerCase() && (product.rating >= _selectedRating)
      ).toList();
    }

    // sort
    if(_selectedSort == 'Price ascending')filteredProducts.sort((a,b) => a.price.compareTo(b.price));
    if(_selectedSort == 'Price descending')filteredProducts.sort((a,b) => b.price.compareTo(a.price));
    if(_selectedSort == 'Rating ascending')filteredProducts.sort((a,b) => a.rating.compareTo(b.rating));
    if(_selectedSort == 'Rating descending')filteredProducts.sort((a,b) => b.rating.compareTo(a.rating));

    //search
    if (_searchProduct.isEmpty) {
      return filteredProducts;
    } else{
      filteredProducts = filteredProducts.where((product) =>
          product.title.toLowerCase().contains(_searchProduct.toLowerCase(),),
      ).toList();
    }
    return filteredProducts;
  }

  ProductBloc({required this.getProductsUseCase}) : super(ProductInitial()) {

    on<LoadProductsEvent>((event, emit) async {
      emit(ProductLoading());
      try {
        _products = await getProductsUseCase.call();
        emit(ProductLoaded(filteredProducts));
      } catch (e) {
        emit(ProductError('Failed to load _products'));
      }
    });

    on<FilterByCategoryEvent>((event, emit) async {
      _selectedCategory = event.category;
      emit(ProductLoaded(filteredProducts));
      // emit(ChangeCategoryState());
    });

    on<FilterByRatingEvent>((event, emit) async {
      _selectedRating = event.rating;
      emit(ProductLoaded(filteredProducts));
    });

    on<SortEvent>((event, emit) async {
      _selectedSort = event.sort;
      emit(ProductLoaded(filteredProducts));
    });

    on<SearchEvent>((event, emit) async {
      _searchProduct = event.searchString;
      emit(ProductLoaded(filteredProducts));
    });
  }
}
