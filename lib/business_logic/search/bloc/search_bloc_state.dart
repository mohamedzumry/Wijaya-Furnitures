part of 'search_bloc_bloc.dart';

@immutable
sealed class SearchBlocState {}

class SearchBlocActionState extends SearchBlocState {}

final class SearchBlocInitial extends SearchBlocState {}

class SupplierPageSearchDataLoadingSucessState extends SearchBlocState {
  final List<Supplier> supplierList;

  SupplierPageSearchDataLoadingSucessState({required this.supplierList});
}

class CategoryPageSearchDataLoadingSucessState extends SearchBlocState {
  final List<CategoryType> categoryList;

  CategoryPageSearchDataLoadingSucessState({required this.categoryList});
}

class ItemPageSearchDataLoadingSucessState extends SearchBlocState {
  final List<Item> itemList;

  ItemPageSearchDataLoadingSucessState({required this.itemList});
}

class CustomerPageSearchDataLoadingSucessState extends SearchBlocState {
  final List<CustomerType> customerList;

  CustomerPageSearchDataLoadingSucessState({required this.customerList});
}
