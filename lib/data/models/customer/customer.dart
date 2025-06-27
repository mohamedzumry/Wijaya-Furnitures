class CustomerType {
  final String customerNIC;
  final String customerName;
  final String customerMobile;
  final String customerAddress;
  CustomerType({
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

  factory CustomerType.fromJson(Map<String, dynamic> json) {
    return CustomerType(
      customerNIC: json['customerNIC'],
      customerName: json['customerName'],
      customerMobile: json['customerMobile'],
      customerAddress: json['customerAddress'],
    );
  }
}
