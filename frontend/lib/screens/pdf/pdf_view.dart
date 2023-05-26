import 'package:flutter/material.dart';
import '../../UI_parameters.dart' as UIParameter;
import 'package:flutter_pdfview/flutter_pdfview.dart';

class PDFViewScreen extends StatefulWidget {
  const PDFViewScreen({super.key, required this.path});
  final String path;
  @override
  State<PDFViewScreen> createState() => _PDFViewState();
}

class _PDFViewState extends State<PDFViewScreen> {
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites'),
          backgroundColor: UIParameter.MAROON,
          elevation: 0,
        ),
        // body: Container(child: SfPdfViewer.asset(widget.path)));
        body: Container(
            child: PDFView(
          filePath: widget.path,
        )));
  }
}
