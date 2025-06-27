import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/data/dto/item/item_dto.dart';
import 'package:furniture_shop_wijaya/data/dto/item/item_update_dto.dart';
import 'package:furniture_shop_wijaya/data/models/category/category.dart';
import 'package:furniture_shop_wijaya/data/models/item/item.dart';
import 'package:furniture_shop_wijaya/data/models/supplier/supplier.dart';
import 'package:furniture_shop_wijaya/data/repository/item_repository/item_repository.dart';
import 'package:furniture_shop_wijaya/data/repository/settings_repository/settings_repository.dart';

import '../../search/bloc/search_bloc_bloc.dart';

part 'item_page_bloc_event.dart';
part 'item_page_bloc_state.dart';

class ItemPageBlocBloc extends Bloc<ItemPageBlocEvent, ItemPageBlocState> {
  ItemRepository itemRepository = ItemRepository();
  late BuildContext buildContext;
  late SearchBlocBloc searchBlocBloc;

  ItemPageBlocBloc() : super(ItemPageBlocInitial()) {
    on<ItemPageInitialFetchEvent>(itemPageInitialFetchEvent);
    on<ItemPageSavedButtonClickedEvent>(itemPageSavedButtonClickedEvent);
    on<ItemPageUpdateButtonClickedEvent>(itemPageUpdateButtonClickedEvent);
    on<ItemPageTileClickedEvent>(itemPageTileClickedEvent);
    on<ItemPageDeleteCheckEvent>(itemPageDeleteCheckEvent);
    on<ItemPageDeleteButtonClickedEvent>(itemPageDeleteButtonClickedEvent);
    on<ItemPagePriceEditRequestEvent>(itemPagePriceEditRequestEvent);
  }

  FutureOr<void> itemPageInitialFetchEvent(
      ItemPageInitialFetchEvent event, Emitter<ItemPageBlocState> emit) async {
    emit(ItemPageLoadingState());
    buildContext = event.buildContext;
    searchBlocBloc = BlocProvider.of<SearchBlocBloc>(buildContext);
    var itemList = await itemRepository.getAllItems();
    var supplierList = await itemRepository.getAllSuppliers();
    var categoryList = await itemRepository.getAllCategories();

    emit(ItemPageLoadingSucessState(
        itemList: itemList,
        supplierList: supplierList,
        categoryList: categoryList));

    searchBlocBloc
        // ignore: invalid_use_of_visible_for_testing_member
        .emit(ItemPageSearchDataLoadingSucessState(itemList: itemList));
  }

  FutureOr<void> itemPageSavedButtonClickedEvent(
      ItemPageSavedButtonClickedEvent event,
      Emitter<ItemPageBlocState> emit) async {
    String url = await itemRepository
        .uploadItemImageToStorage(event.item.selectedImageInBytes!);

    ItemDTO itemDTO = ItemDTO(
      itemName: event.item.itemName,
      itemCode: event.item.itemCode,
      categoryName: event.item.categoryName,
      supplierName: event.item.supplierName,
      itemBoughtPrice: event.item.itemBoughtPrice,
      itemSellingPrice: event.item.itemSellingPrice,
      discountPrice: event.item.discountPrice,
      numItems: event.item.numItems,
      datePurchased: event.item.datePurchased,
      warrantyExpiryDate: event.item.warrantyExpiryDate,
      itemLength: event.item.itemLength,
      itemWidth: event.item.itemWidth,
      itemWeight: event.item.itemWeight,
      itemImageUrl: url,
    );

    bool isSaved = await itemRepository.saveDataItem(itemDTO.toJson());

    isSaved
        ? emit(ItemPageItemSavedSuccessActionState())
        : emit(ItemPageItemSavedErrorActionState());
  }

  FutureOr<void> itemPageTileClickedEvent(
      ItemPageTileClickedEvent event, Emitter<ItemPageBlocState> emit) async {
    // var itemList = await itemRepository.getAllItems();
    // var supplierList = await itemRepository.getAllSuppliers();
    // var categoryList = await itemRepository.getAllCategories();
    // emit(ItemPagePriceNotEditableState());
    emit(ItemPageSetUpdatePageState(
      item: event.item,
      // categoryList: categoryList,
      // itemList: itemList,
      // supplierList: supplierList,
    ));
  }

  FutureOr<void> itemPageDeleteCheckEvent(
      ItemPageDeleteCheckEvent event, Emitter<ItemPageBlocState> emit) {
    emit(ItemDeleteCheckEventActionState(item: event.item));
  }

  FutureOr<void> itemPageDeleteButtonClickedEvent(
      ItemPageDeleteButtonClickedEvent event,
      Emitter<ItemPageBlocState> emit) async {
    emit(ItemDeletingState());

    bool isDeleted =
        await itemRepository.deleteItem(event.item.id, event.item.itemImageUrl);

    isDeleted
        ? emit(ItemDeleteSucessActionState())
        : emit(ItemDeleteErrorActionState());
  }

  Future<FutureOr<void>> itemPagePriceEditRequestEvent(
      ItemPagePriceEditRequestEvent event,
      Emitter<ItemPageBlocState> emit) async {
    String securityPass = await SettingsRepository().getAdminPassword();
    if (event.enteredPassword == securityPass) {
      emit(ItemPagePriceEditRequestState(true));
    } else {
      emit(ItemPagePriceEditRequestState(false));
    }
  }

  Future<FutureOr<void>> itemPageUpdateButtonClickedEvent(
      ItemPageUpdateButtonClickedEvent event,
      Emitter<ItemPageBlocState> emit) async {
    ItemUpdateDTO itemUpdateDTO = event.item;
    bool isSaved =
        await itemRepository.updateItem(itemUpdateDTO.toJson(), event.item.id);

    isSaved
        ? emit(ItemPageItemUpdatedSuccessActionState())
        : emit(ItemPageItemUpdatedErrorActionState());
  }
}
