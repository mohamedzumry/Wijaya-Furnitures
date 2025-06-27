import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/data/dto/item/item_update_dto.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:furniture_shop_wijaya/business_logic/item_page/bloc/item_page_bloc_bloc.dart';
import 'package:furniture_shop_wijaya/data/dto/item/item_dto.dart';
import 'package:furniture_shop_wijaya/data/models/category/category.dart';
import 'package:furniture_shop_wijaya/presentation/widgets/item_page_tile/item_page_tile.dart';
import '../../../business_logic/search/bloc/search_bloc_bloc.dart';
import '../../../data/models/item/item.dart';
import '../../../data/models/supplier/supplier.dart';

class ItemsPage extends StatefulWidget {
  final Stream<List<Item>> itemListStream;
  final Stream<List<CategoryType>> categoryListStream;
  final Stream<List<Supplier>> supplierListStream;
  const ItemsPage(
      {super.key,
      required this.itemListStream,
      required this.categoryListStream,
      required this.supplierListStream});

  @override
  State<ItemsPage> createState() => _ItemsPage2State();
}

class _ItemsPage2State extends State<ItemsPage> {
  late ItemPageBlocBloc itemPageBlocBloc;
  late SearchBlocBloc searchBlocBloc;

  late ItemUpdateDTO itemUpdateDTO;
  ItemDTO itemDTO = ItemDTO();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController itemNameController = TextEditingController();
  TextEditingController itemCodeController = TextEditingController();
  TextEditingController itemCountController = TextEditingController();
  TextEditingController itemPurchaseDateController = TextEditingController();
  TextEditingController itemExpiryDateController = TextEditingController();
  TextEditingController itemLengthController = TextEditingController();
  TextEditingController itemWidthController = TextEditingController();
  TextEditingController itemWeightController = TextEditingController();
  TextEditingController itemBoughtPriceController = TextEditingController();
  TextEditingController itemSellingPriceController = TextEditingController();
  TextEditingController itemDiscountPriceController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  // Timestamp? purchaseDate;
  // Timestamp? warrantyExpiryDate;

  String _imageFile = ''; // Variable to hold the selected image file
  Uint8List? selectedImageInBytes;

  String? selectedSupplierItem;
  String? selectedCategoryItem;
  String? updatedSupplierItem;
  String? updatedCategoryItem;

  bool isPriceEditable = false;
  bool isAdminAccessGranted = false;

  @override
  void initState() {
    itemPageBlocBloc = BlocProvider.of<ItemPageBlocBloc>(context);
    searchBlocBloc = BlocProvider.of<SearchBlocBloc>(context);
    itemPageBlocBloc.add(ItemPageInitialFetchEvent(buildContext: context));
    setInitialValues();
    super.initState();
  }

  void setInitialValues() {
    itemLengthController.text = '0';
    itemWidthController.text = '0';
    itemWeightController.text = '0';
  }

  void setInitialValuesForUpdate(Item item) {
    itemNameController.text = item.itemName;
    itemCodeController.text = item.itemCode;
    selectedSupplierItem = item.supplierName;
    selectedCategoryItem = item.categoryName;
    itemCountController.text = item.numItems.toString();
    itemLengthController.text = item.itemLength.toString();
    itemWidthController.text = item.itemWidth.toString();
    itemWeightController.text = item.itemWeight.toString();
    itemBoughtPriceController.text = item.itemBoughtPrice.toString();
    itemSellingPriceController.text = item.itemSellingPrice.toString();
    itemDiscountPriceController.text = item.discountPrice.toString();
    // itemCountController.text = item.item;

    isPriceEditable = false;
  }

