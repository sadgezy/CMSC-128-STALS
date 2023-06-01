import 'dart:typed_data';
import 'package:flutter/services.dart';

import '../../UI_parameters.dart' as UIParameter;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'pdf_model.dart';

//DUMMY FOR PDF
List<PDFData> estabData = [
  PDFData(
      "PDF 1",
      "assets/images/room_stock.jpg",
      "Within Campus",
      "11 L Street",
      "Dormitory",
      "Ceat Students.",
      "0000000",
      "gg@wp.com",
      "mabango", []),
  PDFData(
      "PDF 2",
      "assets/images/room_stock.jpg",
      "Beyond Junction",
      "B7 L23 Jade St.",
      "House",
      "Working",
      "0000000",
      "gg@wp.com",
      "toilet", []),
];

class PDFViewScreen extends StatelessWidget {
  // const PDFViewScreen({super.key, required this.estabData});
  // final List<PDFData> estabData;
  const PDFViewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("PDFavorites."),
          backgroundColor: UIParameter.MAROON,
        ),
        body: PdfPreview(
          maxPageWidth: 700,
          build: (format) => _generatePdf(format),
        ),
      ),
    );
  }

  Future<Uint8List> _generatePdf(PdfPageFormat format) async {
    final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: false);
    // final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(
      pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return buildEstabTiles(estabData);
        },
      ),
    );
    return pdf.save();
  }

  pw.Widget buildEstabTiles(List<PDFData> estabData) => pw.Container(
        child: pw.Column(
          children: [
            for (var estab in estabData)
              pw.Row(
                children: [
                  // pw.Expanded(
                  // child: pw.Icon(Icons.warning)
                  // child: pw.Image(
                  //   pw.MemoryImage(await _loadImage(estab.image)),
                  // ),
                  // ),
                  pw.Expanded(
                    child: pw.Column(
                      children: [
                        pw.Text(estab.estabName),
                        pw.Text(estab.approxLoc),
                        pw.Text(estab.exactLoc),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      );

  Future<Uint8List> _loadImage(String imagePath) async {
    final ByteData imageData = await rootBundle.load(imagePath);
    return imageData.buffer.asUint8List();
  }
}
