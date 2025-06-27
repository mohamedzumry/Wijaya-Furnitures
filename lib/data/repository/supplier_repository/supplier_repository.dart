import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:furniture_shop_wijaya/data/models/supplier/supplier.dart';
import 'package:furniture_shop_wijaya/services/firebase_service.dart';

class SupplierRepository {
  final FirebaseService _firebaseService = FirebaseService();
  Future<List<Supplier>> getAllSuppliers() async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference suppliersCollection =
        firebaseFirestore.collection('suppliers');

    QuerySnapshot querySnapshot = await suppliersCollection.get();

    final suppliers = querySnapshot.docs.map((e) {
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

    return suppliers;
  }

  Future<List<Supplier>> getAllSuppliersBySearchQuery(String query) async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference suppliersCollection =
        firebaseFirestore.collection('suppliers');

    late QuerySnapshot querySnapshot;
    if (query.isNotEmpty) {
      String lastLetter = query.substring(query.length - 1);
      String upperBound = query.substring(0, query.length - 1) +
          String.fromCharCode(lastLetter.codeUnitAt(0) + 1);

      querySnapshot = await suppliersCollection
          .where('supplierName', isGreaterThanOrEqualTo: query)
          .where('supplierName', isLessThan: upperBound)
          .get();
    } else if (query.isEmpty) {
      querySnapshot = await suppliersCollection.get();
    }

    final suppliers = querySnapshot.docs.map((e) {
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

    return suppliers;
  }

  Future<bool> saveSupplierDetails(Map<String, dynamic> map) async {
    try {
      CollectionReference postsCollection =
          _firebaseService.firebaseFirestore.collection('suppliers/');

      await postsCollection.add(map);
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error saving supplier details: $e");
      }
      return false;
    }
  }

  Future<bool> deleteSupplier(String supplierId) async {
    try {
      CollectionReference suppliersCollection =
          _firebaseService.firebaseFirestore.collection('suppliers');

      await suppliersCollection.doc(supplierId).delete();
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error deleting supplier: $e");
      }
      return false;
    }
  }

  Future<bool> updateSupplier(Supplier supplier) async {
    try {
      CollectionReference suppliersCollection =
          _firebaseService.firebaseFirestore.collection('suppliers');

      await suppliersCollection.doc(supplier.supplierId).update({
        'supplierName': supplier.supplierName,
        'supplierAddress': supplier.supplierAddress,
        'supplierEmail': supplier.supplierEmail,
        'supplierMobile': supplier.supplierMobile,
      });
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error updating supplier: $e");
      }
      return false;
    }
  }

  Future<bool> isSupplierAssigned(String supplierName) async {
    bool isAssigned = false;

    // Fetch all items from the Items collection
    final itemsCollection = FirebaseFirestore.instance.collection('items');
    final itemsSnapshot = await itemsCollection.get();

    // Iterate through the items
    for (final itemDocument in itemsSnapshot.docs) {
      final itemData = itemDocument.data();
      final itemSupplierName = itemData['supplierName'];

      // Check if supplier ID matches
      if (supplierName == itemSupplierName) {
        isAssigned = true;
        break;
      }
    }

    return isAssigned;
  }
}
