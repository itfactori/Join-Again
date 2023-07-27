import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewingScreen extends StatefulWidget {
  final dynamic file;
  const PdfViewingScreen({Key? key, this.file}) : super(key: key);

  @override
  State<PdfViewingScreen> createState() => _PdfViewingScreenState();
}

class _PdfViewingScreenState extends State<PdfViewingScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Syncfusion Flutter PDF Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.white,
              semanticLabel: 'Bookmark',
            ),
            onPressed: () {
              _pdfViewerKey.currentState?.openBookmarkView();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.file!,
        key: _pdfViewerKey,
      ),
    );
  }
}
