import 'package:flutter/foundation.dart';
import 'package:furniture_shop_wijaya/data/models/sales/invoice_metadata_model.dart';

class SalesReceiptGeneratedResultModel {
  final Future<Uint8List>? pdfBytes;
  final bool isGenerationSuccess;
  final InvoiceMetaDataModel? invoiceMetaData;

  SalesReceiptGeneratedResultModel(
      {this.pdfBytes, this.invoiceMetaData, required this.isGenerationSuccess});
}
