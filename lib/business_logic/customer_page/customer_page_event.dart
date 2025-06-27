part of 'customer_page_bloc.dart';

@immutable
sealed class CustomerPageEvent {}

class CustomerPageInitialFetchEvent extends CustomerPageEvent {
  final BuildContext buildContext;

  CustomerPageInitialFetchEvent({required this.buildContext});
}

class CustomersPageTileClickedEvent extends CustomerPageEvent {
  final CustomerType customerType;

  CustomersPageTileClickedEvent({required this.customerType});
}

class CustomerPageDeleteButtonClickedEvent extends CustomerPageEvent {
  final CustomerType customerType;

  CustomerPageDeleteButtonClickedEvent({required this.customerType});
}

class CustomerPageDeleteCheckEvent extends CustomerPageEvent {
  final CustomerType customerType;

  CustomerPageDeleteCheckEvent({required this.customerType});
}

class CustomerPageNewCustomerSaveButtonClickedEvent extends CustomerPageEvent {
  final CustomerTypeDTO customerTypeDTO;

  CustomerPageNewCustomerSaveButtonClickedEvent(
      {required this.customerTypeDTO});
}

class CustomerPageUpdateButtonClickedEvent extends CustomerPageEvent {
  final CustomerType customerType;

  CustomerPageUpdateButtonClickedEvent({required this.customerType});
}
