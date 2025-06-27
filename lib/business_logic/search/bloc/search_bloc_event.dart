part of 'search_bloc_bloc.dart';

@immutable
sealed class SearchBlocEvent {}

class SupplierSearchBarValueChangedEvent extends SearchBlocEvent {
  final String searchQuery;

  SupplierSearchBarValueChangedEvent({required this.searchQuery});
}

class CategorySearchBarValueChangedEvent extends SearchBlocEvent {
  final String searchQuery;

  CategorySearchBarValueChangedEvent({required this.searchQuery});
}

class ItemSearchBarValueChangedEvent extends SearchBlocEvent {
  final String searchQuery;
  final List<Item> allItems;

  ItemSearchBarValueChangedEvent(
      {required this.searchQuery, required this.allItems});
}

class CustomerSearchBarValueChangedEvent extends SearchBlocEvent {
  final List<CustomerType> customerList;
  final String searchQuery;

  CustomerSearchBarValueChangedEvent(
      {required this.customerList, required this.searchQuery});
}
