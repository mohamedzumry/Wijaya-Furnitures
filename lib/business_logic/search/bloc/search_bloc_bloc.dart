import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:furniture_shop_wijaya/data/models/category/category.dart';
import 'package:furniture_shop_wijaya/data/models/customer/customer.dart';
import 'package:furniture_shop_wijaya/data/repository/category_repository/category_repository.dart';
import 'package:furniture_shop_wijaya/data/repository/customer_repository/customer_repository.dart';

import '../../../data/models/item/item.dart';
import '../../../data/models/supplier/supplier.dart';
import '../../../data/repository/item_repository/item_repository.dart';
import '../../../data/repository/supplier_repository/supplier_repository.dart';

part 'search_bloc_event.dart';
part 'search_bloc_state.dart';

class SearchBlocBloc extends Bloc<SearchBlocEvent, SearchBlocState> {
  SupplierRepository supplierRepository = SupplierRepository();
  CategoryRepository categoryRepository = CategoryRepository();
  ItemRepository itemRepository = ItemRepository();
  CustomerRepository customerRepository = CustomerRepository();

  SearchBlocBloc() : super(SearchBlocInitial()) {
    on<SupplierSearchBarValueChangedEvent>(supplierSearchBarValueChangedEvent);
    on<CategorySearchBarValueChangedEvent>(categorySearchBarValueChangedEvent);
    on<ItemSearchBarValueChangedEvent>(itemSearchBarValueChangedEvent);
    on<CustomerSearchBarValueChangedEvent>(customerSearchBarValueChangedEvent);
  }

  FutureOr<void> supplierSearchBarValueChangedEvent(
      SupplierSearchBarValueChangedEvent event,
      Emitter<SearchBlocState> emit) async {
    // emit(SupplierPageLoadingState());
    var supplierList = await supplierRepository
        .getAllSuppliersBySearchQuery(event.searchQuery);
    emit(SupplierPageSearchDataLoadingSucessState(supplierList: supplierList));
  }

  FutureOr<void> categorySearchBarValueChangedEvent(
      CategorySearchBarValueChangedEvent event,
      Emitter<SearchBlocState> emit) async {
    var categoryList =
        await categoryRepository.getCategoriesBySearchQuery(event.searchQuery);
    emit(CategoryPageSearchDataLoadingSucessState(categoryList: categoryList));
  }

  FutureOr<void> itemSearchBarValueChangedEvent(
      ItemSearchBarValueChangedEvent event,
      Emitter<SearchBlocState> emit) async {
    var itemList = await itemRepository.searchItemsByQuery(
        event.searchQuery, event.allItems);
    emit(ItemPageSearchDataLoadingSucessState(itemList: itemList));
  }

  Future<FutureOr<void>> customerSearchBarValueChangedEvent(
      CustomerSearchBarValueChangedEvent event,
      Emitter<SearchBlocState> emit) async {
    var customerList = await customerRepository.getCustomersByNIC(
        event.searchQuery, event.customerList);
    emit(CustomerPageSearchDataLoadingSucessState(customerList: customerList));
  }
}
