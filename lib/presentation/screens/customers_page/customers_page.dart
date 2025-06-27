import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/customer_page/customer_page_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/search/bloc/search_bloc_bloc.dart';
import 'package:furniture_shop_wijaya/data/models/customer/customer.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../data/dto/customer/customer_dto.dart';
import '../../widgets/customers_page/customers_page_tile.dart';

class CustomersPage extends StatefulWidget {
  final Stream<List<CustomerType>> customersStream;
  const CustomersPage({super.key, required this.customersStream});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  late CustomerPageBloc customerPageBloc;
  CustomerType updateValues = CustomerType(
      customerNIC: "",
      customerName: "",
      customerMobile: "",
      customerAddress: "");

  @override
  void initState() {
    customerPageBloc = BlocProvider.of<CustomerPageBloc>(context);

    customerPageBloc.add(CustomerPageInitialFetchEvent(buildContext: context));
    super.initState();
  }

  Future<void> _showConfirmationDialog(
      BuildContext context, CustomerType customerType) async {
    return showDialog<void>(
      context: context,
      barrierDismissible:
          false, // Prevent dialog from being dismissed by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: Text(
              'Are you sure you want to Delete this Customer?\nCustomer Name: ${customerType.customerName}'),
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
                customerPageBloc.add(
                  CustomerPageDeleteButtonClickedEvent(
                      customerType: customerType),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CustomerPageBloc, CustomerPageState>(
      bloc: customerPageBloc,
      listenWhen: (previous, current) => current is CustomerPageActionState,
      buildWhen: (previous, current) => current is! CustomerPageActionState,
      listener: (context, state) {
        if (state is CustomerPageNewCategoryAddedSuccessActionState) {
          customerPageBloc
              .add(CustomerPageInitialFetchEvent(buildContext: context));
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('New Customer is added. Data saved successfully.')));
        } else if (state is CustomerPageNewCategoryAddedErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content:
                  Text('Error occured!, Data is not saved successfullu!')));
        } else if (state is CustomerUpdatedSucessActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Customer is updated successfully.')));
          customerPageBloc
              .add(CustomerPageInitialFetchEvent(buildContext: context));
        } else if (state is CustomerUpdatedErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Error occured!, Customer update failed!')));
        } else if (state is CustomerDeleteCheckEventActionState) {
          _showConfirmationDialog(context, state.customerType);
        } else if (state is CustomerDeleteSucessActionState) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Customer is deleted')));
          customerPageBloc
              .add(CustomerPageInitialFetchEvent(buildContext: context));
        } else if (state is CustomerDeleteErrorActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                  'Error occured!, Customer is not deleted successfully!')));
        }
      },
      builder: (context, state) {
        switch (state.runtimeType) {
          case const (CustomerPageLoadingState):
            return Center(
              child: LoadingAnimationWidget.fourRotatingDots(
                  color: Colors.red, size: 50),
            );
          case const (CustomerPageLoadingSuccessState):
            final successState = state as CustomerPageLoadingSuccessState;
            return CustomersPageWidget(
              customerStream: widget.customersStream,
              state: successState,
              customerPageBloc: customerPageBloc,
              updateValues: updateValues,
            );
          case const (CustomerPageSetUpdatePageState):
            final successState = state as CustomerPageSetUpdatePageState;
            updateValues = successState.customerType;
            return CustomersPageWidget(
              customerStream: widget.customersStream,
              state: successState,
              customerPageBloc: customerPageBloc,
              updateValues: updateValues,
            );
          default:
            return const SizedBox();
        }
      },
    );
  }
}

class CustomersPageWidget extends StatefulWidget {
  final Stream<List<CustomerType>> customerStream;
  final CustomerType updateValues;
  final CustomerPageState state;
  final CustomerPageBloc customerPageBloc;
  const CustomersPageWidget({
    super.key,
    required this.state,
    required this.customerPageBloc,
    required this.updateValues,
    required this.customerStream,
  });

