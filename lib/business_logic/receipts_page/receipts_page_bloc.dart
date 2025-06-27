import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:furniture_shop_wijaya/data/models/sales/invoice_metadata_model.dart';
import 'package:furniture_shop_wijaya/data/repository/receipts_repository/receipts_repository.dart';

part 'receipts_page_event.dart';
part 'receipts_page_state.dart';

class ReceiptsPageBloc extends Bloc<ReceiptsPageEvent, ReceiptsPageState> {
  final ReceiptsRepository receiptsRepository = ReceiptsRepository();
  ReceiptsPageBloc() : super(ReceiptsPageInitial()) {
    on<ReceiptsPageEvent>((event, emit) {});
    on<ReceiptsPageInitialEvent>((event, emit) {
      emit(ReceiptsPageLoadingState());
      final receipts = receiptsRepository.getAllInvoices();
      emit(ReceiptsPageLoadedState(receipts));
    });
    on<ReceiptsPageDeleteReceiptEvent>((event, emit) {
      emit(ReceiptsPageLoadingState());
      final res = receiptsRepository.deleteInvoice(event.invoiceNumber);
      if (res == true) {
        emit(ReceiptsPageDeleteReceiptSuccessState());
      } else {
        emit(ReceiptsPageDeleteReceiptFailedState());
      }
    });
  }
}
