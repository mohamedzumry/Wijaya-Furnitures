part of 'supplier_page_bloc.dart';

@immutable
sealed class SupplierPageEvent {}

class SupplierPageInitialFetchEvent extends SupplierPageEvent {
  final BuildContext buildContext;

  SupplierPageInitialFetchEvent({required this.buildContext});
}

class SupplierPageSaveButtonClickedEvent extends SupplierPageEvent {
  final SupplierDTO supplierDTO;
  final List<Supplier> supplierList;

  SupplierPageSaveButtonClickedEvent(
      {required this.supplierDTO, required this.supplierList});
}

class SupplierPageTileClickedEvent extends SupplierPageEvent {
  final Supplier supplier;

  SupplierPageTileClickedEvent({required this.supplier});
}

class SupplierPageDeleteButtonClickedEvent extends SupplierPageEvent {
  final Supplier supplier;

  SupplierPageDeleteButtonClickedEvent({required this.supplier});
}

class SupplierPageDeleteCheckEvent extends SupplierPageEvent {
  final Supplier supplier;
  SupplierPageDeleteCheckEvent({required this.supplier});
}

class SupplierPageUpdateButtonClickedEvent extends SupplierPageEvent {
  final Supplier supplier;

  SupplierPageUpdateButtonClickedEvent({required this.supplier});
}
