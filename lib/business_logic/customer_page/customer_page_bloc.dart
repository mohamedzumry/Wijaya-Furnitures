import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/data/dto/customer/customer_dto.dart';
import 'package:furniture_shop_wijaya/data/models/customer/customer.dart';
import 'package:furniture_shop_wijaya/data/repository/customer_repository/customer_repository.dart';

import '../search/bloc/search_bloc_bloc.dart';
part 'customer_page_event.dart';
part 'customer_page_state.dart';

class CustomerPageBloc extends Bloc<CustomerPageEvent, CustomerPageState> {
  CustomerRepository customerRepository = CustomerRepository();

  late BuildContext buildContext;
  late SearchBlocBloc searchBlocBloc;

  CustomerPageBloc() : super(CustomerPageInitial()) {
    on<CustomerPageInitialFetchEvent>(customerPageInitialFetchEvent);
    on<CustomerPageNewCustomerSaveButtonClickedEvent>(
        customerPageNewCustomerSaveButtonClickedEvent);
    on<CustomersPageTileClickedEvent>(customersPageTileClickedEvent);
    on<CustomerPageUpdateButtonClickedEvent>(
        customerPageUpdateButtonClickedEvent);
    on<CustomerPageDeleteCheckEvent>(customerPageDeleteCheckEvent);
    on<CustomerPageDeleteButtonClickedEvent>(
        customerPageDeleteButtonClickedEvent);
  }

  Future<FutureOr<void>> customerPageInitialFetchEvent(
      CustomerPageInitialFetchEvent event,
      Emitter<CustomerPageState> emit) async {
    buildContext = event.buildContext;
    searchBlocBloc = BlocProvider.of<SearchBlocBloc>(buildContext);
    emit(CustomerPageLoadingState());
    var customerList = await customerRepository.getAllCustomers();
    emit(CustomerPageLoadingSuccessState(customerList: customerList));
    // ignore: invalid_use_of_visible_for_testing_member
    searchBlocBloc.emit(
        CustomerPageSearchDataLoadingSucessState(customerList: customerList));
  }

  Future<FutureOr<void>> customerPageNewCustomerSaveButtonClickedEvent(
      CustomerPageNewCustomerSaveButtonClickedEvent event,
      Emitter<CustomerPageState> emit) async {
    bool isSaved = await customerRepository
        .saveCustomerDetails(event.customerTypeDTO.toJson());
    if (isSaved) {
      emit(CustomerPageNewCategoryAddedSuccessActionState());
    } else {
      emit(CustomerPageNewCategoryAddedErrorActionState());
    }
  }

  Future<FutureOr<void>> customerPageUpdateButtonClickedEvent(
      CustomerPageUpdateButtonClickedEvent event,
      Emitter<CustomerPageState> emit) async {
    bool isUpdated =
        await customerRepository.updateCustomers(event.customerType);
    isUpdated
        ? emit(CustomerUpdatedSucessActionState())
        : emit(CustomerUpdatedErrorActionState());
  }

  FutureOr<void> customersPageTileClickedEvent(
      CustomersPageTileClickedEvent event,
      Emitter<CustomerPageState> emit) async {
    var customersList = await customerRepository.getAllCustomers();
    emit(CustomerPageSetUpdatePageState(
        customerList: customersList, customerType: event.customerType));
  }

  FutureOr<void> customerPageDeleteCheckEvent(
      CustomerPageDeleteCheckEvent event, Emitter<CustomerPageState> emit) {
    emit(CustomerDeleteCheckEventActionState(customerType: event.customerType));
  }

  FutureOr<void> customerPageDeleteButtonClickedEvent(
      CustomerPageDeleteButtonClickedEvent event,
      Emitter<CustomerPageState> emit) async {
    bool isDeleted =
        await customerRepository.deleteCustomer(event.customerType.customerNIC);
    isDeleted
        ? emit(CustomerDeleteSucessActionState())
        : emit(CustomerDeleteErrorActionState());
  }
}
