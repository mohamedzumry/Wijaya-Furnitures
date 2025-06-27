part of 'supplier_page_bloc.dart';

@immutable
sealed class SupplierPageState {}

sealed class SupplierPageActionState extends SupplierPageState {}

final class SupplierPageInitial extends SupplierPageState {}

class SupplierPageLoadingState extends SupplierPageState {}

class SupplierPageLoadingSuccessState extends SupplierPageState {
  final List<Supplier> supplierList;

  SupplierPageLoadingSuccessState({required this.supplierList});
}

class SupplierPageLoadingErrorState extends SupplierPageState {}

class SupplierPageNewSupplierSavedSucessActionState
    extends SupplierPageActionState {}

class SupplierPageNewSupplierAddedAlreadyExistErrorActionState
    extends SupplierPageActionState {}

class SupplierPageNewSupplierSavedErrorActionState
    extends SupplierPageActionState {}

class SupplierPageSetUpdatePageState extends SupplierPageState {
  final List<Supplier> supplierList;
  final Supplier supplier;

  SupplierPageSetUpdatePageState(
      {required this.supplierList, required this.supplier});
}

class SupplierDeleteCheckEventActionState extends SupplierPageActionState {
  final Supplier supplier;

  SupplierDeleteCheckEventActionState({required this.supplier});
}

class SupplierDeleteSucessActionState extends SupplierPageActionState {}

class SupplierAlreadyAssignedActionState extends SupplierPageActionState {}

class SupplierDeleteErrorActionState extends SupplierPageActionState {}

class SupplierPageSupplierUpdatedSucessActionState
    extends SupplierPageActionState {}

class SupplierPageSupplierUpdatedErrorActionState
    extends SupplierPageActionState {}
