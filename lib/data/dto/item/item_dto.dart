import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';

class ItemDTO {
  String? itemName;
  String? supplierName;
  String? categoryName;
  String? itemCode;
  int? numItems;
  Timestamp? datePurchased;
  Timestamp? warrantyExpiryDate;
  double? itemLength;
  double? itemWidth;
  double? itemWeight;
  double? itemBoughtPrice;
  double? itemSellingPrice;
  double? discountPrice;
  Uint8List? selectedImageInBytes;
  String? itemImageUrl;
  ItemDTO({
    this.itemImageUrl,
    this.itemName,
    this.supplierName,
    this.categoryName,
    this.itemCode,
    this.numItems,
    this.datePurchased,
    this.warrantyExpiryDate,
    this.itemLength,
    this.itemWidth,
    this.itemWeight,
    this.itemBoughtPrice,
    this.itemSellingPrice,
    this.discountPrice,
    this.selectedImageInBytes,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemImageUrl': itemImageUrl,
      'itemName': itemName,
      'supplierName': supplierName,
      'categoryName': categoryName,
      'itemCode': itemCode,
      'numItems': numItems,
      'datePurchased': datePurchased,
      'warrantyExpiryDate': warrantyExpiryDate,
      'itemLength': itemLength,
      'itemWidth': itemWidth,
      'itemWeight': itemWeight,
      'itemBoughtPrice': itemBoughtPrice,
      'itemSellingPrice': itemSellingPrice,
      'discountPrice': discountPrice,
      // 'selectedImageInBytes': selectedImageInBytes,
    };
  }
}
