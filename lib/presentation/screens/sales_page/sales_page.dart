import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/data/dto/customer/customer_dto.dart';
import 'package:furniture_shop_wijaya/data/dto/sales/sales_item_dto.dart';
import 'package:furniture_shop_wijaya/data/models/customer/customer.dart';
import 'package:furniture_shop_wijaya/data/models/item/item.dart';
import 'package:go_router/go_router.dart';
import '../../../business_logic/sales_page/sales_page_bloc.dart';

class SalesPage extends StatefulWidget {
  final Stream<List<Item>> itemListStream;
  final Stream<List<CustomerType>> customerListStream;
  const SalesPage(
      {super.key,
      required this.itemListStream,
      required this.customerListStream});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  late SalesPageBloc salesPageBloc;
  List<SalesItemDTO> salesItemList = [];
  List<CustomerType> tempCustomersList = [];
  String selectedItemName = "";
  CustomerTypeDTO selectedCustomerData = CustomerTypeDTO(
    customerNIC: "",
    customerName: "",
    customerMobile: "",
    customerAddress: "",
  );
  double selectedItemPrice = 0;
  double selectedDiscountPrice = 0;
  TotalAndDiscount totalAndDiscount = TotalAndDiscount(total: 0, discount: 0);
  bool isOnlinePurchase = false;
  late List<SalesItemDTO> tempSalesItemList;
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _additionalDiscountController =
      TextEditingController();

  @override
  void initState() {
    salesPageBloc = BlocProvider.of<SalesPageBloc>(context);
    salesPageBloc.add(SalesPageInitialFetchEvent(salesItems: salesItemList));
    _additionalDiscountController.text = "0";
    super.initState();
  }

