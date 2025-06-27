class SupplierDTO {
  final String supplierName;
  final String supplierAddress;
  String supplierEmail;
  final int supplierMobile;

  SupplierDTO(
      {required this.supplierName,
      required this.supplierAddress,
      this.supplierEmail = "",
      required this.supplierMobile});

  Map<String, dynamic> toJson() {
    return {
      'supplierName': supplierName,
      'supplierAddress': supplierAddress,
      'supplierEmail': supplierEmail,
      'supplierMobile': supplierMobile,
    };
  }
}
