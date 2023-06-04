import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' as mt;
import '../../UI_parameters.dart' as UIParameter;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../classes.dart';
import 'pdf_model.dart';

class PDFViewScreen extends StatelessWidget {
  const PDFViewScreen({super.key, required this.estabData});
  final List<AccomCardDetails>? estabData;
  // const PDFViewScreen({super.key});

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
    List<PDFData> estabList = [];

    print(estabData);

    for (var e in estabData!) {
      PDFData nonFuture = await createPDFData(e.getID());
      estabList.add(nonFuture);
    }

    // final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(pw.MultiPage(
      pageFormat: format,
      build: (pw.Context context) => [
        pw.Column(
          children: [
            // TO ADD: HEADER

            // CREATION OF BOXES IN PDF
            for (var estab in estabList)
              pw.Container(
                  decoration: pw.BoxDecoration(border: pw.Border.all()),
                  // padding: const pw.EdgeInsets.all(16.0),
                  child: pw.Column(children: [
                    pw.SizedBox(
                      height: 10,
                    ),
                    pw.Row(
                      children: [
                        pw.SizedBox(width: 10),
                        // IMAGE INSERT HERE
                        pw.Expanded(
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text(estab.estabName,
                                  style: pw.Theme.of(context)
                                      .defaultTextStyle
                                      .copyWith(
                                          fontWeight: pw.FontWeight.bold)),
                              // pw.Text(estab.exactLoc),
                              pw.Text(estab.estabType),
                              pw.Text(estab.tenantType),
                              pw.Text(estab.utilities),
                              pw.SizedBox(height: 10),
                              pw.Text("Owner Information",
                                  style: pw.Theme.of(context)
                                      .defaultTextStyle
                                      .copyWith(
                                          fontWeight: pw.FontWeight.bold)),
                              pw.Text(estab.ownerContact),
                              pw.Text(estab.ownerEmail),
                            ],
                          ),
                        ),
                        pw.SizedBox(width: 10),
                        pw.Expanded(
                            child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          mainAxisAlignment: pw.MainAxisAlignment.start,
                          children: [
                            pw.Text("Rooms in this Establishment",
                                style: pw.Theme.of(context)
                                    .defaultTextStyle
                                    .copyWith(fontWeight: pw.FontWeight.bold)),
                            for (var r in estab.rooms)
                              pw.Row(
                                children: [
                                  // pw.Icon(Icons.check_circle_outline, ) // TO IMPLEMENT: ICONS CHECK or X for availability
                                  pw.Text(
                                      "PHP${r.priceLower.toString()}-${r.priceUpper.toString()} for ${r.capacity.toString()}"),
                                  if (r.available)
                                    pw.Text(" [AVAILABLE]")
                                  else
                                    pw.Text(" [UNAVAILABLE]")
                                ],
                              )
                          ],
                        )),
                        pw.SizedBox(width: 10)
                      ],
                    ),
                    pw.SizedBox(height: 20),
                  ]))
          ],
        )
      ],
    ));
    return pdf.save();
  }
}
