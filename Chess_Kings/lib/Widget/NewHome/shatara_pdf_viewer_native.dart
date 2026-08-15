import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShataraPdfWebViewer extends StatelessWidget {
  const ShataraPdfWebViewer({
    super.key,
    this.height = 600,
  });

  final double height;

  static const String pdfUrl = 'https://shatara.sa/shatraBooks.pdf';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: SfPdfViewer.network(pdfUrl),
    );
  }
}