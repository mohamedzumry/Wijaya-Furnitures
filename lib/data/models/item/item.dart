import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String itemName;
  final String supplierName;
  final String categoryName;
  final String itemCode;
  final int numItems;
  final Timestamp datePurchased;
  final Timestamp warrantyExpiryDate;
  final double? itemWidth;
  final double? itemLength;
  final double? itemWeight;
  final double itemBoughtPrice;
  final double itemSellingPrice;
  final double discountPrice;
  final String itemImageUrl;

  Item(
      {required this.id,
      required this.itemImageUrl,
      required this.itemName,
      required this.supplierName,
      required this.categoryName,
      required this.itemCode,
      required this.numItems,
      required this.datePurchased,
      required this.warrantyExpiryDate,
      this.itemLength,
      this.itemWidth,
      this.itemWeight,
      required this.itemBoughtPrice,
      required this.itemSellingPrice,
      required this.discountPrice});

  // factory Item.fromJson(Map<String, dynamic> json) {
  //   return Item(
  //     itemName: json['itemName'] as String,
  //     id: json['id'] as String,
  //     itemImageUrl: json['itemImageUrl'] as String,
  //     supplierName: json['supplierName'] as String,
  //     categoryName: json['categoryName'] as String,
  //     itemCode: json['itemCode'] as String,
  //     numItems: json['numItems'] as int,
  //     datePurchased: json['datePurchased'] as Timestamp,
  //     warrantyExpiryDate: json['warrantyExpiryDate'] as Timestamp,
  //     itemLength: json['itemLength'] as double,
  //     itemWidth: json['itemWidth'] as double,
  //     itemWeight: json['itemWeight'] as double,
  //     itemBoughtPrice: json['itemBoughtPrice'] as double,
  //     itemSellingPrice: json['itemSellingPrice'] as double,
  //     discountPrice: json['discountPrice'] as double,
  //   );
  // }

  // Create a to json method for the item with querysnapshot to set the id
  factory Item.fromQuerySnapshot(Map<String, dynamic> data, String id) {
    return Item(
      itemName: data['itemName'] as String,
      id: id,
      itemImageUrl: data['itemImageUrl'] as String,
      supplierName: data['supplierName'] as String,
      categoryName: data['categoryName'] as String,
      itemCode: data['itemCode'] as String,
      numItems: data['numItems'] as int,
      datePurchased: data['datePurchased'] as Timestamp,
      warrantyExpiryDate: data['warrantyExpiryDate'] as Timestamp,
      itemLength: data['itemLength'] as double,
      itemWidth: data['itemWidth'] as double,
      itemWeight: data['itemWeight'] as double,
      itemBoughtPrice: data['itemBoughtPrice'] as double,
      itemSellingPrice: data['itemSellingPrice'] as double,
      discountPrice: data['discountPrice'] as double,
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     'itemName': itemName,
  //     'id': id,
  //     'itemImageUrl': itemImageUrl,
  //     'supplierName': supplierName,
  //     'categoryName': categoryName,
  //     'itemCode': itemCode,
  //     'numItems': numItems,
  //     'datePurchased': datePurchased,
  //     'warrantyExpiryDate': warrantyExpiryDate,
  //     'itemLength': itemLength,
  //     'itemWidth': itemWidth,
  //     'itemWeight': itemWeight,
  //     'itemBoughtPrice': itemBoughtPrice,
  //     'itemSellingPrice': itemSellingPrice,
  //     'discountPrice': discountPrice,
  //   };
  // }
}
