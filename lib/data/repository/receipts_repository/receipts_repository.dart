import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:furniture_shop_wijaya/data/models/sales/invoice_metadata_model.dart';

import '../../../services/firebase_service.dart';

class ReceiptsRepository {
  final invoiceCollection =
      FirebaseService().firebaseFirestore.collection('invoices');
  Stream<List<InvoiceMetaDataModel>> getAllInvoices() {
    final snapshots = invoiceCollection.snapshots();

    return snapshots.map((event) {
      final sortedDocs =
          List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(event.docs)
            ..sort((b, a) =>
                int.parse(a['invoiceNumber']) - int.parse(b['invoiceNumber']));
      return sortedDocs
          .map((e) => InvoiceMetaDataModel.fromJson(e.data()))
          .toList();
    });
  }

  bool deleteInvoice(String invoiceNumber) {
    try {
      final Future<QuerySnapshot<Map<String, dynamic>>> snapshot =
          invoiceCollection
              .where('invoiceNumber', isEqualTo: invoiceNumber)
              .get();

      snapshot.then((value) => value.docs.first.reference.delete());
      return true;
    } catch (e) {
      return false;
    }
  }
}
