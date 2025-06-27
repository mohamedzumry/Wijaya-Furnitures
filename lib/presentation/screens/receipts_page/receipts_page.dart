import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:furniture_shop_wijaya/business_logic/receipts_page/receipts_page_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../../data/models/sales/invoice_metadata_model.dart';

class ReceiptsPage extends StatefulWidget {
  const ReceiptsPage({super.key});

  @override
  State<ReceiptsPage> createState() => _ReceiptsPageState();
}

class _ReceiptsPageState extends State<ReceiptsPage> {
  late ReceiptsPageBloc receiptsPageBloc;
  DateTime? selectedDateStart;
  DateTime? selectedDateEnd;
  Map<int, Color?> hoverColors = {};
  @override
  void initState() {
    super.initState();
    receiptsPageBloc = BlocProvider.of<ReceiptsPageBloc>(context);
    receiptsPageBloc.add(ReceiptsPageInitialEvent());
  }

  List<String> getSuggestions(
      String query, List<InvoiceMetaDataModel> allInvoices) {
    // return all invoiceNumbers that starts with the query
    List<String> matches = [];
    for (var invoice in allInvoices) {
      if (invoice.invoiceNumber!.startsWith(query)) {
        matches.add(invoice.invoiceNumber!);
      }
    }
    return matches;
  }

  DateTime formatDate(String date) {
    final parsedDate = DateFormat("MM/dd/yyyy").parse(date);
    // DateTime invoiceDate =
    //     DateTime.parse(DateFormat("mm-dd-yy").format(parsedDate));
    return parsedDate;
  }

  List<InvoiceMetaDataModel> getFilteredInvoices(
      List<InvoiceMetaDataModel> invoices) {
    if (selectedDateStart != null && selectedDateEnd != null) {
      return invoices.where((invoice) {
        final invoiceDate = formatDate(invoice.date!);
        return invoiceDate.isAfter(selectedDateStart!) &&
            invoiceDate.isBefore(selectedDateEnd!);
      }).toList();
    } else if (selectedDateStart != null) {
      return invoices.where((invoice) {
        return formatDate(invoice.date!).isAtSameMomentAs(selectedDateStart!);
      }).toList();
    } else if (selectedDateEnd != null) {
      return invoices.where((invoice) {
        return formatDate(invoice.date!).isAtSameMomentAs(selectedDateEnd!);
      }).toList();
    }
    return invoices;
  }