  void _showPrintingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text("Generating Invoice..."),
        );
      },
    );
  }

  _refresh() {
    setState(() {
      salesItemList.clear();
      _qtyController.clear();
      _additionalDiscountController.text = "0";
      selectedItemName = "";
      selectedItemPrice = 0;
      selectedDiscountPrice = 0;
      selectedCustomerData = CustomerTypeDTO(
        customerNIC: "",
        customerName: "",
        customerMobile: "",
        customerAddress: "",
      );
      isOnlinePurchase = false;
    });
  }

  @override
  dispose() {
    _qtyController.dispose();
    _additionalDiscountController.dispose();
    super.dispose();
  }

  // create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _addSalesItemFormKey = GlobalKey<FormState>();
  final _addCustomerFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: BlocConsumer<SalesPageBloc, SalesPageState>(
        bloc: salesPageBloc,
        listenWhen: (previous, current) => current is SalesPageActionState,
        buildWhen: (previous, current) => current is! SalesPageActionState,
        listener: (context, state) {
          if (state is SalesPagePrintInvoiceLoadingState) {
            _showPrintingDialog();
          } else if (state is SalesPageInvoiceGenerationSuccessState) {
            context.pop();
            _refresh();
            // ScaffoldMessenger.of(context).showSnackBar(
            //   const SnackBar(
            //     content: Text('Invoice printed successfully.'),
            //   ),
            // );
          } else if (state is SalesPageInvoiceGenerationErrorState) {
            context.pop();
            // _refresh();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invoice Generation failed !!!'),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is SalesPageInitialFetchSuccessState) {
            // final SalesPageInitialFetchSuccessState successState = state;
            return Container(
              color: Colors.blueGrey[50],
              padding: const EdgeInsets.only(
                  top: 20, left: 20, right: 20, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Sales Invoice',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Create your invoice efficient and fast...',
                    style: TextStyle(
                        color: Color.fromRGBO(151, 151, 151, 1),
                        fontSize: 10,
                        fontWeight: FontWeight.normal),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: double.maxFinite,
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
                        child: Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Form(
                                      key: _addSalesItemFormKey,
                                      child: Column(
                                        children: [
                                          StreamBuilder(
                                            stream: widget.itemListStream,
                                            builder: (context,
                                                AsyncSnapshot<List<Item>>
                                                    snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const CircularProgressIndicator();
                                              }

                                              if (!snapshot.hasData ||
                                                  snapshot.data!.isEmpty) {
                                                return const Center(
                                                  child: Text(
                                                      'Please add a item first.'),
                                                );
                                              }

                                              // Create list of salesItems from the snapshot
                                              tempSalesItemList = snapshot.data!
                                                  .map(
                                                    (item) => SalesItemDTO(
                                                      itemName: item.itemName,
                                                      quantity: 0,
                                                      price:
                                                          item.itemSellingPrice,
                                                      discountPrice:
                                                          item.discountPrice,
                                                    ),
                                                  )
                                                  .toList();

                                              return DropdownSearch<
                                                  SalesItemDTO>(
                                                popupProps:
                                                    const PopupProps.menu(
                                                        showSearchBox: true),
                                                clearButtonProps:
                                                    const ClearButtonProps(
                                                  icon:
                                                      Icon(Icons.close_rounded),
                                                ),
                                                itemAsString:
                                                    (SalesItemDTO s) =>
                                                        s.itemName,
                                                items: tempSalesItemList,
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "Please select an item.";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                selectedItem: tempSalesItemList
                                                        .where((element) =>
                                                            element.itemName ==
                                                            selectedItemName)
                                                        .toList()
                                                        .isEmpty
                                                    ? null
                                                    : tempSalesItemList
                                                        .where((element) =>
                                                            element.itemName ==
                                                            selectedItemName)
                                                        .toList()[0],
                                                onChanged: (value) {
                                                  setState(() {
                                                    selectedItemName =
                                                        value!.itemName;
                                                    selectedItemPrice =
                                                        value.price;
                                                    selectedDiscountPrice =
                                                        value.discountPrice;
                                                  });
                                                },
                                              );
                                            },
                                          ),
                                          const SizedBox(height: 5),
                                          TextFormField(
                                            controller: _qtyController,
                                            keyboardType: TextInputType.number,
                                            decoration: const InputDecoration(
                                              labelText: "Quantity",
                                              hintText: "Eg: 25",
                                              border: OutlineInputBorder(),
                                            ),
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please enter a quantity.";
                                              } else if (!value.contains(
                                                    RegExp(r'[0-9]'),
                                                  ) ||
                                                  int.parse(value) <= 0) {
                                                return "Please enter a valid quantity.";
                                              } else {
                                                return null;
                                              }
                                            },
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  if (_addSalesItemFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    SalesItemDTO salesItem =
                                                        SalesItemDTO(
                                                      itemName: selectedItemName
                                                              .isNotEmpty
                                                          ? selectedItemName
                                                          : tempSalesItemList[0]
                                                              .itemName,
                                                      quantity: int.parse(
                                                          _qtyController.text),
                                                      price: selectedItemPrice ==
                                                              0
                                                          ? tempSalesItemList[0]
                                                              .price
                                                          : selectedItemPrice,
                                                      discountPrice:
                                                          selectedDiscountPrice,
                                                    );
                                                    setState(() {
                                                      salesItemList
                                                          .add(salesItem);
                                                      totalAndDiscount =
                                                          calculateTotal(
                                                        salesItemList,
                                                      );
                                                      _qtyController.clear();
                                                      selectedItemName = "";
                                                      selectedItemPrice = 0;
                                                    });
                                                  }
                                                },
                                                child: const Text("Add Item"),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  _refresh();
                                                },
                                                child: const Text("New Order"),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 30),
                                    // Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     Radio(
                                    //       value: true,
                                    //       groupValue: isOnlinePurchase,
                                    //       onChanged: (_) {
                                    //         setState(() {
                                    //           isOnlinePurchase = true;
                                    //         });
                                    //       },
                                    //     ),
                                    //     const Text('Online Purchase'),
                                    //     Radio(
                                    //       value: false,
                                    //       groupValue: isOnlinePurchase,
                                    //       onChanged: (_) {
                                    //         setState(() {
                                    //           isOnlinePurchase = false;
                                    //         });
                                    //       },
                                    //     ),
                                    //     const Text('Offline Purchase'),
                                    //   ],
                                    // ),
                                    // const SizedBox(height: 15),
                                    StreamBuilder(
                                      stream: widget.customerListStream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const CircularProgressIndicator();
                                        } else if (!snapshot.hasData ||
                                            snapshot.data!.isEmpty) {
                                          return const Center(
                                            child: Text(
                                                'Please add a customer first.'),
                                          );
                                        } else if (snapshot.hasError) {
                                          return const Center(
                                            child: Text(
                                                'Sorry, we are embarassed that an error occurred !!!'),
                                          );
                                        }
                                        tempCustomersList = snapshot.data!
                                            .map((e) => CustomerType(
                                                customerNIC: e.customerNIC,
                                                customerName: e.customerName,
                                                customerMobile:
                                                    e.customerMobile,
                                                customerAddress:
                                                    e.customerAddress))
                                            .toList();

                                        return Form(
                                          key: _addCustomerFormKey,
                                          child: Column(
                                            children: [
                                              DropdownSearch<CustomerType>(
                                                validator: (value) {
                                                  if (value == null) {
                                                    return "Please select a customer.";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                popupProps:
                                                    const PopupProps.menu(
                                                        showSearchBox: true),
                                                clearButtonProps:
                                                    const ClearButtonProps(
                                                  icon:
                                                      Icon(Icons.close_rounded),
                                                ),
                                                selectedItem: tempCustomersList
                                                        .where((element) =>
                                                            element
                                                                .customerNIC ==
                                                            selectedCustomerData
                                                                .customerNIC)
                                                        .toList()
                                                        .isEmpty
                                                    ? null
                                                    : tempCustomersList
                                                        .where((element) =>
                                                            element
                                                                .customerNIC ==
                                                            selectedCustomerData
                                                                .customerNIC)
                                                        .toList()[0],
                                                itemAsString: (CustomerType
                                                        c) =>
                                                    '${c.customerName} (${c.customerNIC})',
                                                items: tempCustomersList,
                                                onChanged: (value) {
                                                  setState(
                                                    () {
                                                      selectedCustomerData =
                                                          CustomerTypeDTO(
                                                        customerNIC:
                                                            value!.customerNIC,
                                                        customerName:
                                                            value.customerName,
                                                        customerMobile: value
                                                            .customerMobile,
                                                        customerAddress: value
                                                            .customerAddress,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              const SizedBox(height: 10),
                                              TextFormField(
                                                autovalidateMode:
                                                    AutovalidateMode.always,
                                                controller:
                                                    _additionalDiscountController,
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText:
                                                      "Addtional Discount",
                                                  hintText: "Eg: 250",
                                                  border: OutlineInputBorder(),
                                                ),
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return "Set value to 0 if no additional discount.";
                                                  } else if (!value.contains(
                                                        RegExp(r'[0-9]'),
                                                      ) ||
                                                      int.parse(value) < 0) {
                                                    return "Invalid Value";
                                                  } else {
                                                    return null;
                                                  }
                                                },
                                                onChanged: (value) {
                                                  setState(() {
                                                    totalAndDiscount =
                                                        calculateTotal(
                                                      salesItemList,
                                                    );
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 10),
                                    ElevatedButton(
                                      onPressed: () {
                                        // if (selectedCustomerData
                                        //     .customerName.isNotEmpty) {
                                        //   salesPageBloc.add(
                                        //     SalesPagePrintInvoiceEvent(
                                        //       salesItems: salesItemList,
                                        //       // isOnlinePurchase: isOnlinePurchase,
                                        //       customerData:
                                        //           selectedCustomerData,
                                        //     ),
                                        //   );
                                        // } else {
                                        //   ScaffoldMessenger.of(context)
                                        //       .showSnackBar(
                                        //     const SnackBar(
                                        //       content: Text(
                                        //         'Please select a customer.',
                                        //       ),
                                        //     ),
                                        //   );
                                        // }
                                        // If the auto validations are true then only proceed
                                        if (_addCustomerFormKey.currentState!
                                            .validate()) {
                                          salesPageBloc.add(
                                            SalesPagePrintInvoiceEvent(
                                              salesItems: salesItemList,
                                              total: totalAndDiscount.total,
                                              // isOnlinePurchase: isOnlinePurchase,
                                              discount:
                                                  totalAndDiscount.discount,
                                              customerData:
                                                  selectedCustomerData,
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text("Print Invoice"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const VerticalDivider(),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // List of purchased items
                                    Expanded(
                                      child: salesItemList.isEmpty
                                          ? const Center(
                                              child: Text("No Items added..."),
                                            )
                                          : ListView.builder(
                                              itemCount: salesItemList.length,
                                              itemBuilder: (context, index) {
                                                return ListTile(
                                                  title: Text(
                                                    salesItemList[index]
                                                        .itemName,
                                                  ),
                                                  trailing: SizedBox(
                                                    width: 250,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                          'Quantity: ${salesItemList[index].quantity}',
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                        // const SizedBox(width: 10),
                                                        IconButton.outlined(
                                                          onPressed: () {
                                                            setState(
                                                              () {
                                                                salesItemList
                                                                    .removeAt(
                                                                  index,
                                                                );
                                                                totalAndDiscount =
                                                                    calculateTotal(
                                                                  salesItemList,
                                                                );
                                                              },
                                                            );
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Total : ${totalAndDiscount.total}',
                                        ),
                                        Text(
                                          'Discount : ${totalAndDiscount.discount}',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          } else {
            return const Center(
              child:
                  Text("Sorry, we are embarassed that an error occurred !!!"),
            );
          }
        },
      ),
    );
  }

  TotalAndDiscount calculateTotal(List<SalesItemDTO> purchasedItems) {
    double total = 0;
    double discount = 0;

    for (int i = 0; i < purchasedItems.length; i++) {
      total += purchasedItems[i].quantity * purchasedItems[i].price;

      discount +=
          (purchasedItems[i].quantity * purchasedItems[i].discountPrice);
    }

    double totalDiscountVal = _additionalDiscountController.text.isEmpty
        ? discount
        : discount + double.parse(_additionalDiscountController.text);

    return TotalAndDiscount(
      total: total - totalDiscountVal,
      discount: totalDiscountVal,
    );
  }
}

class TotalAndDiscount {
  double total;
  double discount;

  TotalAndDiscount({required this.total, required this.discount});
}
