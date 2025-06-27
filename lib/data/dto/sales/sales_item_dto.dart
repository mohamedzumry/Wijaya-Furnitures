class SalesItemDTO {
  String itemName;
  int quantity;
  double price;
  double discountPrice;

  SalesItemDTO(
      {required this.itemName,
      required this.quantity,
      required this.price,
      required this.discountPrice});

  Map<String, dynamic> toJson() {
    return {
      'itemName': itemName,
      'quantity': quantity,
      'price': price,
      'discountPrice': discountPrice,
    };
  }
}
