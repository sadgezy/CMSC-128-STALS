import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart' as mt;
import '../../UI_parameters.dart' as UIParameter;
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import 'pdf_model.dart';

//DUMMY FOR PDF
List<PDFData> estabData = [
  PDFData(
      "Bahay ni Kuya",
      "assets/images/room_stock.jpg",
      "Within Campus",
      "11 L Street Los Banos City",
      "Dormitory",
      "Ceat Students.",
      "09172222222",
      "gg@wp.com",
      "mabango, friendly, malinis",
      [Room(5000, 1, false), Room(3000, 1, true), Room(10000, 4, true)]),
  PDFData(
      "PDF 2",
      "assets/images/room_stock.jpg",
      "Beyond Junction",
      "B7 L23 Jade St. Calamba City",
      "House",
      "Working",
      "09172222222",
      "gg@wp.com",
      "toilet, aircon, pets allowed",
      [Room(22000, 8, true)]),
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
          return pw.Column(
            children: [
              for (var estab in estabData)
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
                                pw.Text(estab.approxLoc),
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
                                      .copyWith(
                                          fontWeight: pw.FontWeight.bold)),
                              for (var r in estab.rooms)
                                pw.Row(
                                  children: [
                                    // pw.Icon(Icons.check_circle_outline, ) // TO IMPLEMENT: ICONS CHECK or X for availability
                                    pw.Text(
                                        "PHP${r.price.toString()} for ${r.capacity.toString()}"),
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
          );
        },
      ),
    );
    return pdf.save();
  }

  // pw.Widget buildEstabTiles(List<PDFData> estabData) => pw.Container(
  //       child: pw.Column(
  //         children: [
  //           for (var estab in estabData)
  //             pw.Row(
  //               children: [
  //                 // pw.Expanded(
  //                 // child: pw.Icon(Icons.warning)
  //                 // child: pw.Image(
  //                 //   pw.MemoryImage(await _loadImage(estab.image)),
  //                 // ),
  //                 // ),
  //                 pw.Expanded(
  //                   child: pw.Column(
  //                     children: [
  //                       pw.Text(estab.estabName,
  //                           style: pw.Theme.of(context)
  //                               .defaultTextStyle
  //                               .copyWith(fontWeight: pw.FontWeight.bold)),
  //                       pw.Text(estab.approxLoc),
  //                       pw.Text(estab.exactLoc),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //         ],
  //       ),
  //     );

  Future<Uint8List> _loadImage(String imagePath) async {
    final ByteData imageData = await rootBundle.load(imagePath);
    return imageData.buffer.asUint8List();
  }
}
