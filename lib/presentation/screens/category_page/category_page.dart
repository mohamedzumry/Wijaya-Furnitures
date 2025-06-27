import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/data/models/category/category.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:furniture_shop_wijaya/business_logic/category_page/bloc/category_page_bloc.dart';
import 'package:furniture_shop_wijaya/presentation/widgets/category_page_tile/category_page_tile.dart';

import '../../../business_logic/search/bloc/search_bloc_bloc.dart';
import '../../../data/dto/category/category_dto.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late CategoryPageBloc categoryPageBloc;
  late SearchBlocBloc searchBlocBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController categoryNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    categoryPageBloc = BlocProvider.of<CategoryPageBloc>(context);
    searchBlocBloc = BlocProvider.of<SearchBlocBloc>(context);
    categoryPageBloc.add(CategoryPageInitialFetchEvent(buildContext: context));
    super.initState();
  }

  void setInitialValuesForUpdate(CategoryType categoryType) {
    categoryNameController.text = categoryType.categoryName;
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, CategoryType categoryType) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
              'Are you sure you want to Delete this Category?\nCategory Name: ${categoryType.categoryName}'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                categoryPageBloc.add(CategoryPageDeleteButtonClickedEvent(
                    categoryType: categoryType));
              },
            ),
          ],
        );
      },
    );
  }

  _refreshPage() {
    categoryPageBloc.add(CategoryPageInitialFetchEvent(buildContext: context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryPageBloc, CategoryPageState>(
      bloc: categoryPageBloc,
      listenWhen: (previous, current) => current is CategoryPageSActiontate,
      buildWhen: (previous, current) => current is! CategoryPageSActiontate,
      listener: (context, state) {
        if (state is CategoryPageNewCategoryAddedSuccessActionState) {
          clearData();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('New Category is added. Data saved successfully.')));
          _refreshPage();
        } else if (state is CategoryPageNewCategoryAddedErrorActionState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Error occured!, Data is not saved successfullu!')));
        } else if (state is CategoryPageCategoryUpdatedSucessActionState) {
          clearData();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Category is updated successfully.')));
          _refreshPage();
        } else if (state is CategoryPageCategoryUpdatedErrorActionState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Error occured!, Category is not updated successfully!')));
        } else if (state is CategoryDeleteCheckEventActionState) {
          _showConfirmationDialog(context, state.categoryType);
        } else if (state is CategoryDeleteSucessActionState) {
          clearData();
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Category is deleted')));
          _refreshPage();
        } else if (state is CategoryAlreadyAssignedActionState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category is assigned to an item. Cannot delete!'),
            ),
          );
        } else if (state is CategoryDeleteErrorActionState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Error occured!, Category is not deleted successfully!'),
            ),
          );
        } else if (state
            is CategoryPageNewCategoryAddedAlreadyExistErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Category Name already exist!'),
            ),
          );
        } else if (state is CategoryAlreadyAssignedUpdateBlockedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Category update blocked as item is already assigned!'),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (CategoryPageLoadingState):
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.red, size: 50),
            );
          case const (CategoryPageLoadingSucessState):
            final categoryLoadedState = state as CategoryPageLoadingSucessState;
            final allCategories = categoryLoadedState.categoryList;
            return Scaffold(
              backgroundColor: Colors.blueGrey[50],
              body: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Categories',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Suppliers Unite: Streamline Your Sourcing',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  151, 151, 151, 1),
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        width: 250,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              offset: Offset(0, 4),
                                              blurRadius: 2,
                                              color: Colors.grey,
                                            )
                                          ],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: TextField(
                                          controller: searchController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Search here...',
                                          ),
                                          onChanged: (query) {
                                            searchBlocBloc.add(
                                                CategorySearchBarValueChangedEvent(
                                                    searchQuery: query));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.569555,
                              height:
                                  MediaQuery.of(context).size.height * 0.7792,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0,
                                    offset: Offset(0, 4),
                                    blurRadius: 2,
                                    color: Colors.grey,
                                  )
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child:
                                  BlocConsumer<SearchBlocBloc, SearchBlocState>(
                                bloc: searchBlocBloc,
                                listenWhen: (previous, current) =>
                                    current is SearchBlocActionState,
                                buildWhen: (previous, current) =>
                                    current is! SearchBlocActionState,
                                listener: (context, state) {},
                                builder: (context, state) {
                                  switch (state.runtimeType) {
                                    case const (CategoryPageSearchDataLoadingSucessState):
                                      final successState = state
                                          as CategoryPageSearchDataLoadingSucessState;
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: successState
                                                    .categoryList.length,
                                                itemBuilder: (context, index) {
                                                  return CategoryPageTile(
                                                    categoryType: successState
                                                        .categoryList[index],
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    default:
                                      return const SizedBox();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.23,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 15, right: 10, bottom: 30),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('New Categories',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text('Add New Category Details Here.',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  151, 151, 151, 1),
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  Icon(Icons.line_style, color: Colors.black)
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Basic Info',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(151, 151, 151, 1),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700)),
                                  Text(
                                      DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10))
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text('Category Name',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11)),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 13,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: categoryNameController,
                                    maxLength: 50,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Category Name is required!!!';
                                      } else if (!RegExp(r'^[a-zA-Z0-9\s]+$')
                                          .hasMatch(value)) {
                                        return 'Category Name can have only letters, digits and spaces';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      hintText: 'Ex: Tables',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(170, 50),
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            const Color(0xFF1EA7DD),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)))),
                                    onPressed: () {
                                      if (_submitForm() == 1) {
                                        CategoryTypeDTO categoryType =
                                            CategoryTypeDTO(
                                                categoryName:
                                                    categoryNameController
                                                        .text);
                                        categoryPageBloc.add(
                                          CategoryPageNewCategorySaveButtonClickedEvent(
                                            categoryType: categoryType,
                                            categoryList: allCategories,
                                          ),
                                        );
                                        clearData();
                                      }
                                    },
                                    child: const Center(
                                      child: Text('Save',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(100, 50),
                                        foregroundColor:
                                            const Color(0xFF1EA7DD),
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)))),
                                    onPressed: () {
                                      clearData();
                                    },
                                    child: const Center(
                                      child: Text('Reset',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          case const (CategoryPageSetUpdatePageState):
            final successState = state as CategoryPageSetUpdatePageState;
            setInitialValuesForUpdate(successState.categoryType);
            return Scaffold(
              backgroundColor: Colors.blueGrey[50],
              body: Center(
                child: Row(
                  children: [
                    Expanded(
                      child: Center(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 20, left: 20, right: 20, bottom: 50),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Categories',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Suppliers Unite: Streamline Your Sourcing',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  151, 151, 151, 1),
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        width: 250,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              spreadRadius: 0,
                                              offset: Offset(0, 4),
                                              blurRadius: 2,
                                              color: Colors.grey,
                                            )
                                          ],
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: TextField(
                                          controller: searchController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Search here...',
                                          ),
                                          onChanged: (query) {
                                            searchBlocBloc.add(
                                                CategorySearchBarValueChangedEvent(
                                                    searchQuery: query));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width:
                                  MediaQuery.of(context).size.width * 0.569555,
                              height:
                                  MediaQuery.of(context).size.height * 0.7792,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    spreadRadius: 0,
                                    offset: Offset(0, 4),
                                    blurRadius: 2,
                                    color: Colors.grey,
                                  )
                                ],
                                borderRadius: BorderRadius.all(
                                  Radius.circular(15),
                                ),
                              ),
                              child:
                                  BlocConsumer<SearchBlocBloc, SearchBlocState>(
                                bloc: searchBlocBloc,
                                listenWhen: (previous, current) =>
                                    current is SearchBlocActionState,
                                buildWhen: (previous, current) =>
                                    current is! SearchBlocActionState,
                                listener: (context, state) {},
                                builder: (context, state) {
                                  switch (state.runtimeType) {
                                    case const (CategoryPageSearchDataLoadingSucessState):
                                      final successState = state
                                          as CategoryPageSearchDataLoadingSucessState;
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: successState
                                                    .categoryList.length,
                                                itemBuilder: (context, index) {
                                                  return CategoryPageTile(
                                                    categoryType: successState
                                                        .categoryList[index],
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    default:
                                      return const SizedBox();
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.23,
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 20, left: 15, right: 10, bottom: 30),
                        child: Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('Existing Categories',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text('Update Category Details Here.',
                                          style: TextStyle(
                                              color: Color.fromRGBO(
                                                  151, 151, 151, 1),
                                              fontSize: 10,
                                              fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      clearData();
                                      categoryPageBloc.add(
                                          CategoryPageInitialFetchEvent(
                                              buildContext: context));
                                    },
                                    icon: const Icon(Icons.refresh,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Basic Info',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(151, 151, 151, 1),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700)),
                                  Text(
                                      DateFormat('dd MMMM yyyy')
                                          .format(DateTime.now()),
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.normal,
                                          fontSize: 10))
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text('Category Name',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11)),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.error,
                                        color: Colors.red,
                                        size: 13,
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: categoryNameController,
                                    maxLength: 50,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Category Name is required!!!';
                                      } else if (!RegExp(r'^[a-zA-Z0-9\s]+$')
                                          .hasMatch(value)) {
                                        return 'Category Name can contain only letters, digits and spaces';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      hintText: 'Ex: Tables',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size(170, 50),
                                        foregroundColor: Colors.white,
                                        backgroundColor:
                                            const Color(0xFF1EA7DD),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)))),
                                    onPressed: () {
                                      if (_submitForm() == 1) {
                                        CategoryType categoryType =
                                            CategoryType(
                                          id: successState.categoryType.id,
                                          categoryName:
                                              categoryNameController.text,
                                        );
                                        categoryPageBloc.add(
                                          CategoryPageUpdateButtonClickedEvent(
                                            currentCategoryName: successState
                                                .categoryType.categoryName,
                                            categoryType: categoryType,
                                          ),
                                        );
                                        clearData();
                                      }
                                    },
                                    child: const Center(
                                      child: Text('Update',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: const Size(100, 50),
                                      foregroundColor: const Color(0xFF1EA7DD),
                                      backgroundColor: Colors.white,
                                      shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                      ),
                                    ),
                                    onPressed: () {
                                      categoryPageBloc.add(
                                        CategoryPageDeleteCheckEvent(
                                          categoryType:
                                              successState.categoryType,
                                        ),
                                      );
                                    },
                                    child: const Center(
                                      child: Text('Delete',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal)),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          default:
            return const SizedBox();
        }
      },
    );
  }

  int _submitForm() {
    if (_formKey.currentState!.validate()) {
      return 1;
    } else {
      return 0;
    }
  }

  void clearData() {
    categoryNameController.clear();
  }
}
