class CustomerTypeDTO {
  final String customerNIC;
  final String customerName;
  final String customerMobile;
  final String customerAddress;

  CustomerTypeDTO({
    required this.customerNIC,
    required this.customerName,
    required this.customerMobile,
    required this.customerAddress,
  });

  Map<String, dynamic> toJson() {
    return {
      'customerNIC': customerNIC,
      'customerName': customerName,
      'customerMobile': customerMobile,
      'customerAddress': customerAddress,
    };
  }
}
