import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_shop_wijaya/data/models/customer/customer.dart';
import 'package:furniture_shop_wijaya/data/models/item/item.dart';

import '../../../services/firebase_service.dart';
import '../../models/category/category.dart';
import '../../models/supplier/supplier.dart';

class MainDashboardRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Stream<List<Item>> getAllItemsStream() {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference itemsCollection = firebaseFirestore.collection('items');

    return itemsCollection.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        final itemId = e.id;
        return Item(
          itemName: data['itemName'] as String,
          id: itemId,
          itemImageUrl: data['itemImageUrl'] as String,
          supplierName: data['supplierName'] as String,
          categoryName: data['categoryName'] as String,
          itemCode: data['itemCode'] as String,
          numItems: data['numItems'] as int,
          datePurchased: data['datePurchased'] as Timestamp,
          warrantyExpiryDate: data['warrantyExpiryDate'] as Timestamp,
          itemBoughtPrice: data['itemBoughtPrice'] as double,
          itemSellingPrice: data['itemSellingPrice'] as double,
          discountPrice: data['discountPrice'] as double,
        );
      }).toList();
    });
  }

  Stream<List<CategoryType>> getAllCategoriesStream() {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference itemsCollection =
        firebaseFirestore.collection('category');

    return itemsCollection.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        final id = e.id;
        return CategoryType(
          categoryName: data['categoryName'] ?? '',
          id: id,
        );
      }).toList();
    });
  }

  Stream<List<Supplier>> getAllSuppliersStream() {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference itemsCollection =
        firebaseFirestore.collection('suppliers');

    return itemsCollection.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        final supplierId = e.id;
        return Supplier(
          supplierId: supplierId,
          supplierName: data['supplierName'],
          supplierAddress: data['supplierAddress'],
          supplierEmail: data['supplierEmail'],
          supplierMobile: data['supplierMobile'],
        );
      }).toList();
    });
  }

  Stream<List<CustomerType>> getAllCustomersStream() {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference itemsCollection =
        firebaseFirestore.collection('customers');

    return itemsCollection.snapshots().map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((e) {
        final data = e.data() as Map<String, dynamic>;
        // final customerId = e.id;
        return CustomerType.fromJson(data);
      }).toList();
    });
  }
}
