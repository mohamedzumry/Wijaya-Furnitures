part of 'receipts_page_bloc.dart';

sealed class ReceiptsPageEvent extends Equatable {
  const ReceiptsPageEvent();

  @override
  List<Object> get props => [];
}

class ReceiptsPageInitialEvent extends ReceiptsPageEvent {}

class ReceiptsPageDeleteReceiptEvent extends ReceiptsPageEvent {
  final String invoiceNumber;

  const ReceiptsPageDeleteReceiptEvent(this.invoiceNumber);

  @override
  List<Object> get props => [invoiceNumber];
}
