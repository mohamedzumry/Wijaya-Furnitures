part of 'customer_page_bloc.dart';

@immutable
sealed class CustomerPageState {}

@immutable
sealed class CustomerPageActionState extends CustomerPageState {}

final class CustomerPageInitial extends CustomerPageState {}

final class CustomerPageLoadingState extends CustomerPageState {}

final class CustomerPageLoadingSuccessState extends CustomerPageState {
  final List<CustomerType> customerList;

  CustomerPageLoadingSuccessState({required this.customerList});
}

class CustomerPageLoadingErrorState extends CustomerPageState {}

class CustomerPageNewCategoryAddedSuccessActionState
    extends CustomerPageActionState {}

class CustomerPageNewCategoryAddedErrorActionState
    extends CustomerPageActionState {}

final class CustomerPageSetUpdatePageState extends CustomerPageState {
  final List<CustomerType> customerList;
  final CustomerType customerType;

  CustomerPageSetUpdatePageState(
      {required this.customerList, required this.customerType});
}

class CustomerUpdatedSucessActionState extends CustomerPageActionState {}

class CustomerUpdatedErrorActionState extends CustomerPageActionState {}

class CustomerDeleteCheckEventActionState extends CustomerPageActionState {
  final CustomerType customerType;

  CustomerDeleteCheckEventActionState({required this.customerType});
}

class CustomerDeleteSucessActionState extends CustomerPageActionState {}

class CustomerDeleteErrorActionState extends CustomerPageActionState {}
