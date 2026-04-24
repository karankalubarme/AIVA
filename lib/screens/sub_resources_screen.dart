import 'package:flutter/material.dart';
import 'pdf_viewer_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get subject, branch and year from arguments
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String subject = args?['subject'] ?? "General";
    
    final resources = [
      {"title": "PDF Notes", "icon": Icons.picture_as_pdf, "color": Colors.red, "url": "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf"},
      {"title": "Previous Year Papers (PYQ)", "icon": Icons.history_edu, "color": Colors.blue, "url": "https://www.adobe.com/support/products/enterprise/knowledgecenter/pdfs/acrobat_qr_r1.pdf"},
      {"title": "Question Bank", "icon": Icons.quiz, "color": Colors.orange, "url": ""},
      {"title": "Reference Books", "icon": Icons.menu_book, "color": Colors.green, "url": ""},
      {"title": "Video Lectures", "icon": Icons.play_circle_fill, "color": Colors.purple, "url": ""},
      {"title": "Lab Manuals", "icon": Icons.science, "color": Colors.teal, "url": ""},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(subject),
        elevation: 0,
        backgroundColor: const Color(0xFF00ACC1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFE0F7FA), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
          ),
          itemCount: resources.length,
          itemBuilder: (context, index) {
            final res = resources[index];
            return InkWell(
              onTap: () {
                final url = res['url'] as String;
                if (url.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PdfViewerScreen(
                        url: url,
                        title: "${res['title']} - $subject",
                      ),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No content available for ${res['title']} yet.")),
                  );
                }
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(res['icon'] as IconData, size: 40, color: res['color'] as Color),
                    const SizedBox(height: 12),
                    Text(
                      res['title'] as String,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
