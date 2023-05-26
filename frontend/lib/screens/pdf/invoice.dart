import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:open_document/open_document.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'pdf_model.dart';

class PdfDocumentService {
  Future<Uint8List> createInvoice(List<PDFData> estabData) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Text("Customer Name"),
                      pw.Text("Customer Address"),
                      pw.Text("Customer City"),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Text("Max Weber"),
                      pw.Text("Weird Street Name 1"),
                      pw.Text("77662 Not my City"),
                      pw.Text("Vat-id: 123456"),
                      pw.Text("Invoice-Nr: 00001")
                    ],
                  )
                ],
              ),
              pw.SizedBox(height: 50),
              pw.Text(
                  "Dear Customer, thanks for buying at Flutter Explained, feel free to see the list of items below."),
              pw.SizedBox(height: 25),
              pw.SizedBox(height: 25),
              buildEstabTiles(estabData),
              pw.Text("Thanks for your trust, and till the next time."),
              pw.SizedBox(height: 25),
              pw.Text("Kind regards,"),
              pw.SizedBox(height: 25),
              pw.Text("Max Weber")
            ],
          );
        },
      ),
    );
    return pdf.save();
  }

  Future<String> savePdfFile(String fileName, Uint8List byteList) async {
    var dir = await getTemporaryDirectory();
    var filePath = ("${dir.path}/data.pdf");
    final file = File(filePath);
    await file.writeAsBytes(byteList, flush: true);
    return file.path;
  }

  static pw.Widget buildEstabTiles(List<PDFData> estabData) => pw.Container(
        child: pw.Column(
          children: [
            for (var estab in estabData)
              pw.Row(
                children: [
                  // pw.Expanded(
                  //     child: pw.Image(
                  //         pw.MemoryImage((rootBundle.load(d.image)) as Uint8List))),
                  pw.Expanded(
                      child: pw.Column(
                    children: [
                      pw.Text(
                        estab.estabName,
                      ),
                      pw.Text(estab.approxLoc),
                      pw.Text(estab.exactLoc),
                    ],
                  ))
                ],
              ),
          ],
        ),
      );
}
