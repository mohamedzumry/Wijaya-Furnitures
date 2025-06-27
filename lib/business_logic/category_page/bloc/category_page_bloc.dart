import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/dto/category/category_dto.dart';
import '../../../data/models/category/category.dart';
import '../../../data/repository/category_repository/category_repository.dart';
import '../../search/bloc/search_bloc_bloc.dart';

part 'category_page_event.dart';
part 'category_page_state.dart';

class CategoryPageBloc extends Bloc<CategoryPageEvent, CategoryPageState> {
  CategoryRepository categoryRepository = CategoryRepository();

  late BuildContext buildContext;
  late SearchBlocBloc searchBlocBloc;

  CategoryPageBloc() : super(CategoryPageInitial()) {
    on<CategoryPageInitialFetchEvent>(categoryPageInitialFetchEvent);
    on<CategoryPageNewCategorySaveButtonClickedEvent>(
        categoryPageNewCategorySaveButtonClickedEvent);
    on<CategoryPageTileClickedEvent>(categoryPageTileClickedEvent);
    on<CategoryPageUpdateButtonClickedEvent>(
        categoryPageUpdateButtonClickedEvent);
    on<CategoryPageDeleteCheckEvent>(categoryPageDeleteCheckEvent);
    on<CategoryPageDeleteButtonClickedEvent>(
        categoryPageDeleteButtonClickedEvent);
  }

  FutureOr<void> categoryPageInitialFetchEvent(
      CategoryPageInitialFetchEvent event,
      Emitter<CategoryPageState> emit) async {
    buildContext = event.buildContext;
    searchBlocBloc = BlocProvider.of<SearchBlocBloc>(buildContext);
    emit(CategoryPageLoadingState());
    var categoryList = await categoryRepository.getAllCategories();
    emit(CategoryPageLoadingSucessState(categoryList: categoryList));
    // ignore: invalid_use_of_visible_for_testing_member
    searchBlocBloc.emit(
        CategoryPageSearchDataLoadingSucessState(categoryList: categoryList));
  }

  FutureOr<void> categoryPageNewCategorySaveButtonClickedEvent(
      CategoryPageNewCategorySaveButtonClickedEvent event,
      Emitter<CategoryPageState> emit) async {
    if (event.categoryList.any(
        (element) => element.categoryName == event.categoryType.categoryName)) {
      emit(CategoryPageNewCategoryAddedAlreadyExistErrorActionState());
      return;
    }
    bool isSaved = await categoryRepository
        .saveCategoryDetails(event.categoryType.toJson());
    if (isSaved) {
      emit(CategoryPageNewCategoryAddedSuccessActionState());
    } else {
      emit(CategoryPageNewCategoryAddedErrorActionState());
    }
  }

  FutureOr<void> categoryPageTileClickedEvent(
      CategoryPageTileClickedEvent event,
      Emitter<CategoryPageState> emit) async {
    var categoryList = await categoryRepository.getAllCategories();
    emit(CategoryPageSetUpdatePageState(
        categoryList: categoryList, categoryType: event.categoryType));
  }

  FutureOr<void> categoryPageUpdateButtonClickedEvent(
      CategoryPageUpdateButtonClickedEvent event,
      Emitter<CategoryPageState> emit) async {
    final isAssigned =
        await categoryRepository.isCategoryAssigned(event.currentCategoryName);

    if (isAssigned == false) {
      bool isUpdated =
          await categoryRepository.updateCategory(event.categoryType);
      isUpdated
          ? emit(CategoryPageCategoryUpdatedSucessActionState())
          : emit(CategoryPageCategoryUpdatedErrorActionState());
      return;
    } else {
      emit(CategoryAlreadyAssignedUpdateBlockedActionState());
    }
  }

  FutureOr<void> categoryPageDeleteCheckEvent(
      CategoryPageDeleteCheckEvent event, Emitter<CategoryPageState> emit) {
    emit(CategoryDeleteCheckEventActionState(categoryType: event.categoryType));
  }

  FutureOr<void> categoryPageDeleteButtonClickedEvent(
      CategoryPageDeleteButtonClickedEvent event,
      Emitter<CategoryPageState> emit) async {
    final isAssigned = await categoryRepository
        .isCategoryAssigned(event.categoryType.categoryName);

    if (isAssigned == false) {
      bool isDeleted =
          await categoryRepository.deleteCategory(event.categoryType.id);
      isDeleted
          ? emit(CategoryDeleteSucessActionState())
          : emit(CategoryDeleteErrorActionState());
      return;
    } else {
      emit(CategoryAlreadyAssignedActionState());
    }
  }
}
