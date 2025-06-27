part of 'sales_page_bloc.dart';

@immutable
sealed class SalesPageEvent {
  const SalesPageEvent();

  List<Object?> get props => [];
}

class SalesPageInitialFetchEvent extends SalesPageEvent {
  final List<SalesItemDTO> salesItems;

  const SalesPageInitialFetchEvent({required this.salesItems});
}

class SalesPageFormInitialFetchEvent extends SalesPageEvent {}

class SalesPageSummaryDataFetchEvent extends SalesPageEvent {
  final List<SalesItemDTO> salesItems;

  const SalesPageSummaryDataFetchEvent({required this.salesItems});

  @override
  List<Object?> get props => [salesItems];
}

class AddSalesItemEvent extends SalesPageEvent {
  final List<SalesItemDTO> salesItems;

  const AddSalesItemEvent({required this.salesItems});
}

class RemoveSalesItemEvent extends SalesPageEvent {
  final List<SalesItemDTO> salesItems;

  const RemoveSalesItemEvent({required this.salesItems});
}

class SalesPagePrintInvoiceEvent extends SalesPageEvent {
  final List<SalesItemDTO> salesItems;
  final double total;
  final double discount;
  // final bool isOnlinePurchase;
  final CustomerTypeDTO customerData;

  const SalesPagePrintInvoiceEvent({
    required this.salesItems,
    required this.total,
    required this.discount,
    // required this.isOnlinePurchase,
    required this.customerData,
  });

  @override
  List<Object?> get props => [salesItems, customerData, total, discount];
}
