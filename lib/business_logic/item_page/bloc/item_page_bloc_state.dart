part of 'item_page_bloc_bloc.dart';

@immutable
sealed class ItemPageBlocState {}

sealed class ItemPageBlocActionState extends ItemPageBlocState {}

final class ItemPageBlocInitial extends ItemPageBlocState {}

class ItemPageLoadingState extends ItemPageBlocState {}

class ItemPageLoadingSucessState extends ItemPageBlocState {
  final List<Item> itemList;
  final List<Supplier> supplierList;
  final List<CategoryType> categoryList;

  ItemPageLoadingSucessState(
      {required this.categoryList,
      required this.supplierList,
      required this.itemList});
}

class ItemPageLoadingErrorState extends ItemPageBlocState {}

class ItemPageItemSavedSuccessActionState extends ItemPageBlocActionState {}

class ItemPageItemSavedErrorActionState extends ItemPageBlocActionState {}

class ItemPageItemUpdatedSuccessActionState extends ItemPageBlocActionState {}

class ItemPageItemUpdatedErrorActionState extends ItemPageBlocActionState {}

class ItemPageSetUpdatePageState extends ItemPageBlocState {
  // final List<Item> itemList;
  // final List<Supplier> supplierList;
  // final List<CategoryType> categoryList;
  final Item item;

  ItemPageSetUpdatePageState(
      {
      //   required this.supplierList,
      // required this.categoryList,
      // required this.itemList,
      required this.item});
}

// class ItemPagePriceNotEditableState extends ItemPageBlocActionState {}

class ItemDeleteCheckEventActionState extends ItemPageBlocActionState {
  final Item item;

  ItemDeleteCheckEventActionState({required this.item});
}

class ItemDeletingState extends ItemPageBlocActionState {}

class ItemDeleteSucessActionState extends ItemPageBlocActionState {}

class ItemDeleteErrorActionState extends ItemPageBlocActionState {}

class ItemPagePriceEditRequestState extends ItemPageBlocActionState {
  final bool isAccessGranted;

  ItemPagePriceEditRequestState(this.isAccessGranted);
}
