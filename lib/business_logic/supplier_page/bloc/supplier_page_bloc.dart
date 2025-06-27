import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/search/bloc/search_bloc_bloc.dart';
import 'package:furniture_shop_wijaya/data/models/supplier/supplier.dart';
import 'package:furniture_shop_wijaya/data/repository/supplier_repository/supplier_repository.dart';

import '../../../data/dto/supplier/supplier_dto.dart';

part 'supplier_page_event.dart';
part 'supplier_page_state.dart';

class SupplierPageBloc extends Bloc<SupplierPageEvent, SupplierPageState> {
  SupplierRepository supplierRepository = SupplierRepository();
  late BuildContext buildContext;
  late SearchBlocBloc searchBlocBloc;

  SupplierPageBloc() : super(SupplierPageInitial()) {
    on<SupplierPageInitialFetchEvent>(supplierPageInitialFetchEvent);
    on<SupplierPageSaveButtonClickedEvent>(supplierPageSaveButtonClickedEvent);
    on<SupplierPageTileClickedEvent>(supplierPageTileClickedEvent);
    on<SupplierPageDeleteCheckEvent>(supplierPageDeleteCheckEvent);
    on<SupplierPageUpdateButtonClickedEvent>(
        supplierPageUpdateButtonClickedEvent);
    on<SupplierPageDeleteButtonClickedEvent>(
        supplierPageDeleteButtonClickedEvent);
  }

  Future<FutureOr<void>> supplierPageInitialFetchEvent(
      SupplierPageInitialFetchEvent event,
      Emitter<SupplierPageState> emit) async {
    buildContext = event.buildContext;
    searchBlocBloc = BlocProvider.of<SearchBlocBloc>(buildContext);
    emit(SupplierPageLoadingState());
    var supplierList = await supplierRepository.getAllSuppliers();
    emit(SupplierPageLoadingSuccessState(supplierList: supplierList));
    // ignore: invalid_use_of_visible_for_testing_member
    searchBlocBloc.emit(
        SupplierPageSearchDataLoadingSucessState(supplierList: supplierList));
  }

  Future<FutureOr<void>> supplierPageSaveButtonClickedEvent(
      SupplierPageSaveButtonClickedEvent event,
      Emitter<SupplierPageState> emit) async {
    if (event.supplierList.any(
        (element) => element.supplierName == event.supplierDTO.supplierName)) {
      emit(SupplierPageNewSupplierAddedAlreadyExistErrorActionState());
    } else {
      bool isSaved = await supplierRepository
          .saveSupplierDetails(event.supplierDTO.toJson());
      if (isSaved) {
        emit(SupplierPageNewSupplierSavedSucessActionState());
      } else {
        emit(SupplierPageNewSupplierSavedErrorActionState());
      }
    }
  }

  FutureOr<void> supplierPageTileClickedEvent(
      SupplierPageTileClickedEvent event,
      Emitter<SupplierPageState> emit) async {
    var supplierList = await supplierRepository.getAllSuppliers();
    emit(SupplierPageSetUpdatePageState(
        supplier: event.supplier, supplierList: supplierList));
  }

  FutureOr<void> supplierPageDeleteCheckEvent(
      SupplierPageDeleteCheckEvent event, Emitter<SupplierPageState> emit) {
    emit(SupplierDeleteCheckEventActionState(supplier: event.supplier));
  }

  FutureOr<void> supplierPageDeleteButtonClickedEvent(
      SupplierPageDeleteButtonClickedEvent event,
      Emitter<SupplierPageState> emit) async {
    final isAssigned = await supplierRepository
        .isSupplierAssigned(event.supplier.supplierName);

    if (isAssigned == false) {
      bool isDeleted =
          await supplierRepository.deleteSupplier(event.supplier.supplierId);
      isDeleted
          ? emit(SupplierDeleteSucessActionState())
          : emit(SupplierDeleteErrorActionState());
    } else {
      emit(SupplierAlreadyAssignedActionState());
    }
  }

  FutureOr<void> supplierPageUpdateButtonClickedEvent(
      SupplierPageUpdateButtonClickedEvent event,
      Emitter<SupplierPageState> emit) async {
    bool isUpdated = await supplierRepository.updateSupplier(event.supplier);
    isUpdated
        ? emit(SupplierPageSupplierUpdatedSucessActionState())
        : emit(SupplierPageSupplierUpdatedErrorActionState());
  }
}
