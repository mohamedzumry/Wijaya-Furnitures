class InvoiceMetaDataModel {
  String? id; // Unique identifier for the invoice
  String? date;
  String? invoiceNumber;
  String? encodedBaseData; // Base64 encoded PDF data

  InvoiceMetaDataModel({
    this.id,
    this.date,
    this.invoiceNumber,
    this.encodedBaseData,
  });

  InvoiceMetaDataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    invoiceNumber = json['invoiceNumber'];
    encodedBaseData = json['encodedBaseData'];
  }
}
