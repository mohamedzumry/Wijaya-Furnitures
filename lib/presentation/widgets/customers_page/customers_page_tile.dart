import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/customer_page/customer_page_bloc.dart';

import '../../../data/models/customer/customer.dart';

class CustomersPageTile extends StatelessWidget {
  final CustomerType customerType;
  const CustomersPageTile({super.key, required this.customerType});

  @override
  Widget build(BuildContext context) {
    CustomerPageBloc customerPageBloc =
        BlocProvider.of<CustomerPageBloc>(context);
    return GestureDetector(
      onTap: () {
        customerPageBloc
            .add(CustomersPageTileClickedEvent(customerType: customerType));
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            width: 700,
            height: 90,
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: const BorderRadius.all(
                Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.verified, color: Colors.grey, size: 20),
                            SizedBox(width: 5),
                            Text(
                              "Customer NIC: ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 350,
                        child: Text(
                          customerType.customerNIC,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Row(
                          children: [
                            Container(
                              height: 20,
                              width: 20,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                    image: AssetImage(
                                        'assets/images/customer1.png')),
                              ),
                            ),
                            const SizedBox(width: 15),
                            SizedBox(
                              width: 150,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text('Customer Name',
                                      style: TextStyle(
                                          color:
                                              Color.fromRGBO(151, 151, 151, 1),
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold)),
                                  Text(customerType.customerName,
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
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Contact Number',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                151, 151, 151, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      customerType.customerMobile,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 350,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Customer Address',
                                        style: TextStyle(
                                            color: Color.fromRGBO(
                                                151, 151, 151, 1),
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold)),
                                    Text(
                                      customerType.customerAddress,
                                      style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
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
