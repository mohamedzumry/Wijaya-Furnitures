import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:furniture_shop_wijaya/data/dto/customer/customer_dto.dart';
import 'package:furniture_shop_wijaya/data/dto/sales/sales_item_dto.dart';
import 'package:furniture_shop_wijaya/data/models/sales/invoice_metadata_model.dart';
import 'package:furniture_shop_wijaya/data/models/sales/sales_receipt_generated_result_model.dart';
import 'package:furniture_shop_wijaya/services/firebase_service.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class Receipt {
  PdfPageFormat format =
      PdfPageFormat.a4.copyWith(marginTop: 10, marginBottom: 10);
  final dateTimeNow = DateTime.now();
  String dateTime = DateFormat().add_yMd().add_jm().format(DateTime.now());

  final PdfColor themeColor = PdfColor.fromHex('#070c7f');

  final CollectionReference invoiceCollection =
      FirebaseService().firebaseFirestore.collection('invoices');

  Future<SalesReceiptGeneratedResultModel> generateReceipt(
    List<SalesItemDTO> orderData,
    CustomerTypeDTO customerData,
    double total,
    double discount,
  ) async {
    try {
      final pdf = pw.Document();
      // final logo = await imageFromAssetBundle('assets/images/wf-logo.png');
      final image = await imageFromAssetBundle('assets/images/wf-logo2.png');

      final invoiceNumber = await getNewInvoiceNumber();

      final fontRobotoRegular = await PdfGoogleFonts.robotoRegular();
      final fontRobotoBold = await PdfGoogleFonts.robotoBold();
      final fontRobotoItalic = await PdfGoogleFonts.robotoItalic();
      final fontRobotoBoldItaic = await PdfGoogleFonts.robotoBoldItalic();

      final headers = ['Item Name', 'Quantity', 'Rate', 'Amount'];

      final data = orderData
          .map((items) => [
                items.itemName,
                items.quantity.toString(),
                items.price.toString(),
                (items.price * items.quantity).toString()
              ])
          .toList();

      pdf.addPage(
        pw.MultiPage(
          theme: pw.ThemeData.withFont(
            base: fontRobotoRegular,
            bold: fontRobotoBold,
            italic: fontRobotoItalic,
            boldItalic: fontRobotoBoldItaic,
          ),
          pageFormat: format,
          header: (pw.Context context) {
            return headerTable(context, image);
          },
          footer: (pw.Context context) {
            return footer();
          },
          build: (pw.Context context) => [
            receiptBodyTable1(customerData, invoiceNumber),
            pw.SizedBox(height: 20),
            // salesTableBody(salesRows, total.toString()),
            pw.TableHelper.fromTextArray(
              headers: headers,
              headerStyle: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: themeColor),
              cellStyle: pw.TextStyle(color: themeColor),
              data: data,
              border: pw.TableBorder.all(
                color: themeColor,
              ),
              columnWidths: const <int, pw.TableColumnWidth>{
                0: pw.FlexColumnWidth(3),
                1: pw.FlexColumnWidth(1),
                2: pw.FlexColumnWidth(1),
                3: pw.FlexColumnWidth(1),
              },
            ),
            pw.SizedBox(height: 20),
            salesBodyFooter(total.toString(), discount),
          ],
        ),
      );

      final pdfBytes = pdf.save();
      final encodedBaseData = base64Encode(await pdfBytes);
      return SalesReceiptGeneratedResultModel(
        pdfBytes: pdfBytes,
        invoiceMetaData: InvoiceMetaDataModel(
          date: dateTime,
          invoiceNumber: invoiceNumber.toString(),
          encodedBaseData: encodedBaseData,
        ),
        isGenerationSuccess: true,
      );
    } catch (e) {
      return SalesReceiptGeneratedResultModel(isGenerationSuccess: false);
    }
  }

  pw.Widget headerTable(pw.Context context, pw.ImageProvider image) {
    const String svgLocation =
        '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M12 21C15.5 17.4 19 14.1764 19 10.2C19 6.22355 15.866 3 12 3C8.13401 3 5 6.22355 5 10.2C5 14.1764 8.5 17.4 12 21Z" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path> <path d="M12 13C13.6569 13 15 11.6569 15 10C15 8.34315 13.6569 7 12 7C10.3431 7 9 8.34315 9 10C9 11.6569 10.3431 13 12 13Z" stroke="#000000" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"></path> </g></svg>''';
    const svgPhone =
        '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path d="M14 2C14 2 16.2 2.2 19 5C21.8 7.8 22 10 22 10" stroke="#1C274C" stroke-width="1.5" stroke-linecap="round"></path> <path d="M14.207 5.53564C14.207 5.53564 15.197 5.81849 16.6819 7.30341C18.1668 8.78834 18.4497 9.77829 18.4497 9.77829" stroke="#1C274C" stroke-width="1.5" stroke-linecap="round"></path> <path d="M4.00655 7.93309C3.93421 9.84122 4.41713 13.0817 7.6677 16.3323C8.45191 17.1165 9.23553 17.7396 10 18.2327M5.53781 4.93723C6.93076 3.54428 9.15317 3.73144 10.0376 5.31617L10.6866 6.4791C11.2723 7.52858 11.0372 8.90532 10.1147 9.8278C10.1147 9.8278 10.1147 9.8278 10.1147 9.8278C10.1146 9.82792 8.99588 10.9468 11.0245 12.9755C13.0525 15.0035 14.1714 13.8861 14.1722 13.8853C14.1722 13.8853 14.1722 13.8853 14.1722 13.8853C15.0947 12.9628 16.4714 12.7277 17.5209 13.3134L18.6838 13.9624C20.2686 14.8468 20.4557 17.0692 19.0628 18.4622C18.2258 19.2992 17.2004 19.9505 16.0669 19.9934C15.2529 20.0243 14.1963 19.9541 13 19.6111" stroke="#1C274C" stroke-width="1.5" stroke-linecap="round"></path> </g></svg>''';
    const svgUser =
        '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <circle cx="12" cy="6" r="4" stroke="#1C274C" stroke-width="1.5"></circle> <path d="M19.9975 18C20 17.8358 20 17.669 20 17.5C20 15.0147 16.4183 13 12 13C7.58172 13 4 15.0147 4 17.5C4 19.9853 4 22 12 22C14.231 22 15.8398 21.8433 17 21.5634" stroke="#1C274C" stroke-width="1.5" stroke-linecap="round"></path> </g></svg>''';
    const svgEmail =
        '''<svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <path fill-rule="evenodd" clip-rule="evenodd" d="M3.75 5.25L3 6V18L3.75 18.75H20.25L21 18V6L20.25 5.25H3.75ZM4.5 7.6955V17.25H19.5V7.69525L11.9999 14.5136L4.5 7.6955ZM18.3099 6.75H5.68986L11.9999 12.4864L18.3099 6.75Z" fill="#080341"></path> </g></svg>''';

    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Table(
        // border: pw.TableBorder.all(),
        columnWidths: const <int, pw.TableColumnWidth>{
          0: pw.FixedColumnWidth(80),
          1: pw.FlexColumnWidth(),
        },
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          pw.TableRow(
            verticalAlignment: pw.TableCellVerticalAlignment.top,
            children: <pw.Widget>[
              pw.Container(
                height: 64,
                width: 56,
                child: pw.Image(image),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('New Wijaya Furniture',
                      style: pw.TextStyle(
                          color: themeColor,
                          fontSize: 27,
                          fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 5),
                  pw.Text('For Your Dream House',
                      style: pw.TextStyle(color: themeColor)),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            children: [
                              pw.SvgImage(
                                  svg: svgUser, colorFilter: themeColor),
                              pw.Text('C.C. Kaggodaarachchi',
                                  style: pw.TextStyle(color: themeColor)),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.SvgImage(
                                  svg: svgLocation, colorFilter: themeColor),
                              pw.Text('555, Maradana Road, Colombo 10',
                                  style: pw.TextStyle(color: themeColor)),
                            ],
                          ),
                        ],
                      ),
                      pw.SizedBox(width: 10),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.SvgImage(
                                  svg: svgPhone, colorFilter: themeColor),
                              pw.Text('+94 72 479 9032',
                                  style: pw.TextStyle(color: themeColor)),
                            ],
                          ),
                          pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.SvgImage(
                                  svg: svgEmail, colorFilter: themeColor),
                              pw.Text('wijafurniture.info@gmail.com',
                                  style: pw.TextStyle(color: themeColor)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget salesBodyFooter(String total, double discount) {
    final formattedTotal = NumberFormat("#,###").format(double.parse(total));
    final formattedDiscount = NumberFormat("#,###").format(discount);
    final formattedNetTotal =
        NumberFormat("#,###").format(double.parse(total) - discount);
    return pw.Container(
        child: pw.Column(children: [
      pw.Table(
        border: pw.TableBorder.all(color: themeColor),
        columnWidths: const <int, pw.TableColumnWidth>{
          0: pw.FlexColumnWidth(1),
          1: pw.FlexColumnWidth(1),
        },
        defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
        children: [
          if (discount > 0)
            pw.TableRow(
              children: <pw.Widget>[
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 5, vertical: 10),
                  child: pw.Text('Discount',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(color: themeColor)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 5, vertical: 10),
                  child: pw.Text('Rs. $formattedDiscount /=',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(color: themeColor)),
                ),
              ],
            ),
          if (discount > 0)
            pw.TableRow(
              children: <pw.Widget>[
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 5, vertical: 10),
                  child: pw.Text('Total',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(color: themeColor)),
                ),
                pw.Padding(
                  padding: const pw.EdgeInsets.symmetric(
                      horizontal: 5, vertical: 10),
                  child: pw.Text('Rs. $formattedTotal /=',
                      textAlign: pw.TextAlign.center,
                      style: pw.TextStyle(color: themeColor)),
                ),
              ],
            ),
          pw.TableRow(
            children: <pw.Widget>[
              pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: pw.Text('Net Total',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(color: themeColor)),
              ),
              pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                child: pw.Text('Rs. $formattedNetTotal /=',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(color: themeColor)),
              ),
            ],
          ),
        ],
      ),
      pw.SizedBox(height: 50),
      pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text('Authorized Signature : ',
              style: pw.TextStyle(color: themeColor)),
          pw.Text('..........................',
              style: pw.TextStyle(color: themeColor)),
        ],
      ),
    ]));
  }

  pw.Widget receiptBodyTable1(CustomerTypeDTO customerData, int invoiceNumber) {
    return pw.Table(
      border: pw.TableBorder.all(
        color: themeColor,
      ),
      columnWidths: const <int, pw.TableColumnWidth>{
        0: pw.FlexColumnWidth(2),
        1: pw.FlexColumnWidth(1),
      },
      defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
      children: [
        pw.TableRow(
          children: <pw.Widget>[
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text(
                'Customer Name : ${customerData.customerName}',
                style: pw.TextStyle(color: themeColor),
              ),
            ),
            // pw.Padding(
            //   padding: const pw.EdgeInsets.all(5),
            //   child: pw.Text(''),
            // ),
          ],
        ),
        pw.TableRow(
          children: <pw.Widget>[
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('Address : ${customerData.customerAddress}',
                  style: pw.TextStyle(color: themeColor)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('Invoice No : $invoiceNumber',
                  style: pw.TextStyle(color: themeColor)),
            ),
          ],
        ),
        pw.TableRow(
          children: <pw.Widget>[
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('Contact No : ${customerData.customerMobile}',
                  style: pw.TextStyle(color: themeColor)),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(5),
              child: pw.Text('Date : $dateTime',
                  style: pw.TextStyle(color: themeColor)),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget footer() {
    // return a widget widget with stating terms and conditions and below it must have a row with centered website name
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text('Terms and Conditions',
              style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold, color: themeColor)),
          pw.Text(' - Advance payment will only be valid for 1 month',
              style: pw.TextStyle(color: themeColor)),
          pw.Text(' - The receipt is required to receive warranty services',
              style: pw.TextStyle(color: themeColor)),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(vertical: 10),
            color: themeColor,
            child: pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.center,
              children: [
                pw.Text('www.newwijayafurniture.lk',
                    style: const pw.TextStyle(color: PdfColors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> saveReceiptMetadata(InvoiceMetaDataModel invoiceMD) async {
    await invoiceCollection.add({
      'date': invoiceMD.date,
      'invoiceNumber': invoiceMD.invoiceNumber,
      'encodedBaseData': invoiceMD.encodedBaseData,
    });
  }

  Future<int> getNewInvoiceNumber() async {
    final CollectionReference invoiceCollection =
        FirebaseService().firebaseFirestore.collection('invoices');

    QuerySnapshot querySnapshot = await invoiceCollection
        .orderBy('invoiceNumber', descending: true)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return int.parse(querySnapshot.docs.first.get('invoiceNumber')) + 1;
    } else {
      return 1;
    }
  }

  Future<void> printReceipt(Future<Uint8List> pdfBytes) async {
    await Printing.layoutPdf(
      format: format,
      onLayout: (PdfPageFormat format) async => pdfBytes,
    );
  }

  Future<List<InvoiceMetaDataModel>> retrieveInvoices() async {
    List<InvoiceMetaDataModel> invoices = [];

    // Get all documents from the invoice collection
    QuerySnapshot querySnapshot = await invoiceCollection.get();

    // Convert each document into an Invoice object
    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      InvoiceMetaDataModel invoice = InvoiceMetaDataModel(
        id: doc.id,
        date: data['date'],
        invoiceNumber: data['invoiceNumber'],
        encodedBaseData: data['encodedBaseData'],
      );

      invoices.add(invoice);
    }

    return invoices;
  }
}