  Future<void> showInvoiceDialog(InvoiceMetaDataModel invoice) async {
    // Convert base64 encoded PDF data back to uint8List
    if (invoice.encodedBaseData != null) {
      // final uint8ListPdf = await invoice.encodedBaseData!;
      final uint8ListPdf = base64Decode(invoice.encodedBaseData!);

      // Convert uint8List to PDF document
      PdfPageFormat format = PdfPageFormat.a4;

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Invoice - ${invoice.invoiceNumber}'),
            content: SizedBox(
              height: 850,
              width: 650,
              child: PdfPreview(
                canChangePageFormat: false,
                canChangeOrientation: false,
                actions: [
                  TextButton(
                    onPressed: () {
                      context.pop();
                    },
                    child: const Text('Close',
                        style: TextStyle(color: Colors.white)),
                  ),
                  TextButton(
                    onPressed: () {
                      context.pop();
                      showDeleteInvoiceDialog(invoice.invoiceNumber!);
                    },
                    child: const Text('Delete',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
                initialPageFormat: format,
                build: (format) => uint8ListPdf,
                padding: const EdgeInsets.all(0),
              ),
            ),
          );
        },
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No PDF found...'),
        ),
      );
    }
  }

  Future<void> showDeleteInvoiceDialog(String invoiceNumber) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Invoice'),
          content: const Text('Are you sure you want to delete this invoice?'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                receiptsPageBloc.add(
                  ReceiptsPageDeleteReceiptEvent(invoiceNumber),
                );
              },
              child: const Text('Delete Now'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReceiptsPageBloc, ReceiptsPageState>(
      bloc: receiptsPageBloc,
      listenWhen: (previous, current) => current is ReceiptsPageActionState,
      buildWhen: (previous, current) => current is! ReceiptsPageActionState,
      listener: (context, state) {
        if (state is ReceiptsPageDeleteReceiptSuccessState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invoice deleted successfully...'),
            ),
          );
          receiptsPageBloc.add(ReceiptsPageInitialEvent());
        } else if (state is ReceiptsPageDeleteReceiptFailedState) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to delete invoice...'),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ReceiptsPageLoadedState) {
          return StreamBuilder(
            stream: state.invoices,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.black),
                );
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                  child: Text('No receipts found...'),
                );
              }
              final List<InvoiceMetaDataModel> allInvoices = [];

              var pdfs = snapshot.data!.toList();
              for (var pdf in pdfs) {
                allInvoices.add(InvoiceMetaDataModel(
                  invoiceNumber: pdf.invoiceNumber,
                  date: pdf.date,
                  encodedBaseData: pdf.encodedBaseData,
                ));
              }
              return Column(
                children: [
                  const Text(
                    'Receipts',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    '(Latest 15 receipts are shown below, you can find more receipts by searching invoice number)',
                  ),
                  const SizedBox(height: 15),
                  const Divider(),
                  Container(
                    width: 650,
                    height: 600,
                    padding: const EdgeInsets.all(3),
                    // margin: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text(
                          'Search by invoice number',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 400,
                          child: Autocomplete<String>(
                            // optionsMaxHeight: 250,
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              final query = textEditingValue.text.toLowerCase();
                              return getSuggestions(query, allInvoices);
                            },
                            onSelected: (String invoiceNumber) {
                              final invoice = allInvoices.firstWhere(
                                  (invoice) =>
                                      invoice.invoiceNumber == invoiceNumber);
                              showInvoiceDialog(invoice);
                            },
                            optionsViewBuilder: (context,
                                Function(String) onSelected,
                                Iterable<String> options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 4.0,
                                  color: Colors.grey[100],
                                  child: SizedBox(
                                    height: 250,
                                    width: 400,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(8.0),
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final option = options.elementAt(index);
                                        return Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: ListTile(
                                            mouseCursor:
                                                SystemMouseCursors.click,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                            ),
                                            title: Text(
                                                'Invoice Number : $option'),
                                            hoverColor: Colors.blue,
                                            tileColor: Colors.grey[200],
                                            onTap: () {
                                              onSelected(option);
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                            // fieldViewBuilder:
                            //     (context, textEditingController, focusNode, suggestionsBox) {
                            //   return TextField(
                            //     controller: invoiceNumberController,
                            //     focusNode: focusNode,
                            //     decoration: const InputDecoration(
                            //       labelText: 'Invoice Number',
                            //     ),
                            //   );
                            // },
                          ),
                        ),
                        const SizedBox(height: 25),
                        SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('From Date: '),
                              IconButton(
                                icon: const Icon(Icons.calendar_today_outlined),
                                onPressed: () async {
                                  final selectedDateStart =
                                      await showDatePicker(
                                    initialDatePickerMode: DatePickerMode.day,
                                    initialDate: DateTime.now(),
                                    context: context,
                                    firstDate: DateTime(2023),
                                    lastDate: DateTime(2100),
                                  );
                                  if (selectedDateStart != null) {
                                    setState(() {
                                      this.selectedDateStart =
                                          selectedDateStart;
                                    });
                                  }
                                },
                              ),
                              Text(selectedDateStart?.toString() ??
                                  'Select Date'),
                              const SizedBox(width: 20),
                              const Text('To Date: '),
                              IconButton(
                                  icon:
                                      const Icon(Icons.calendar_today_outlined),
                                  onPressed: () async {
                                    selectedDateEnd = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          selectedDateEnd ?? DateTime.now(),
                                      firstDate: DateTime(2000),
                                      lastDate: DateTime(2050),
                                    );
                                    setState(() {});
                                  }),
                              Text(
                                  selectedDateEnd?.toString() ?? 'Select Date'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          height: 10,
                          // color: Colors.amber,
                        ),
                        SizedBox(
                          height: 400,
                          // color: Colors.red,
                          child: Column(children: [
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount:
                                    getFilteredInvoices(allInvoices).length > 15
                                        ? 15
                                        : getFilteredInvoices(allInvoices)
                                            .length,
                                itemBuilder: (context, index) {
                                  final invoice =
                                      getFilteredInvoices(allInvoices)[index];

                                  return MouseRegion(
                                    onEnter: (event) {
                                      setState(() {
                                        hoverColors[index] = Colors.blue;
                                      });
                                    },
                                    onExit: (event) {
                                      setState(() {
                                        hoverColors[index] = null;
                                      });
                                    },
                                    child: GestureDetector(
                                      onTap: () {
                                        showInvoiceDialog(invoice);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.only(
                                            left: 15, right: 15),
                                        margin:
                                            const EdgeInsets.only(bottom: 8),
                                        height: 50,
                                        width: double.maxFinite,
                                        decoration: BoxDecoration(
                                          color: hoverColors[index] ??
                                              Colors.grey[300],
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Invoice No: ${invoice.invoiceNumber!}',
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                            Text(
                                              invoice.date!,
                                              style:
                                                  const TextStyle(fontSize: 12),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        } else if (state is ReceiptsPageLoadingState) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        } else {
          return const Center(
            child: Text('Some error occurred loading receipts page...'),
          );
        }
      },
    );
  }
}




// Expanded(
//                                 child: ListView.builder(
//                                   shrinkWrap: true,
//                                   itemCount: getFilteredInvoices(allInvoices)
//                                               .length >
//                                           15
//                                       ? 15
//                                       : getFilteredInvoices(allInvoices).length,
//                                   itemBuilder: (context, index) {
//                                     final invoice =
//                                         getFilteredInvoices(allInvoices)[index];
//                                     return Container(
//                                       margin: const EdgeInsets.symmetric(
//                                           vertical: 3),
//                                       child: ListTile(
//                                         mouseCursor: SystemMouseCursors.click,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius:
//                                               BorderRadius.circular(5),
//                                         ),
//                                         tileColor: Colors.grey[300],
//                                         hoverColor: Colors.blue,
//                                         title: Text(invoice.invoiceNumber!),
//                                         trailing: Text(invoice.date!),
//                                         onTap: () {
//                                           showInvoiceDialog(invoice);
//                                         },
//                                       ),
//                                     );
//                                   },
//                                 ),
//                               ),