  void showError(String errorMessage) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Error: $errorMessage")));
  }

  Future<FilePickerResult?> pickImage() async {
    FilePickerResult? fileResult;
    try {
      fileResult = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
    } catch (e) {
      showError("Error: $e");
    }
    return fileResult;
  }

  void showDeletingDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return const Text("Deleting ...");
      },
    );
  }

  List<DropdownMenuItem<String>> getSuppliersList(List<Supplier> list) {
    List<DropdownMenuItem<String>> supplierList = [];
    for (Supplier supplier in list) {
      DropdownMenuItem<String> dropdownItem = DropdownMenuItem(
        value: supplier.supplierName,
        child: Text(supplier.supplierName),
      );

      supplierList.add(dropdownItem);
    }
    return supplierList;
  }

  List<DropdownMenuItem<String>> getCategoryList(List<CategoryType> list) {
    List<DropdownMenuItem<String>> categoryList = [];
    for (CategoryType category in list) {
      DropdownMenuItem<String> dropdownItem = DropdownMenuItem(
        value: category.categoryName,
        child: Text(category.categoryName),
      );

      categoryList.add(dropdownItem);
    }
    return categoryList;
  }

  Future<void> _showConfirmationDialog(BuildContext context, Item item) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
              'Are you sure you want to Delete this Item?\nItem Name: ${item.itemName}\nItem Code : 0${item.itemCode}\nItem Count : 0${item.numItems}'),
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
                itemPageBlocBloc
                    .add(ItemPageDeleteButtonClickedEvent(item: item));
              },
            ),
          ],
        );
      },
    );
  }

  _makePriceEditable(BuildContext bc) {
    TextEditingController securityPasswordController = TextEditingController();
    return showDialog(
      context: bc,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Admin Access Required !!!'),
          content: SingleChildScrollView(
            child: TextFormField(
              keyboardType: TextInputType.number,
              controller: securityPasswordController,
              decoration: const InputDecoration(
                suffixIcon: Icon(Icons.store),
                labelText: 'Security Password',
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                securityPasswordController.dispose();
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
                itemPageBlocBloc.add(ItemPagePriceEditRequestEvent(
                    securityPasswordController.text));
                securityPasswordController.dispose();
              },
            ),
          ],
        );
      },
    );
  }

  _changePriceEditAccess() {
    setState(() {
      // isPriceEditable = true;
      isAdminAccessGranted = true;
      // debugPrint('Price Edit Access Granted !!! : $isAdminAccessGranted');
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ItemPageBlocBloc, ItemPageBlocState>(
      bloc: itemPageBlocBloc,
      listenWhen: (previous, current) => current is ItemPageBlocActionState,
      buildWhen: (previous, current) => current is! ItemPageBlocActionState,
      listener: (context, state) {
        if (state is ItemDeleteCheckEventActionState) {
          _showConfirmationDialog(context, state.item);
        } else if (state is ItemPageItemSavedSuccessActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('New Item is added. Data saved successfully.')));
          itemPageBlocBloc
              .add(ItemPageInitialFetchEvent(buildContext: context));
        } else if (state is ItemPageItemSavedErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Error occured!, Data is not saved successfullu!')));
        } else if (state is ItemDeletingState) {
          context.pop();
          showDeletingDialog(context);
        } else if (state is ItemDeleteSucessActionState) {
          context.pop();
          clearData();
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Item is deleted')));
          itemPageBlocBloc
              .add(ItemPageInitialFetchEvent(buildContext: context));
        } else if (state is ItemDeleteErrorActionState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Error occured!, Item is not deleted successfully!')));
        } else if (state is ItemPagePriceEditRequestState) {
          if (state.isAccessGranted == true) {
            _changePriceEditAccess();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Admin access granted ... '),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sorry, Access not granted ! '),
              ),
            );
          }
        } else if (state is ItemPageItemUpdatedSuccessActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Item updated successfully.')));
          itemPageBlocBloc
              .add(ItemPageInitialFetchEvent(buildContext: context));
        } else if (state is ItemPageItemUpdatedErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error occured!, Item update unsuccessful !!!')));
        }
      },
      builder: (context, state) {
        if (state is ItemPageLoadingState) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.red, size: 50),
          );
        } else if (state is ItemPageLoadingSucessState ||
            state is ItemPageSetUpdatePageState) {
          if (state is ItemPageSetUpdatePageState) {
            setInitialValuesForUpdate(state.item);
          } else if (state is ItemPageLoadingSucessState) {
            isPriceEditable = true;
          }

          final bool isItemPageLoadedState =
              state is ItemPageLoadingSucessState ? true : false;

          final bool isItemPageUpdateState =
              state is ItemPageSetUpdatePageState ? true : false;

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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Items',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text('Your Valuabels',
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
                                          widget.itemListStream.first
                                              .then((itemList) {
                                            searchBlocBloc.add(
                                                ItemSearchBarValueChangedEvent(
                                              searchQuery: query,
                                              allItems: itemList,
                                            ));
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.569555,
                            height: MediaQuery.of(context).size.height * 0.7792,
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
                                  case const (ItemPageSearchDataLoadingSucessState):
                                    final successState = state
                                        as ItemPageSearchDataLoadingSucessState;
                                    return Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        children: [
                                          Expanded(
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  successState.itemList.length,
                                              itemBuilder: (context, index) {
                                                return ItemPageTile(
                                                  item: successState
                                                      .itemList[index],
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
                    width: MediaQuery.of(context).size.width * 0.25,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 20, left: 15, right: 10, bottom: 30),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('New Items',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                    Text('Add Existing Item Details Here.',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                151, 151, 151, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.normal)),
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {
                                      itemPageBlocBloc.add(
                                          ItemPageInitialFetchEvent(
                                              buildContext: context));
                                      clearData();
                                    },
                                    icon: const Icon(Icons.refresh_rounded,
                                        color: Colors.black))
                              ],
                            ),
                            const SizedBox(height: 30),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Basic Info',
                                    style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
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
                            Column(
                              children: [
                                const SizedBox(height: 10),
                                const Row(
                                  children: [
                                    Text('Supplier Name',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11)),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 13,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: StreamBuilder<Object>(
                                      stream: widget.supplierListStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  Text('Loading Suppliers...'));
                                        } else if (snapshot.hasData) {
                                          final List<DropdownMenuItem<String>>
                                              tempSupplierList =
                                              getSuppliersList(snapshot.data
                                                  as List<Supplier>);
                                          return DropdownButtonFormField(
                                            decoration:
                                                const InputDecoration.collapsed(
                                                    hintText: ''),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                            isExpanded: true,
                                            items: tempSupplierList,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedSupplierItem = value;
                                                isItemPageUpdateState
                                                    ? updatedSupplierItem =
                                                        value
                                                    : "";
                                              });
                                              // itemDTO.supplierName = value;
                                            },
                                            value: isItemPageUpdateState
                                                ? selectedSupplierItem
                                                : tempSupplierList[0].value,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please select a supplier...';
                                              } else {
                                                return null;
                                              }
                                            },
                                          );
                                        } else {
                                          return const Center(
                                            child:
                                                Text('Error loading suppliers'),
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Category Name',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11)),
                                    SizedBox(width: 5),
                                    Icon(
                                      Icons.error,
                                      color: Colors.red,
                                      size: 13,
                                    )
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  height: 50,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border: Border.all(
                                          color: Colors.grey, width: 1)),
                                  child: StreamBuilder<Object>(
                                      stream: widget.categoryListStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child:
                                                Text('Loading Categories...'),
                                          );
                                        } else if (snapshot.hasError) {
                                          return const Center(
                                              child: Text(
                                                  'Error loading categories'));
                                        } else {
                                          final List<DropdownMenuItem<String>>
                                              tempCategoryList =
                                              getCategoryList(snapshot.data
                                                  as List<CategoryType>);
                                          return DropdownButtonFormField(
                                            decoration:
                                                const InputDecoration.collapsed(
                                                    hintText: ''),
                                            style: const TextStyle(
                                                color: Colors.grey),
                                            isExpanded: true,
                                            items: tempCategoryList,
                                            value: isItemPageUpdateState
                                                ? selectedCategoryItem
                                                : tempCategoryList[0].value,
                                            onChanged: (value) {
                                              setState(
                                                () {
                                                  selectedCategoryItem = value;
                                                  isItemPageUpdateState
                                                      ? updatedCategoryItem =
                                                          value
                                                      : "";
                                                },
                                              );
                                              // itemDTO.categoryName = value;
                                            },
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Please select a category...';
                                              } else {
                                                return null;
                                              }
                                            },
                                          );
                                        }
                                      }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Item Name',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11)),
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
                                  controller: itemNameController,
                                  maxLength: 30,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Item Name is required!!!';
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
                              ],
                            ),
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Item Code',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11)),
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
                                  controller: itemCodeController,
                                  maxLength: 20,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Item Code is required!!!';
                                    } else {
                                      return null;
                                    }
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Ex: 456321365',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Number of Items',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11)),
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
                                  controller: itemCountController,
                                  maxLength: 20,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Count is required!!!';
                                    }
                                    final isNumeric = double.tryParse(value);
                                    if (isNumeric == null || isNumeric <= 0) {
                                      return 'Please enter a valid positive number';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Ex: 4',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                  ),
                                ),
                              ],
                            ),
                            isItemPageLoadedState
                                ? Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text('Purchase Date',
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
                                        controller: itemPurchaseDateController,
                                        // keyboardType: TextInputType.datetime,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          hintText: 'Select Purchase Date',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                        ),
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2010),
                                                  lastDate: DateTime(2100))
                                              .then((selectedDate) {
                                            if (selectedDate != null) {
                                              itemPurchaseDateController.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(selectedDate);
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 10),
                            isItemPageLoadedState
                                ? Column(
                                    children: [
                                      const Row(
                                        children: [
                                          Text('Warranty Expiry Date',
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
                                        controller: itemExpiryDateController,
                                        keyboardType: TextInputType.datetime,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                          ),
                                          hintText:
                                              'Select Warranty Expiry Date',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                        ),
                                        onTap: () {
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(2010),
                                                  lastDate: DateTime(2100))
                                              .then((selectedDate) {
                                            if (selectedDate != null) {
                                              itemExpiryDateController.text =
                                                  DateFormat('yyyy-MM-dd')
                                                      .format(selectedDate);
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Item Dimensions(Inches)',
                                  style: TextStyle(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: TextFormField(
                                        controller: itemLengthController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter "0" if no height';
                                          }
                                          final isNumeric =
                                              double.tryParse(value);
                                          if (isNumeric == null ||
                                              isNumeric < 0) {
                                            return 'Please enter a positive number';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          hintText: 'Ex :- 1.5',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                        ),
                                      ),
                                    ),
                                    const Text(
                                      'X',
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.1,
                                      child: TextFormField(
                                        controller: itemWidthController,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Enter "0" if no width';
                                          }
                                          final isNumeric =
                                              double.tryParse(value);
                                          if (isNumeric == null ||
                                              isNumeric < 0) {
                                            return 'Please enter a positive number';
                                          }
                                          return null;
                                        },
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          hintText: 'Ex :- 1.5',
                                          hintStyle: TextStyle(
                                              color: Colors.grey, fontSize: 12),
                                          contentPadding: EdgeInsets.symmetric(
                                              vertical: 2, horizontal: 10),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Item Weight(kg)',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11)),
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
                                  controller: itemWeightController,
                                  maxLength: 10,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Enter "0" if no weight';
                                    }
                                    final isNumeric = double.tryParse(value);
                                    if (isNumeric == null || isNumeric < 0) {
                                      return 'Please enter a positive number';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Ex: 4.5',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(
                                      child: Row(
                                        children: [
                                          Text('Item Bought Price',
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
                                    ),
                                    isItemPageUpdateState
                                        ? ElevatedButton(
                                            onPressed: () {
                                              _makePriceEditable(context);
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.orange),
                                            child: const Icon(Icons.edit,
                                                color: Colors.black, size: 20),
                                          )
                                        : const SizedBox()
                                  ],
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  readOnly:
                                      isPriceEditable || isAdminAccessGranted
                                          ? false
                                          : true,
                                  controller: itemBoughtPriceController,
                                  maxLength: 12,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Price is required!!!';
                                    }
                                    if (!RegExp(r'^\d+(\.\d{0,2})?$')
                                        .hasMatch(value)) {
                                      return 'Invalid format. Use "123.45" or "123"';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Ex: Rs. 45000.00',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Item Selling Price',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11)),
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
                                  readOnly:
                                      isPriceEditable || isAdminAccessGranted
                                          ? false
                                          : true,
                                  controller: itemSellingPriceController,
                                  maxLength: 12,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Price is required!!!';
                                    }
                                    if (!RegExp(r'^\d+(\.\d{0,2})?$')
                                        .hasMatch(value)) {
                                      return 'Invalid format. Use "123.45" or "123"';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Ex: Rs. 55000.00',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const Row(
                                  children: [
                                    Text('Item Discount Price',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 11)),
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
                                  readOnly:
                                      isPriceEditable || isAdminAccessGranted
                                          ? false
                                          : true,
                                  controller: itemDiscountPriceController,
                                  maxLength: 12,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Price is required, enter zero if no discount';
                                    } else if (!RegExp(r'^\d+(\.\d{0,2})?$')
                                        .hasMatch(value)) {
                                      return 'Invalid format. Use "123.45" or "123"';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    hintText: 'Ex: Rs. 400.00',
                                    hintStyle: TextStyle(
                                        color: Colors.grey, fontSize: 12),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 2, horizontal: 10),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                !isItemPageUpdateState
                                    ? Column(
                                        children: [
                                          const Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Text('Pick Image',
                                                      style: TextStyle(
                                                          color: Colors.grey,
                                                          fontSize: 11)),
                                                  SizedBox(width: 5),
                                                  Icon(
                                                    Icons.error,
                                                    color: Colors.red,
                                                    size: 13,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Stack(
                                            children: [
                                              Container(
                                                width: double.maxFinite,
                                                height: 220,
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(15)),
                                                ),
                                                child: Column(
                                                  children: [
                                                    (_imageFile.isNotEmpty ||
                                                            _imageFile != '')
                                                        ? Image.memory(
                                                            selectedImageInBytes!,
                                                            fit: BoxFit.cover,
                                                            height: 220,
                                                            width: double
                                                                .maxFinite,
                                                          )
                                                        : Image.asset(
                                                            'assets/images/noimage.jpg',
                                                            fit: BoxFit.cover,
                                                            height: 220,
                                                            width: double
                                                                .maxFinite,
                                                          ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 0,
                                                right: 0,
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Colors.greenAccent,
                                                      borderRadius:
                                                          BorderRadius.all(
                                                        Radius.circular(8),
                                                      ),
                                                    ),
                                                    child: IconButton(
                                                      onPressed: () async {
                                                        final FilePickerResult?
                                                            fileResult =
                                                            await pickImage();
                                                        // If user picks an image, save selected image to variable
                                                        if (fileResult !=
                                                            null) {
                                                          setState(() {
                                                            _imageFile =
                                                                fileResult.files
                                                                    .first.name;
                                                            selectedImageInBytes =
                                                                fileResult
                                                                    .files
                                                                    .first
                                                                    .bytes;
                                                          });
                                                        }
                                                        // uploadImageAndAddToFirestore();
                                                        // newPostDTO.imageFile = imageFile;
                                                      },
                                                      icon: const Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(),
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
                                          if (state
                                              is ItemPageLoadingSucessState) {
                                            saveDataInToDto();
                                            itemPageBlocBloc.add(
                                                ItemPageSavedButtonClickedEvent(
                                                    item: itemDTO));
                                          } else if (state
                                              is ItemPageSetUpdatePageState) {
                                            final tempCatName =
                                                updatedCategoryItem != null &&
                                                        updatedCategoryItem!
                                                            .isNotEmpty
                                                    ? updatedCategoryItem
                                                    : selectedCategoryItem;
                                            final tempSupName =
                                                updatedSupplierItem != null &&
                                                        updatedSupplierItem!
                                                            .isNotEmpty
                                                    ? updatedSupplierItem
                                                    : selectedSupplierItem;
                                            itemUpdateDTO = ItemUpdateDTO(
                                              id: state.item.id,
                                              categoryName: tempCatName,
                                              supplierName: tempSupName,
                                            );
                                            saveDataInToUpdateDto();
                                            itemPageBlocBloc.add(
                                              ItemPageUpdateButtonClickedEvent(
                                                  item: itemUpdateDTO),
                                            );
                                          }
                                          clearData();
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                            isItemPageLoadedState
                                                ? 'Save'
                                                : state
                                                        is ItemPageSetUpdatePageState
                                                    ? 'Update'
                                                    : 'Error',
                                            style: const TextStyle(
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
                                        isItemPageLoadedState
                                            ? clearData()
                                            : isItemPageUpdateState
                                                ? itemPageBlocBloc.add(
                                                    ItemPageDeleteCheckEvent(
                                                        item: state.item),
                                                  )
                                                : null;
                                      },
                                      child: Center(
                                        child: Text(
                                          isItemPageLoadedState
                                              ? 'Clear'
                                              : isItemPageUpdateState
                                                  ? 'Delete'
                                                  : 'Error',
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ]),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  void saveDataInToDto() {
    // final tempPD = itemPurchaseDateController.text;
    itemDTO.itemName = itemNameController.text;
    itemDTO.itemCode = itemCodeController.text;
    itemDTO.supplierName = selectedSupplierItem;
    itemDTO.categoryName = selectedCategoryItem;
    itemDTO.numItems = (double.parse(itemCountController.text)).toInt();
    itemDTO.itemBoughtPrice = double.parse(itemBoughtPriceController.text);
    itemDTO.itemSellingPrice = double.parse(itemSellingPriceController.text);
    itemDTO.discountPrice = double.parse(itemDiscountPriceController.text);
    itemDTO.datePurchased = (itemPurchaseDateController.text.isEmpty)
        ? null
        : Timestamp.fromDate(DateTime.parse(itemPurchaseDateController.text));
    itemDTO.warrantyExpiryDate = (itemPurchaseDateController.text.isEmpty)
        ? null
        : Timestamp.fromDate(DateTime.parse(itemExpiryDateController.text));
    itemDTO.itemLength = double.parse(itemLengthController.text);
    itemDTO.itemWidth = double.parse(itemWidthController.text);
    itemDTO.itemWeight = double.parse(itemWeightController.text);
    itemDTO.selectedImageInBytes = selectedImageInBytes;
  }

  void saveDataInToUpdateDto() {
    debugPrint(itemLengthController.text);
    // itemUpdateDTO.id = itemId;
    itemUpdateDTO.itemName = itemNameController.text;
    itemUpdateDTO.itemCode = itemCodeController.text;
    // itemUpdateDTO.supplierName = selectedSupplierItem;
    // itemUpdateDTO.categoryName = selectedCategoryItem;
    itemUpdateDTO.numItems = (double.parse(itemCountController.text)).toInt();
    itemUpdateDTO.itemLength = double.parse(itemLengthController.text);
    itemUpdateDTO.itemWidth = double.parse(itemWidthController.text);
    itemUpdateDTO.itemWeight = double.parse(itemWeightController.text);
    itemUpdateDTO.itemBoughtPrice =
        double.parse(itemBoughtPriceController.text);
    itemUpdateDTO.itemSellingPrice =
        double.parse(itemSellingPriceController.text);
    itemUpdateDTO.discountPrice =
        double.parse(itemDiscountPriceController.text);
    // itemUpdateDTO = ItemUpdateDTO(
    //   id: itemId,
    //   itemName: itemNameController.text,
    //   itemCode: itemCodeController.text,
    //   supplierName: selectedSupplierItem,
    //   // categoryName: selectedCategoryItem,
    //   numItems: (double.parse(itemCountController.text)).toInt(),
    //   itemBoughtPrice: double.parse(itemBoughtPriceController.text),
    //   itemSellingPrice: double.parse(itemSellingPriceController.text),
    //   discountPrice: double.parse(itemDiscountPriceController.text),
    // );
  }

  int _submitForm() {
    if (_formKey.currentState!.validate()) {
      return 1;
    } else {
      return 0;
    }
  }

  void clearData() {
    itemNameController.clear();
    itemCodeController.clear();
    itemCountController.clear();
    itemPurchaseDateController.clear();
    itemExpiryDateController.clear();
    itemLengthController.clear();
    itemWidthController.clear();
    itemWeightController.clear();
    itemBoughtPriceController.clear();
    itemSellingPriceController.clear();
    itemDiscountPriceController.clear();
    _imageFile = '';
  }
}
