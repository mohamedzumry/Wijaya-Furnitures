import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/sales_page/sales_page_bloc.dart';
import 'package:furniture_shop_wijaya/data/dto/sales/sales_item_dto.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class SalesSummary extends StatefulWidget {
  final List<SalesItemDTO> salesItems;
  const SalesSummary({super.key, required this.salesItems});

  @override
  State<SalesSummary> createState() => _SalesSummaryState();
}

class _SalesSummaryState extends State<SalesSummary> {
  late final SalesPageBloc salesPageBloc;
  List<SalesItemDTO> salesItemList = [];

  // @override
  // void initState() {
  //   salesPageBloc = BlocProvider.of<SalesPageBloc>(context);
  //   salesPageBloc.add(
  //       SalesPageSummaryDataFetchEvent(salesItems: widget.salesItems, true));
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final SalesPageBloc salesPageBloc = BlocProvider.of<SalesPageBloc>(context);
    return BlocBuilder<SalesPageBloc, SalesPageState>(
      bloc: salesPageBloc,
      builder: (context, state) {
        if (state is SalesPageSummaryDataFetchLoadingState) {
          return Center(
            child: LoadingAnimationWidget.fourRotatingDots(
                color: Colors.blue, size: 30),
          );
        } else if (state is SalesPageSummaryDataFetchSuccessState) {
          salesItemList = state.salesItems;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // List of purchased items
                Expanded(
                  child: ListView.builder(
                    itemCount: state.salesItems.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(state.salesItems[index].itemName),
                        subtitle: Text(
                            'Quantity: ${state.salesItems[index].quantity}'),
                      );
                    },
                  ),
                ),
                const Divider(),
                Text('Total: ${calculateTotal(state.salesItems)}'),
                Text('Subtotal: ${calculateSubtotal(state.salesItems)}'),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text("No Items added..."),
          );
        }
      },
    );
  }

  String calculateTotal(List<SalesItemDTO> purchasedItems) {
    // Implement your logic to calculate the total
    return "Total Amount";
  }

  String calculateSubtotal(List<SalesItemDTO> purchasedItems) {
    // Implement your logic to calculate the subtotal
    return "Subtotal Amount";
  }
}
