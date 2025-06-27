import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/search/bloc/search_bloc_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:furniture_shop_wijaya/business_logic/supplier_page/bloc/supplier_page_bloc.dart';
import 'package:furniture_shop_wijaya/data/models/supplier/supplier.dart';
import '../../../data/dto/supplier/supplier_dto.dart';
import '../../widgets/supplier_page_title/supplier_page_tile.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  late SupplierPageBloc supplierPageBloc;
  late SearchBlocBloc searchBlocBloc;

  TextEditingController supplierNameController = TextEditingController();
  TextEditingController supplierAddressController = TextEditingController();
  TextEditingController supplierEmailController = TextEditingController();
  TextEditingController supplierMobileController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    supplierPageBloc = BlocProvider.of<SupplierPageBloc>(context);
    searchBlocBloc = BlocProvider.of<SearchBlocBloc>(context);
    supplierPageBloc.add(SupplierPageInitialFetchEvent(buildContext: context));
    super.initState();
  }

  void setInitialValuesForUpdate(Supplier supplier) {
    supplierNameController.text = supplier.supplierName;
    supplierAddressController.text = supplier.supplierAddress;
    supplierEmailController.text = supplier.supplierEmail;
    supplierMobileController.text = '0${supplier.supplierMobile}';
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, Supplier supplier) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
              'Are you sure you want to Delete this Supplier?\nSupplier Name: ${supplier.supplierName}\nSupplier Mobile: 0${supplier.supplierMobile}'),
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
                supplierPageBloc.add(
                    SupplierPageDeleteButtonClickedEvent(supplier: supplier));
              },
            ),
          ],
        );
      },
    );
  }

  _refreshPage() {
    supplierPageBloc.add(SupplierPageInitialFetchEvent(buildContext: context));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SupplierPageBloc, SupplierPageState>(
      bloc: supplierPageBloc,
      listenWhen: (previous, current) => current is SupplierPageActionState,
      buildWhen: (previous, current) => current is! SupplierPageActionState,
      listener: (context, state) {
        if (state is SupplierPageNewSupplierSavedSucessActionState) {
          clearData();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('New Supplier is added. Data saved successfully.')));
          _refreshPage();
        } else if (state is SupplierPageNewSupplierSavedErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Error occured!, Data is not saved successfully!')));
        } else if (state is SupplierDeleteCheckEventActionState) {
          _showConfirmationDialog(context, state.supplier);
        } else if (state is SupplierDeleteSucessActionState) {
          clearData();
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Supplier is deleted')));
          _refreshPage();
        } else if (state is SupplierAlreadyAssignedActionState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Supplier is already assigned to a product')));
        } else if (state is SupplierDeleteErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Error occured!, Supplier is not deleted successfully!')));
        } else if (state is SupplierPageSupplierUpdatedSucessActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Supplier is updated successfully.')));
          _refreshPage();
        } else if (state is SupplierPageSupplierUpdatedErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Error occured!, Supplier is not updated successfully!'),
            ),
          );
        } else if (state
            is SupplierPageNewSupplierAddedAlreadyExistErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Supplier Name already exist!'),
            ),
          );
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (SupplierPageLoadingState):
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.red, size: 50),
            );
          case const (SupplierPageLoadingSuccessState):
            final supplierLoadedState =
                state as SupplierPageLoadingSuccessState;
            final supplierList = supplierLoadedState.supplierList;
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
                                      Text('Suppliers',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Supplier Hub: Your Sourcing Solution',
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
                                            hintText: 'Search supplier...',
                                          ),
                                          onChanged: (query) {
                                            searchBlocBloc.add(
                                                SupplierSearchBarValueChangedEvent(
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
                                    case const (SupplierPageSearchDataLoadingSucessState):
                                      final successState = state
                                          as SupplierPageSearchDataLoadingSucessState;
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: successState
                                                    .supplierList.length,
                                                itemBuilder: (context, index) {
                                                  return SupplierPageTile(
                                                    supplier: successState
                                                        .supplierList[index],
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
                                      Text('New Suppliers',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text('Add New Supplier Details Here.',
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
                                      Text('Supplier Name',
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
                                    controller: supplierNameController,
                                    maxLength: 50,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Name is required!!!';
                                      } else if (!RegExp(r'^[a-z0-9A-Z\s]+$')
                                          .hasMatch(value)) {
                                        return 'Name should contain only letters, digits and spaces';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      hintText: 'Ex: Amal Perera',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text('Supplier Address',
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
                                    controller: supplierAddressController,
                                    maxLength: 150,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Address is required!!!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      hintText:
                                          'Ex: 165/52, Milcasalwatta, Divulapitiya.',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text('Mobile Number',
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
                                    controller: supplierMobileController,
                                    maxLength: 10,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mobile Number is required!!!';
                                      } else if (!RegExp(r'^0\d{9}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid mobile number starting with 0';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: 'Ex: 0771071794',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text('Email Address',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11)),
                                      // SizedBox(width: 5),
                                      // Icon(
                                      //   Icons.error,
                                      //   color: Colors.red,
                                      //   size: 13,
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: supplierEmailController,
                                    maxLength: 50,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      } else {
                                        if (!RegExp(
                                                r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid email address';
                                        } else {
                                          return null;
                                        }
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: 'Ex: sarath@gmail.com',
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
                                        SupplierDTO supRef = SupplierDTO(
                                            supplierName:
                                                supplierNameController.text,
                                            supplierAddress:
                                                supplierAddressController.text,
                                            supplierEmail:
                                                supplierEmailController.text,
                                            supplierMobile: (double.parse(
                                                    supplierMobileController
                                                        .text))
                                                .toInt());
                                        supplierPageBloc.add(
                                            SupplierPageSaveButtonClickedEvent(
                                                supplierDTO: supRef,
                                                supplierList: supplierList));
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
          case const (SupplierPageSetUpdatePageState):
            final successState = state as SupplierPageSetUpdatePageState;
            setInitialValuesForUpdate(successState.supplier);
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
                                      Text('Suppliers',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text(
                                          'Supplier Hub: Your Sourcing Solution',
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
                                                SupplierSearchBarValueChangedEvent(
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
                                    case const (SupplierPageSearchDataLoadingSucessState):
                                      final successState = state
                                          as SupplierPageSearchDataLoadingSucessState;
                                      return Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          children: [
                                            Expanded(
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: successState
                                                    .supplierList.length,
                                                itemBuilder: (context, index) {
                                                  return SupplierPageTile(
                                                    supplier: successState
                                                        .supplierList[index],
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
                                      Text('Existing Suppliers',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold)),
                                      Text('Update Supplier Details Here.',
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
                                        supplierPageBloc.add(
                                            SupplierPageInitialFetchEvent(
                                                buildContext: context));
                                      },
                                      icon: const Icon(Icons.refresh,
                                          color: Colors.black))
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
                                      Text('Supplier Name',
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
                                    controller: supplierNameController,
                                    maxLength: 50,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Name is required!!!';
                                      } else if (!RegExp(r'^[a-zA-Z0-9\s]+$')
                                          .hasMatch(value)) {
                                        return 'Name should contain only letters, digits and spaces';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      hintText: 'Ex: Amal Perera',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text('Supplier Address',
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
                                    controller: supplierAddressController,
                                    maxLength: 150,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Address is required!!!';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      hintText:
                                          'Ex: 165/52, Milcasalwatta, Divulapitiya.',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                ],
                              ),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text('Mobile Number',
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
                                    controller: supplierMobileController,
                                    maxLength: 10,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Mobile Number is required!!!';
                                      } else if (!RegExp(r'^0\d{9}$')
                                          .hasMatch(value)) {
                                        return 'Please enter a valid mobile number starting with 0';
                                      } else {
                                        return null;
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: 'Ex: 0771071794',
                                      hintStyle: TextStyle(
                                          color: Colors.grey, fontSize: 12),
                                      contentPadding: EdgeInsets.symmetric(
                                          vertical: 2, horizontal: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  const Row(
                                    children: [
                                      Text('Email Address',
                                          style: TextStyle(
                                              color: Colors.grey,
                                              fontSize: 11)),
                                      // SizedBox(width: 5),
                                      // Icon(
                                      //   Icons.error,
                                      //   color: Colors.red,
                                      //   size: 13,
                                      // ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  TextFormField(
                                    controller: supplierEmailController,
                                    maxLength: 50,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return null;
                                      } else {
                                        if (!RegExp(
                                                r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$')
                                            .hasMatch(value)) {
                                          return 'Please enter a valid email address';
                                        } else {
                                          return null;
                                        }
                                      }
                                    },
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      hintText: 'Ex: sarath@gmail.com',
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
                                        Supplier supRef = Supplier(
                                            supplierId: successState
                                                .supplier.supplierId,
                                            supplierName:
                                                supplierNameController.text,
                                            supplierAddress:
                                                supplierAddressController.text,
                                            supplierEmail:
                                                supplierEmailController.text,
                                            supplierMobile: (double.parse(
                                                    supplierMobileController
                                                        .text))
                                                .toInt());
                                        supplierPageBloc.add(
                                            SupplierPageUpdateButtonClickedEvent(
                                                supplier: supRef));
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
                                        foregroundColor:
                                            const Color(0xFF1EA7DD),
                                        backgroundColor: Colors.white,
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8)))),
                                    onPressed: () {
                                      supplierPageBloc.add(
                                          SupplierPageDeleteCheckEvent(
                                              supplier: successState.supplier));
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
    _formKey.currentState?.reset();
    supplierAddressController.clear();
    supplierEmailController.clear();
    supplierMobileController.clear();
    supplierNameController.clear();
  }
}
