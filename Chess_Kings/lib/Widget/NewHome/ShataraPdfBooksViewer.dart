import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShataraPdfBooksViewer extends StatefulWidget {
  const ShataraPdfBooksViewer({
    super.key,
    this.height = 560, // مهم داخل Scroll
  });

  final double height;

  static const String pdfUrl =
      'https://shatara.sa/shatraBooks.pdf';

  @override
  State<ShataraPdfBooksViewer> createState() =>
      _ShataraPdfBooksViewerState();
}

class _ShataraPdfBooksViewerState
    extends State<ShataraPdfBooksViewer> {
  final PdfViewerController _controller =
  PdfViewerController();

  int _pageNumber = 1;
  int _pageCount = 0;
  bool _loading = true;

  static const Color _brown = Color(0xFF6B4E45);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.stretch,
        children: [
          // شريط علوي
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: 10, vertical: 8),
            decoration: const BoxDecoration(
              color: Color(0xFFF4F5F7),
            ),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'السابق',
                  onPressed: (_pageNumber <= 1)
                      ? null
                      : () =>
                      _controller.previousPage(),
                  icon: const Icon(
                      Icons.chevron_right),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      _pageCount == 0
                          ? 'جاري تحميل الدليل...'
                          : 'صفحة $_pageNumber من $_pageCount',
                      style: const TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: 11,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'التالي',
                  onPressed:
                  (_pageCount != 0 &&
                      _pageNumber >=
                          _pageCount)
                      ? null
                      : () =>
                      _controller
                          .nextPage(),
                  icon: const Icon(
                      Icons.chevron_left),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // عارض الـ PDF
          SizedBox(
            height: widget.height,
            child: ClipRRect(
              borderRadius:
              BorderRadius.circular(6),
              child: Stack(
                children: [
                  SfPdfViewer.network(
                    ShataraPdfBooksViewer
                        .pdfUrl,
                    controller: _controller,
                    scrollDirection:
                    PdfScrollDirection
                        .vertical,
                    canShowScrollHead: true,
                    canShowScrollStatus:
                    true,
                    onDocumentLoaded:
                        (details) {
                      setState(() {
                        _pageCount = details
                            .document
                            .pages
                            .count;
                        _loading = false;
                      });
                    },
                    onPageChanged:
                        (details) {
                      setState(() {
                        _pageNumber =
                            details
                                .newPageNumber;
                      });
                    },
                    onDocumentLoadFailed:
                        (details) {
                      setState(() {
                        _loading = false;
                      });

                      ScaffoldMessenger.of(
                          context)
                          .showSnackBar(
                        SnackBar(
                          content: Text(
                            'تعذر تحميل ملف الدليل: ${details.error}',
                            textDirection:
                            TextDirection
                                .rtl,
                          ),
                        ),
                      );
                    },
                  ),

                  if (_loading)
                    const Positioned.fill(
                      child: ColoredBox(
                        color: Color(
                            0x66FFFFFF),
                        child: Center(
                          child:
                          CircularProgressIndicator(),
                        ),
                      ),
                    ),

                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 3,
                      color: _brown,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}