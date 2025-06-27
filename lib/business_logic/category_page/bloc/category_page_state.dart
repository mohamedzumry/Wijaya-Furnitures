part of 'category_page_bloc.dart';

@immutable
sealed class CategoryPageState {}

sealed class CategoryPageSActiontate extends CategoryPageState {}

final class CategoryPageInitial extends CategoryPageState {}

class CategoryPageLoadingState extends CategoryPageState {}

class CategoryPageLoadingSucessState extends CategoryPageState {
  final List<CategoryType> categoryList;

  CategoryPageLoadingSucessState({required this.categoryList});
}

class CategoryPageLoadingErrorState extends CategoryPageState {}

class CategoryPageNewCategoryAddedSuccessActionState
    extends CategoryPageSActiontate {}

class CategoryPageNewCategoryAddedAlreadyExistErrorActionState
    extends CategoryPageSActiontate {}

class CategoryPageNewCategoryAddedErrorActionState
    extends CategoryPageSActiontate {}

class CategoryPageSetUpdatePageState extends CategoryPageState {
  final List<CategoryType> categoryList;
  final CategoryType categoryType;

  CategoryPageSetUpdatePageState(
      {required this.categoryList, required this.categoryType});
}

class CategoryPageCategoryUpdatedSucessActionState
    extends CategoryPageSActiontate {}

class CategoryAlreadyAssignedUpdateBlockedActionState
    extends CategoryPageSActiontate {}

class CategoryPageCategoryUpdatedErrorActionState
    extends CategoryPageSActiontate {}

class CategoryDeleteCheckEventActionState extends CategoryPageSActiontate {
  final CategoryType categoryType;

  CategoryDeleteCheckEventActionState({required this.categoryType});
}

class CategoryDeleteSucessActionState extends CategoryPageSActiontate {}

class CategoryAlreadyAssignedActionState extends CategoryPageSActiontate {}

class CategoryDeleteErrorActionState extends CategoryPageSActiontate {}
