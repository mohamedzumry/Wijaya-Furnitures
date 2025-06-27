class Supplier {
  final String supplierId;
  final String supplierName;
  final String supplierAddress;
  final String supplierEmail;
  final int supplierMobile;

  Supplier(
      {required this.supplierId,
      required this.supplierName,
      required this.supplierAddress,
      required this.supplierEmail,
      required this.supplierMobile});

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'supplierName': supplierName,
      'supplierAddress': supplierAddress,
      'supplierEmail': supplierEmail,
      'supplierMobile': supplierMobile,
    };
  }

  factory Supplier.fromJson(Map<String, dynamic> json, String id) {
    return Supplier(
      supplierId: id,
      supplierName: json['supplierName'],
      supplierAddress: json['supplierAddress'],
      supplierEmail: json['supplierEmail'],
      supplierMobile: json['supplierMobile'],
    );
  }
}
