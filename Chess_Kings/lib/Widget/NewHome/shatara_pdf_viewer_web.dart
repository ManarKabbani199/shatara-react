import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class ShataraPdfWebViewer extends StatefulWidget {
  const ShataraPdfWebViewer({
    super.key,
    this.height = 600,
  });

  final double height;

  static const String pdfUrl = 'https://shatara.sa/shatraBooks.pdf';

  @override
  State<ShataraPdfWebViewer> createState() => _ShataraPdfWebViewerState();
}

class _ShataraPdfWebViewerState extends State<ShataraPdfWebViewer> {
  static const String _viewType = 'shatara-pdf-iframe-view';
  static bool _registered = false;

  @override
  void initState() {
    super.initState();

    if (!_registered) {
      ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
        final iframe = html.IFrameElement()
          ..src = ShataraPdfWebViewer.pdfUrl
          ..style.border = 'none'
          ..style.width = '100%'
          ..style.height = '100%';

        return iframe;
      });

      _registered = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: const HtmlElementView(viewType: _viewType),
    );
  }
}