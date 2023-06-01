import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'pdf_model.dart';

class PDFViewScreen extends StatelessWidget {
  const PDFViewScreen({super.key, required this.estabData});
  final List<PDFData> estabData;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("PDFavorites.")),
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
          return pw.Column(
            children: [
              buildEstabTiles(estabData),
            ],
          );
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
