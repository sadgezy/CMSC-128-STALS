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
      title: "PDFavorites",
      theme: ThemeData(primaryColor: UIParameter.MAROON, fontFamily: 'Georgia'),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("PDFavorites."),
          backgroundColor: UIParameter.MAROON,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.pop(context);
            },
            color: Colors.black,
          ),
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

    for (var e in estabData!) {
      PDFData nonFuture = await createPDFData(e.getID());
      if (nonFuture.utilities == "[]") {
        nonFuture.utilities = "No utilities specified.";
      }
      if (nonFuture.rooms.isEmpty) {}
      estabList.add(nonFuture);
    }

    // final font = await PdfGoogleFonts.nunitoExtraLight();

    pdf.addPage(pw.MultiPage(
      pageFormat: format,
      theme: pw.ThemeData.withFont(
        base: await PdfGoogleFonts.notoSansGeorgianRegular(),
        bold: await PdfGoogleFonts.notoSansGeorgianBold(),
      ),
      build: (pw.Context context) => [
        pw.Column(
          children: [
            // TO ADD: HEADER
            pw.Center(
              child: pw.Text("YOUR ELBEDS SUMMARY SHEET",
                  style: pw.TextStyle(
                    fontSize: 25,
                    fontStyle: pw.FontStyle.italic,
                    fontWeight: pw.FontWeight.bold,
                  )),
            ),
            pw.SizedBox(height: 10),
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
                              pw.Text(estab.exactLoc),
                              pw.Text(
                                estab.estabType[0].toUpperCase() + estab.estabType.substring(1).toLowerCase()
                                   + " for " +  estab.tenantType[0].toUpperCase() + estab.tenantType.substring(1).toLowerCase()),
                              // pw.Text(estab.tenantType),
                              //pw.SizedBox(height: 10),
                              //pw.Text(estab.utilities),
                              pw.SizedBox(height: 10),
                              pw.Text("Owner Information",
                                  style: pw.Theme.of(context)
                                      .defaultTextStyle
                                      .copyWith(
                                          fontWeight: pw.FontWeight.bold)),
                              pw.Text(estab.ownerName),
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
                            if (estab.rooms.isNotEmpty)
                              for (var r in estab.rooms)
                                pw.Row(
                                  children: [
                                    // pw.Icon(Icons.check_circle_outline, ) // TO IMPLEMENT: ICONS CHECK or X for availability
                                    pw.Text(
                                        "PHP${r.priceLower.toString()}-${r.priceUpper.toString()} for ${r.capacity.toString()}"),
                                    if (r.available)
                                      pw.Text(" [AVAILABLE]")
                                    else
                                      pw.Text(" [UNAVAILABLE]"),
                                  ],
                                )
                            else
                              pw.Text("No rooms detail available.",
                                  style: pw.Theme.of(context)
                                      .defaultTextStyle
                                      .copyWith(fontWeight: pw.FontWeight.bold))
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
