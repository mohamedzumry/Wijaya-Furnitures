import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:furniture_shop_wijaya/services/firebase_service.dart';
import '../../models/category/category.dart';

class CategoryRepository {
  final FirebaseService _firebaseService = FirebaseService();
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

  Future<List<CategoryType>> getCategoriesBySearchQuery(String query) async {
    FirebaseFirestore firebaseFirestore = _firebaseService.firebaseFirestore;
    CollectionReference categoryCollection =
        firebaseFirestore.collection('category');

    late QuerySnapshot querySnapshot;

    if (query.isNotEmpty) {
      String lastLetter = query.substring(query.length - 1);
      String upperBound = query.substring(0, query.length - 1) +
          String.fromCharCode(lastLetter.codeUnitAt(0) + 1);

      querySnapshot = await categoryCollection
          .where('categoryName', isGreaterThanOrEqualTo: query)
          .where('categoryName', isLessThan: upperBound)
          .get();
    } else {
      querySnapshot = await categoryCollection.get();
    }

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

  Future<bool> saveCategoryDetails(Map<String, dynamic> map) async {
    try {
      CollectionReference categoryCollection =
          _firebaseService.firebaseFirestore.collection('category/');

      await categoryCollection.add(map);
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error saving category details: $e");
      }
      return false;
    }
  }

  Future<bool> updateCategory(CategoryType categoryType) async {
    try {
      CollectionReference categoryCollection =
          _firebaseService.firebaseFirestore.collection('category');

      await categoryCollection.doc(categoryType.id).update({
        'categoryName': categoryType.categoryName,
      });
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error updating category: $e");
      }
      return false;
    }
  }

  Future<bool> deleteCategory(String categoryId) async {
    try {
      CollectionReference categoryCollection =
          _firebaseService.firebaseFirestore.collection('category');

      await categoryCollection.doc(categoryId).delete();
      return true;
    } on Exception catch (e) {
      if (kDebugMode) {
        print("Error deleting category: $e");
      }
      return false;
    }
  }

  Future<bool> isCategoryAssigned(String categoryName) async {
    // Fetch all items from the Items collection
    final itemsCollection = FirebaseFirestore.instance.collection('items');
    final itemsSnapshot = await itemsCollection.get();

    // Iterate through the items
    for (final itemDocument in itemsSnapshot.docs) {
      final itemData = itemDocument.data();
      final tempCategoryName = itemData['categoryName'];

      // Check if category ID matches
      if (categoryName == tempCategoryName) {
        return true;
      }
    }
    return false;
  }
}
