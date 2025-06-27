import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:furniture_shop_wijaya/data/dto/customer/customer_dto.dart';
import 'package:furniture_shop_wijaya/data/dto/sales/sales_item_dto.dart';
import 'package:furniture_shop_wijaya/services/receipt_service.dart';

part 'sales_page_event.dart';
part 'sales_page_state.dart';

class SalesPageBloc extends Bloc<SalesPageEvent, SalesPageState> {
  SalesPageBloc() : super(SalesPageInitial()) {
    on<SalesPageInitialFetchEvent>(salesPageInitialFetchEvent);
    on<SalesPageFormInitialFetchEvent>(salesPageFormInitialFetchEvent);
    on<SalesPageSummaryDataFetchEvent>(salesPageSummaryInitialFetchEvent);
    on<AddSalesItemEvent>(addSalesItemEvent);
    on<SalesPagePrintInvoiceEvent>(salesPagePrintInvoiceEvent);
  }

  FutureOr<void> salesPageFormInitialFetchEvent(
      SalesPageFormInitialFetchEvent event, Emitter<SalesPageState> emit) {
    emit(SalesPageFormInitialFetchLoadingState());
    emit(SalesPageFormInitialFetchSuccessState());
  }

  FutureOr<void> salesPageSummaryInitialFetchEvent(
      SalesPageSummaryDataFetchEvent event, Emitter<SalesPageState> emit) {
    emit(SalesPageSummaryDataFetchLoadingState());
    emit(SalesPageSummaryDataFetchSuccessState(
      salesItems: event.salesItems,
    ));
  }

  FutureOr<void> addSalesItemEvent(
      AddSalesItemEvent event, Emitter<SalesPageState> emit) {
    SalesPageBloc()
        .add(SalesPageInitialFetchEvent(salesItems: event.salesItems));
  }

  FutureOr<void> salesPageInitialFetchEvent(
      SalesPageInitialFetchEvent event, Emitter<SalesPageState> emit) {
    emit(SalesPageInitialFetchSuccessState(salesItems: event.salesItems));

    // emit(SalesPageInitialFetchLoadingState());
  }

  Future<FutureOr<void>> salesPagePrintInvoiceEvent(
      SalesPagePrintInvoiceEvent event, Emitter<SalesPageState> emit) async {
    emit(SalesPagePrintInvoiceLoadingState());

    // double total = 0;
    // for (var element in event.salesItems) {
    //   total += (element.price * element.quantity);
    // }

    final invoiceGeneratedResult = await Receipt().generateReceipt(
        event.salesItems, event.customerData, event.total, event.discount);

    if (invoiceGeneratedResult.isGenerationSuccess) {
      Receipt().saveReceiptMetadata(invoiceGeneratedResult.invoiceMetaData!);
      emit(SalesPageInvoiceGenerationSuccessState());
      Receipt().printReceipt(invoiceGeneratedResult.pdfBytes!);
    } else {
      emit(SalesPageInvoiceGenerationErrorState());
    }
  }
}
