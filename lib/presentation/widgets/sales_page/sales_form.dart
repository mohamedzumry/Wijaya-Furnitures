// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:furniture_shop_wijaya/data/dto/sales/sales_item_dto.dart';
// import 'package:furniture_shop_wijaya/data/models/item/item.dart';
// import 'package:dropdown_search/dropdown_search.dart';

// import '../../../business_logic/sales_page/sales_page_bloc.dart';

// class SalesForm extends StatefulWidget {
//   final Stream<List<Item>> itemList;
//   final List<SalesItemDTO> salesitemList;
//   const SalesForm(
//       {super.key, required this.itemList, required this.salesitemList});

//   @override
//   State<SalesForm> createState() => _SalesFormState();
// }

// class _SalesFormState extends State<SalesForm> {
//   final GlobalKey<_SalesFormItemsDropdownState> salesFormItemsDropdownKey =
//       GlobalKey<_SalesFormItemsDropdownState>();
//   bool isOnlinePurchase = false;

//   // late final SalesPageBloc salesPageBloc;

//   // @override
//   // void initState() {
//   //   salesPageBloc = BlocProvider.of<SalesPageBloc>(context);
//   //   salesPageBloc.add(SalesPageFormInitialFetchEvent());
//   //   super.initState();
//   // }

//   @override
//   void didUpdateWidget(covariant SalesForm oldWidget) {
//     context.read<SalesPageBloc>().add(SalesPageSummaryDataFetchEvent(
//         isOnlinePurchase,
//         salesItems: oldWidget.salesitemList));
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     List<SalesItemDTO> salesItemList = widget.salesitemList;
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           SalesFormItemsDropdown(
//             fieldKey: salesFormItemsDropdownKey,
//             itemList: widget.itemList,
//           ),
//           const SizedBox(height: 5),
//           QuantityTextField(),
//           const SizedBox(height: 10),
//           SubmitButton(
//             onSubmitClicked: () {
//               String selectedItem =
//                   salesFormItemsDropdownKey.currentState?.selectedItemName ??
//                       "";
//               int quantity =
//                   int.tryParse(QuantityTextField()._qtyController.text) ?? 0;

//               SalesItemDTO salesItem =
//                   SalesItemDTO(itemName: selectedItem, quantity: quantity, price: );

//               setState(() {
//                 salesItemList.add(salesItem);
//               });

//               // Add item to the purchase list
//               // context.read<SalesPageBloc>().add(
//               //       AddSalesItemEvent(salesItems: widget.salesitemList),
//               //     );
//             },
//           ),
//           const SizedBox(height: 30),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Radio(
//                 value: true,
//                 groupValue: isOnlinePurchase,
//                 // groupValue: successState.isOnlinePurchased,
//                 onChanged: (_) => context
//                     .read<SalesPageBloc>()
//                     .add(const SelectSalesTypeEvent(isOnlinePurchase: true)),
//               ),
//               const Text('Online Purchase'),
//               Radio(
//                 value: false,
//                 groupValue: isOnlinePurchase,
//                 // groupValue: successState.isOnlinePurchased,
//                 onChanged: (_) => context
//                     .read<SalesPageBloc>()
//                     .add(const SelectSalesTypeEvent(isOnlinePurchase: false)),
//               ),
//               const Text('Offline Purchase'),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class SalesFormItemsDropdown extends StatefulWidget {
//   final Stream<List<Item>> itemList;
//   const SalesFormItemsDropdown(
//       {super.key, required Key fieldKey, required this.itemList});

//   @override
//   State<SalesFormItemsDropdown> createState() => _SalesFormItemsDropdownState();
// }

// class _SalesFormItemsDropdownState extends State<SalesFormItemsDropdown> {
//   String selectedItemName = "";
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: widget.itemList,
//       builder: (context, AsyncSnapshot<List<Item>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const CircularProgressIndicator();
//         }

//         if (!snapshot.hasData || snapshot.data!.isEmpty) {
//           return const Center(
//             child: Text('Please add a item first.'),
//           );
//         }
//         List<String> itemNames =
//             snapshot.data?.map((item) => item.itemName).toList() ?? [];

//         return DropdownSearch(
//           popupProps: const PopupProps.menu(showSearchBox: true),
//           clearButtonProps:
//               const ClearButtonProps(icon: Icon(Icons.close_rounded)),
//           items: itemNames,
//           selectedItem: itemNames[0],
//           onChanged: (value) {
//             selectedItemName = value!;
//           },
//         );
//       },
//     );
//   }
// }

// class QuantityTextField extends StatelessWidget {
//   QuantityTextField({super.key});

//   final TextEditingController _qtyController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       controller: _qtyController,
//       keyboardType: TextInputType.number,
//       onChanged: (value) {},
//       decoration: const InputDecoration(
//         labelText: "Quantity",
//         hintText: "Eg: 25",
//         border: OutlineInputBorder(),
//       ),
//     );
//   }
// }

// class SubmitButton extends StatelessWidget {
//   final VoidCallback onSubmitClicked;
//   const SubmitButton({super.key, required this.onSubmitClicked});

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onSubmitClicked,
//       child: const Text('Submit'),
//     );
//   }
// }
