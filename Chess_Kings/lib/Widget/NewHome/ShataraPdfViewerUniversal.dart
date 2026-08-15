import 'package:Chess_Cleverness/Widget/NewHome/shatara_pdf_viewer_native.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'ShataraPdfBooksViewer.dart'; // للموبايل (syncfusion)


class ShataraPdfViewerUniversal extends StatelessWidget {
  const ShataraPdfViewerUniversal({super.key, this.height = 600});
  final double height;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return ShataraPdfWebViewer(height: height);
    }
    return ShataraPdfBooksViewer(height: height);
  }
}