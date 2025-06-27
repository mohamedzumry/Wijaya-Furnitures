import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:furniture_shop_wijaya/data/models/item/item.dart';
import 'package:furniture_shop_wijaya/data/models/supplier/supplier.dart';

import '../../models/category/category.dart';
import '../../../services/firebase_service.dart';

class ItemRepository {
  final FirebaseService _firebaseService = FirebaseService();

  Future<List<Item>> getAllItems() async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference itemsCollection = firebaseFirestore.collection('items');

    QuerySnapshot querySnapshot = await itemsCollection.get();

    // final items = querySnapshot.docs.map((e) {
    //   final data = e.data() as Map<String, dynamic>;
    //   final itemId = e.id;
    //   return Item(
    //     itemName: data['itemName'] as String,
    //     id: itemId,
    //     itemImageUrl: data['itemImageUrl'] as String,
    //     supplierName: data['supplierName'] as String,
    //     categoryName: data['categoryName'] as String,
    //     itemCode: data['itemCode'] as String,
    //     numItems: data['numItems'] as int,
    //     datePurchased: data['datePurchased'] as Timestamp,
    //     warrantyExpiryDate: data['warrantyExpiryDate'] as Timestamp,
    //     itemBoughtPrice: data['itemBoughtPrice'] as double,
    //     itemSellingPrice: data['itemSellingPrice'] as double,
    //     discountPrice: data['discountPrice'] as double,
    //   );
    // }).toList();

    // map the querysnapshot to the item model using fromQuerySnapshot factory
    final items = querySnapshot.docs
        .map((e) =>
            Item.fromQuerySnapshot(e.data() as Map<String, dynamic>, e.id))
        .toList();

    return items;
  }

  Future<List<Item>> searchItemsByQuery(
      String query, List<Item> allItems) async {
    if (query.isNotEmpty) {
      return allItems
          .where((element) =>
              element.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    } else {
      return allItems;
    }
  }

  Future<List<Supplier>> getAllSuppliers() async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference supplierCollection =
        firebaseFirestore.collection('suppliers');

    QuerySnapshot querySnapshot = await supplierCollection.get();

    final suppliers = querySnapshot.docs
        .map((e) => Supplier.fromJson(e.data() as Map<String, dynamic>, e.id))
        .toList();

    return suppliers;
  }

  Future<List<CategoryType>> getAllCategories() async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference categoryCollection =
        firebaseFirestore.collection('category');

    QuerySnapshot querySnapshot = await categoryCollection.get();

    final categories = querySnapshot.docs.map((e) {
      final data = e.data() as Map<String, dynamic>;
      final id = e.id;
      return CategoryType(
        categoryName: data['categoryName'] ?? '',
        id: id,
      );
    }).toList();

    return categories;
  }

  Future<bool> saveDataItem(Map<String, dynamic> map) async {
    try {
      CollectionReference itemCollection =
          _firebaseService.firebaseFirestore.collection('items/');

      await itemCollection.add(map);
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error saving item details: $e");
      }
      return false;
    }
  }

  // Update Item
  Future<bool> updateItem(Map<String, dynamic> map, String itemId) async {
    try {
      CollectionReference itemCollection =
          _firebaseService.firebaseFirestore.collection('items');

      await itemCollection.doc(itemId).update(map);
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error updating item details: $e");
      }
      return false;
    }
  }

  Future<String> uploadItemImageToStorage(Uint8List imageFile) async {
    try {
      Reference storageReference = _firebaseService.firebaseStorage.ref().child(
          '/images/item-images/${DateTime.now().millisecondsSinceEpoch}.png');

      final metadata = SettableMetadata(contentType: 'image/jpeg');

      UploadTask uploadTask = storageReference.putData(imageFile, metadata);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => {});
      String downloadURL = await taskSnapshot.ref.getDownloadURL();
      return downloadURL;
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future<bool> deleteItem(String itemId, String imageUrl) async {
    try {
      // Delete the image from Firebase Storage using the imageURL
      Reference storageReference =
          _firebaseService.firebaseStorage.refFromURL(imageUrl);
      await storageReference.delete();

      CollectionReference itemCollection =
          _firebaseService.firebaseFirestore.collection('items');

      await itemCollection.doc(itemId).delete();

      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error deleting item: $e");
      }
      return false;
    }
  }
}
