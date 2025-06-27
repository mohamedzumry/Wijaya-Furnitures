class ItemUpdateDTO {
  String id;
  String? itemName;
  String? supplierName;
  String? categoryName;
  String? itemCode;
  int? numItems;
  // Timestamp? datePurchased;
  // Timestamp? warrantyExpiryDate;
  double? itemLength;
  double? itemWidth;
  double? itemWeight;
  double? itemBoughtPrice;
  double? itemSellingPrice;
  double? discountPrice;
  // String? itemImageUrl;
  ItemUpdateDTO({
    required this.id,
    // this.itemImageUrl,
    this.itemName,
    this.supplierName,
    this.categoryName,
    this.itemCode,
    this.numItems,
    // this.datePurchased,
    // this.warrantyExpiryDate,
    this.itemLength,
    this.itemWidth,
    this.itemWeight,
    this.itemBoughtPrice,
    this.itemSellingPrice,
    this.discountPrice,
  });

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'supplierName': supplierName,
      'categoryName': categoryName,
      'itemCode': itemCode,
      'numItems': numItems,
      'itemLength': itemLength,
      'itemWidth': itemWidth,
      'itemWeight': itemWeight,
      'itemBoughtPrice': itemBoughtPrice,
      'itemSellingPrice': itemSellingPrice,
      'discountPrice': discountPrice,
    };
  }
}
