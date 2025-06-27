part of 'receipts_page_bloc.dart';

sealed class ReceiptsPageState extends Equatable {
  const ReceiptsPageState();

  @override
  List<Object> get props => [];
}

final class ReceiptsPageInitial extends ReceiptsPageState {}

sealed class ReceiptsPageActionState extends ReceiptsPageState {}

final class ReceiptsPageLoadingState extends ReceiptsPageState {}

final class ReceiptsPageLoadedState extends ReceiptsPageState {
  final Stream<List<InvoiceMetaDataModel>> invoices;

  const ReceiptsPageLoadedState(this.invoices);

  @override
  List<Object> get props => [invoices];
}

final class ReceiptsPageDeleteReceiptSuccessState
    extends ReceiptsPageActionState {}

final class ReceiptsPageDeleteReceiptFailedState
    extends ReceiptsPageActionState {}
