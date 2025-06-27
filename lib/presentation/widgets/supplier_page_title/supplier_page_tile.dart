import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/supplier_page/bloc/supplier_page_bloc.dart';
import 'package:furniture_shop_wijaya/data/models/supplier/supplier.dart';

// ignore: must_be_immutable
class SupplierPageTile extends StatelessWidget {
  late SupplierPageBloc supplierPageBloc;
  final Supplier supplier;
  SupplierPageTile({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    supplierPageBloc = BlocProvider.of<SupplierPageBloc>(context);
    return GestureDetector(
      onTap: () {
        supplierPageBloc.add(SupplierPageTileClickedEvent(supplier: supplier));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 500,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.blue[50],
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
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 30,
                        decoration: const BoxDecoration(
                            image: DecorationImage(
                                image:
                                    AssetImage('assets/images/supplier.png'))),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 150,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Supplier Name',
                                style: TextStyle(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            Text(supplier.supplierName,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 75,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Mobile',
                                style: TextStyle(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            Text('0${supplier.supplierMobile}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      SizedBox(
                        width: 175,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Email Address',
                                style: TextStyle(
                                    color: Color.fromRGBO(151, 151, 151, 1),
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            Text(supplier.supplierEmail,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Address',
                            style: TextStyle(
                                color: Color.fromRGBO(151, 151, 151, 1),
                                fontSize: 10,
                                fontWeight: FontWeight.bold)),
                        Text(supplier.supplierAddress,
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
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
