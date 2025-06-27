import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:furniture_shop_wijaya/data/models/customer/customer.dart';
import 'package:furniture_shop_wijaya/services/firebase_service.dart';

class CustomerRepository {
  final FirebaseService _firebaseService = FirebaseService();
  Future<List<CustomerType>> getAllCustomers() async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference categoryCollection =
        firebaseFirestore.collection('customers');

    QuerySnapshot querySnapshot = await categoryCollection.get();

    final customers = querySnapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      // final id = e.id;
      return CustomerType(
        customerNIC: data['customerNIC'] ?? '',
        customerName: data['customerName'] ?? '',
        customerMobile: data['customerMobile'] ?? '',
        customerAddress: data['customerAddress'] ?? '',
      );
    }).toList();

    return customers;
  }

  Future<List<CustomerType>> getCustomersBySearchQuery(String query) async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference customersCollection =
        firebaseFirestore.collection('customers');

    late QuerySnapshot querySnapshot;

    if (query.isNotEmpty) {
      String lastLetter = query.substring(query.length - 1);
      String upperBound = query.substring(0, query.length - 1) +
          String.fromCharCode(lastLetter.codeUnitAt(0) + 1);

      querySnapshot = await customersCollection
          .where('customerName', isGreaterThanOrEqualTo: query)
          .where('customerName', isLessThan: upperBound)
          .get();
    } else {
      querySnapshot = await customersCollection.get();
    }

    final customers = querySnapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      // final id = e.id;
      return CustomerType(
        customerNIC: data['customerNIC'] ?? '',
        customerName: data['customerName'] ?? '',
        customerMobile: data['customerMobile'] ?? '',
        customerAddress: data['customerAddress'] ?? '',
      );
    }).toList();

    return customers;
  }

  Future<List<CustomerType>> getCustomersByMobileNumber(String mn) async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference customersCollection =
        firebaseFirestore.collection('customers');

    final list =
        await customersCollection.get().then((value) => value.docs.map((e) {
              final data = e.data() as Map<String, dynamic>;
              // final id = e.id;
              return CustomerType(
                customerNIC: data['customerNIC'] ?? '',
                customerName: data['customerName'] ?? '',
                customerMobile: data['customerMobile'] ?? '',
                customerAddress: data['customerAddress'] ?? '',
              );
            }).toList());

    final queriedList =
        list.where((element) => element.customerMobile.contains(mn)).toList();

    return queriedList;
  }

  Future<List<CustomerType>> getCustomersByNIC(
      String customerNIC, List<CustomerType> allCustomers) async {
    // FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;

    if (customerNIC.isNotEmpty) {
      return allCustomers
          .where((element) => element.customerNIC
              .toLowerCase()
              .contains(customerNIC.toLowerCase()))
          .toList();
    } else {
      return allCustomers;
    }
    // CollectionReference customersCollection =
    //     firebaseFirestore.collection('customers');

    // final list = await customersCollection
    //     .where('customerNIC', isEqualTo: customerNIC)
    //     .get()
    //     .then((value) {
    //   return value.docs.map((e) {
    //     final data = e.data() as Map<String, dynamic>;
    //     return CustomerType.fromJson(data);
    //   }).toList();
    // });

    // return list;
  }

  Future<bool> saveCustomerDetails(Map<String, dynamic> map) async {
    try {
      CollectionReference customersCollection =
          _firebaseService.firebaseFirestore.collection('customers');

      await customersCollection.add(map);
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error saving customer details: $e");
      }
      return false;
    }
  }

  Future<bool> updateCustomers(CustomerType customerType) async {
    try {
      CollectionReference customersCollection =
          _firebaseService.firebaseFirestore.collection('customers');

      await customersCollection
          .where('customerNIC', isEqualTo: customerType.customerNIC)
          .get()
          .then((value) {
        for (var element in value.docs) {
          customersCollection.doc(element.id).update(customerType.toJson());
        }
      });
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error updating customer: $e");
      }
      return false;
    }
  }

  Future<bool> deleteCustomer(String customerId) async {
    try {
      CollectionReference customersCollection =
          _firebaseService.firebaseFirestore.collection('customers');

      await customersCollection.doc(customerId).delete();
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error deleting customer: $e");
      }
      return false;
    }
  }
}
