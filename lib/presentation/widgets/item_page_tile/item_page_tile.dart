import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/item_page/bloc/item_page_bloc_bloc.dart';
import 'package:intl/intl.dart';

import '../../../data/models/item/item.dart';

// ignore: must_be_immutable
class ItemPageTile extends StatelessWidget {
  final Item item;
  late ItemPageBlocBloc itemPageBlocBloc;

  ItemPageTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    itemPageBlocBloc = BlocProvider.of<ItemPageBlocBloc>(context);
    return GestureDetector(
      onTap: () {
        itemPageBlocBloc.add(ItemPageTileClickedEvent(item: item));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 820,
            height: 150,
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.itemCode,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            CachedNetworkImage(
                              height: 60,
                              width: 60,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              imageUrl: item.itemImageUrl,
                              placeholder: (context, url) =>
                                  const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.blueAccent,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error, size: 30),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        const SizedBox(width: 40),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Item Name',
                                    style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                Text(item.itemName,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Number of Items',
                                    style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                Text(item.numItems.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 25),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Item Bought Price',
                                    style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                Text('Rs. ${item.itemBoughtPrice}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Item Selling Price',
                                    style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                Text('Rs. ${item.itemSellingPrice}',
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Item Discount Price',
                                    style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                Text(item.discountPrice.toString(),
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(width: 25),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Supplier',
                                    style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                Text(item.supplierName,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Category',
                                    style: TextStyle(
                                        color: Color.fromRGBO(151, 151, 151, 1),
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                                Text(item.categoryName,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Date of Purchase',
                              style: TextStyle(
                                  color: Color.fromRGBO(151, 151, 151, 1),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              DateFormat('dd MMMM yyyy')
                                  .format(item.datePurchased.toDate()),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Waranty Expiary Date',
                              style: TextStyle(
                                  color: Color.fromRGBO(151, 151, 151, 1),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold)),
                          Text(
                              DateFormat('dd MMMM yyyy')
                                  .format(item.warrantyExpiryDate.toDate()),
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              'Size (L x W) : ${item.itemLength} in x ${item.itemWidth} in',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                          Text('Weight : ${item.itemWeight} kg',
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
