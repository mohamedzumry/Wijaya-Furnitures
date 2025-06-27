part of 'category_page_bloc.dart';

@immutable
sealed class CategoryPageEvent {}

class CategoryPageInitialFetchEvent extends CategoryPageEvent {
  final BuildContext buildContext;

  CategoryPageInitialFetchEvent({required this.buildContext});
}

class CategoryPageNewCategorySaveButtonClickedEvent extends CategoryPageEvent {
  final CategoryTypeDTO categoryType;
  final List<CategoryType> categoryList;

  CategoryPageNewCategorySaveButtonClickedEvent(
      {required this.categoryType, required this.categoryList});
}

class CategoryPageTileClickedEvent extends CategoryPageEvent {
  final CategoryType categoryType;

  CategoryPageTileClickedEvent({required this.categoryType});
}

class CategoryPageUpdateButtonClickedEvent extends CategoryPageEvent {
  final String currentCategoryName;
  final CategoryType categoryType;

  CategoryPageUpdateButtonClickedEvent(
      {required this.currentCategoryName, required this.categoryType});
}

class CategoryPageDeleteButtonClickedEvent extends CategoryPageEvent {
  final CategoryType categoryType;

  CategoryPageDeleteButtonClickedEvent({required this.categoryType});
}

class CategoryPageDeleteCheckEvent extends CategoryPageEvent {
  final CategoryType categoryType;
  CategoryPageDeleteCheckEvent({required this.categoryType});
}
