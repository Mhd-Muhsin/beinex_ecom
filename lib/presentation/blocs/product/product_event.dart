part of 'product_bloc.dart';

abstract class ProductEvent {}

class LoadProductsEvent extends ProductEvent {}

class FilterByCategoryEvent extends ProductEvent {
  FilterByCategoryEvent({required this.category});
  final String category;
}

class FilterByRatingEvent extends ProductEvent {
  FilterByRatingEvent({required this.rating});
  final double rating;
}

class SortEvent extends ProductEvent {
  SortEvent({required this.sort});
  final String sort;
}

class SearchEvent extends ProductEvent {
  SearchEvent({required this.searchString});
  final String searchString;
}