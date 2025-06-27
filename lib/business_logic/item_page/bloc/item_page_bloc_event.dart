part of 'item_page_bloc_bloc.dart';

@immutable
sealed class ItemPageBlocEvent {}

class ItemPageInitialFetchEvent extends ItemPageBlocEvent {
  final BuildContext buildContext;

  ItemPageInitialFetchEvent({required this.buildContext});
}

class ItemPageSavedButtonClickedEvent extends ItemPageBlocEvent {
  final ItemDTO item;

  ItemPageSavedButtonClickedEvent({required this.item});
}

class ItemPageUpdateButtonClickedEvent extends ItemPageBlocEvent {
  final ItemUpdateDTO item;

  ItemPageUpdateButtonClickedEvent({required this.item});
}

class ItemPageTileClickedEvent extends ItemPageBlocEvent {
  final Item item;

  ItemPageTileClickedEvent({required this.item});
}

class ItemPageDeleteCheckEvent extends ItemPageBlocEvent {
  final Item item;
  ItemPageDeleteCheckEvent({required this.item});
}

class ItemPageDeleteButtonClickedEvent extends ItemPageBlocEvent {
  final Item item;

  ItemPageDeleteButtonClickedEvent({required this.item});
}

class ItemPagePriceEditRequestEvent extends ItemPageBlocEvent {
  final String enteredPassword;

  ItemPagePriceEditRequestEvent(this.enteredPassword);
}
