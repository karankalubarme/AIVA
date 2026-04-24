import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({super.key, required this.url, required this.title});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  String? localPath;
  bool isLoading = true;
  String error = '';

  @override
  void initState() {
    super.initState();
    _downloadPdf();
  }

  Future<void> _downloadPdf() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = widget.url.split('/').last;
      final filePath = "${directory.path}/$fileName";

      if (await File(filePath).exists()) {
        setState(() {
          localPath = filePath;
          isLoading = false;
        });
        return;
      }

      final dio = Dio();
      await dio.download(widget.url, filePath);

      setState(() {
        localPath = filePath;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        error = "Error loading PDF: $e";
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: const Color(0xFF00ACC1),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF00ACC1)))
          : error.isNotEmpty
              ? Center(child: Text(error, textAlign: TextAlign.center))
              : PDFView(
                  filePath: localPath,
                  enableSwipe: true,
                  swipeHorizontal: false,
                  autoSpacing: true,
                  pageFling: true,
                  onRender: (pages) {
                    print("Rendered $pages pages");
                  },
                  onError: (e) {
                    setState(() {
                      error = e.toString();
                    });
                  },
                ),
    );
  }
}
