part of 'sales_page_bloc.dart';

@immutable
sealed class SalesPageState {
  const SalesPageState();

  List<Object?> get props => [];
}

final class SalesPageActionState extends SalesPageState {}

final class SalesPageInitial extends SalesPageState {}

final class SalesPageInitialFetchLoadingState extends SalesPageState {}

final class SalesPageInitialFetchSuccessState extends SalesPageState {
  // final bool isOnlinePurchased = true;
  final List<SalesItemDTO> salesItems;

  const SalesPageInitialFetchSuccessState({required this.salesItems});

  @override
  List<Object?> get props => [salesItems];
}

final class SalesPageFormInitialFetchLoadingState extends SalesPageState {}

final class SalesPageFormInitialFetchSuccessState extends SalesPageState {
  final bool isOnlinePurchased = true;
}

final class SalesPageSummaryDataFetchLoadingState extends SalesPageState {}

final class SalesPageSummaryDataFetchSuccessState extends SalesPageState {
  final List<SalesItemDTO> salesItems;

  const SalesPageSummaryDataFetchSuccessState({required this.salesItems});

  @override
  List<Object?> get props => [salesItems];
}

final class SalesPagePrintInvoiceLoadingState extends SalesPageActionState {}

final class SalesPageInvoiceGenerationSuccessState
    extends SalesPageActionState {}

final class SalesPageInvoiceGenerationErrorState extends SalesPageActionState {}