  @override
  State<CustomersPageWidget> createState() => _CustomersPageWidgetState();
}

class _CustomersPageWidgetState extends State<CustomersPageWidget> {
  late SearchBlocBloc searchBloc;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController customerNICController = TextEditingController();
  TextEditingController customerNameController = TextEditingController();
  TextEditingController customerMobileController = TextEditingController();
  TextEditingController customerAddressController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  void setInitialValuesForUpdate(CustomerType customerType) {
    customerNICController.text = customerType.customerNIC;
    customerNameController.text = customerType.customerName;
    customerMobileController.text = customerType.customerMobile;
    customerAddressController.text = customerType.customerAddress;
  }

  @override
  void initState() {
    searchBloc = BlocProvider.of<SearchBlocBloc>(context);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant CustomersPageWidget oldWidget) {
    setInitialValuesForUpdate(widget.updateValues);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    customerNameController.dispose();
    customerMobileController.dispose();
    customerAddressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CustomerPageBloc customerPageBloc = widget.customerPageBloc;
    final CustomerPageState customerPageState = widget.state;
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
                              Text('Customers',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              Text('Customers Unite: Streamline Your business',
                                  style: TextStyle(
                                      color: Color.fromRGBO(151, 151, 151, 1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                width: 350,
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
                                child: StreamBuilder(
                                    stream: widget.customerStream,
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return TextField(
                                          controller: searchController,
                                          decoration: const InputDecoration(
                                            border: InputBorder.none,
                                            hintText: 'Search here...',
                                          ),
                                          onChanged: (query) {
                                            searchBloc.add(
                                              CustomerSearchBarValueChangedEvent(
                                                customerList: snapshot.data!,
                                                searchQuery: query,
                                              ),
                                            );
                                          },
                                        );
                                      } else if (snapshot.hasError) {
                                        return const Center(
                                          child: Text(
                                              'Sorry, Error finding customers to search'),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
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
                      child: BlocConsumer<SearchBlocBloc, SearchBlocState>(
                        bloc: searchBloc,
                        listenWhen: (previous, current) =>
                            current is SearchBlocActionState,
                        buildWhen: (previous, current) =>
                            current is! SearchBlocActionState,
                        listener: (context, state) {},
                        builder: (context, state) {
                          switch (state.runtimeType) {
                            case const (CustomerPageSearchDataLoadingSucessState):
                              final successState = state
                                  as CustomerPageSearchDataLoadingSucessState;
                              return Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount:
                                            successState.customerList.length,
                                        itemBuilder: (context, index) {
                                          return CustomersPageTile(
                                            customerType: successState
                                                .customerList[index],
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  customerPageState.runtimeType ==
                                          CustomerPageLoadingSuccessState
                                      ? "Add New Customer"
                                      : customerPageState.runtimeType ==
                                              CustomerPageSetUpdatePageState
                                          ? "Update Customer"
                                          : "",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              const Text('Add New Customer Details Here.',
                                  style: TextStyle(
                                      color: Color.fromRGBO(151, 151, 151, 1),
                                      fontSize: 10,
                                      fontWeight: FontWeight.normal)),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              clearData();
                              customerPageBloc.add(
                                CustomerPageInitialFetchEvent(
                                    buildContext: context),
                              );
                            },
                            icon:
                                const Icon(Icons.refresh, color: Colors.black),
                          )
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
                              DateFormat('dd MMMM yyyy').format(DateTime.now()),
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 10))
                        ],
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text('Customer NIC',
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
                            controller: customerNICController,
                            // maxLength: 12,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Customer NIC is required!!!';
                              } else if (!RegExp(r'^[a-zA-Z1-9]+$')
                                  .hasMatch(value)) {
                                return 'Customer NIC has only letters and digits';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Ex:- xxxxxxxxxxxx',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text('Customer Name',
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
                            controller: customerNameController,
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Customer Name is required!!!';
                              } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                  .hasMatch(value)) {
                                return 'Customer Name should contain only letters and spaces';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Ex: Tables',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text('Customer Mobile',
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
                            keyboardType: TextInputType.number,
                            controller: customerMobileController,
                            maxLength: 50,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Customer Mobile is required!!!';
                              } else if (value.length != 10) {
                                return 'Invalid number';
                              } else if (!RegExp(r'^[0-9]{10}$')
                                  .hasMatch(value)) {
                                return 'Only digits are accepted';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Ex: 0771234567',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Column(
                        children: [
                          const Row(
                            children: [
                              Text('Customer Address',
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
                            controller: customerAddressController,
                            maxLength: 100,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Customer Address is required!!!';
                              } else if (!RegExp(r"^[a-zA-Z\d\s,'.#/-]+$")
                                  .hasMatch(value)) {
                                return 'Invalid Address';
                              } else {
                                return null;
                              }
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              hintText: 'Ex: 123, Global Road, Colombo',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 12),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 10),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(170, 50),
                                foregroundColor: Colors.white,
                                backgroundColor: const Color(0xFF1EA7DD),
                                shape: const RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8)))),
                            onPressed: () {
                              if (customerPageState.runtimeType ==
                                  CustomerPageLoadingSuccessState) {
                                if (_submitForm() == 1) {
                                  CustomerTypeDTO customerTypeDTO =
                                      CustomerTypeDTO(
                                    customerNIC: customerNICController.text,
                                    customerName: customerNameController.text,
                                    customerMobile:
                                        customerMobileController.text,
                                    customerAddress:
                                        customerAddressController.text,
                                  );
                                  customerPageBloc.add(
                                    CustomerPageNewCustomerSaveButtonClickedEvent(
                                        customerTypeDTO: customerTypeDTO),
                                  );
                                  clearData();
                                }
                              } else if (customerPageState.runtimeType ==
                                  CustomerPageSetUpdatePageState) {
                                // final state = customerPageState
                                // as CustomerPageSetUpdatePageState;
                                if (_submitForm() == 1) {
                                  CustomerType customerType = CustomerType(
                                    customerNIC: customerNICController.text,
                                    customerName: customerNameController.text,
                                    customerMobile:
                                        customerMobileController.text,
                                    customerAddress:
                                        customerAddressController.text,
                                  );
                                  customerPageBloc.add(
                                    CustomerPageUpdateButtonClickedEvent(
                                        customerType: customerType),
                                  );
                                  clearData();
                                }
                              }
                            },
                            child: Center(
                              child: Text(
                                  customerPageState.runtimeType ==
                                          CustomerPageLoadingSuccessState
                                      ? "Save"
                                      : customerPageState.runtimeType ==
                                              CustomerPageSetUpdatePageState
                                          ? "Update"
                                          : "",
                                  style: const TextStyle(
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                            ),
                            onPressed: () {
                              if (customerPageState.runtimeType ==
                                  CustomerPageLoadingSuccessState) {
                                clearData();
                              } else if (customerPageState.runtimeType ==
                                  CustomerPageSetUpdatePageState) {
                                final state = customerPageState
                                    as CustomerPageSetUpdatePageState;
                                customerPageBloc.add(
                                  CustomerPageDeleteCheckEvent(
                                      customerType: state.customerType),
                                );
                                clearData();
                              }
                            },
                            child: Center(
                              child: Text(
                                  customerPageState.runtimeType ==
                                          CustomerPageLoadingSuccessState
                                      ? "Clear"
                                      : customerPageState.runtimeType ==
                                              CustomerPageSetUpdatePageState
                                          ? "Delete"
                                          : "",
                                  style: const TextStyle(
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
  }

  int _submitForm() {
    if (_formKey.currentState!.validate()) {
      return 1;
    } else {
      return 0;
    }
  }

  void clearData() {
    customerNameController.clear();
    customerMobileController.clear();
    customerAddressController.clear();
  }
}
