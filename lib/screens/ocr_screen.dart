import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import '../services/appwrite_data_service.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  File? imageFile;
  String extractedText = "";
  bool isLoading = false;
  final AppwriteDataService _dataService = AppwriteDataService();

  final ImagePicker picker = ImagePicker();

  Future<void> pickFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
      extractText();
    }
  }

  Future<void> pickFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => imageFile = File(pickedFile.path));
      extractText();
    }
  }

  Future<void> extractText() async {
    if (imageFile == null) return;
    setState(() {
      isLoading = true;
      extractedText = "";
    });

    try {
      final textRecognizer = TextRecognizer();
      final inputImage = InputImage.fromFile(imageFile!);
      final recognizedText = await textRecognizer.processImage(inputImage);

      setState(() {
        extractedText = recognizedText.text.trim();
        if (extractedText.isEmpty) {
          extractedText = "No text detected in this image.";
        }
        isLoading = false;
      });
      await textRecognizer.close();
    } catch (e) {
      setState(() {
        extractedText = "Error during text recognition: $e";
        isLoading = false;
      });
    }
  }

  Future<void> saveResult() async {
    if (extractedText.isEmpty || extractedText.startsWith("No text") || extractedText.startsWith("Error")) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("No valid text to save")));
      return;
    }

    final doc = await _dataService.saveOCRScan(extractedText);
    if (doc != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved to history!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text("OCR Scanner"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => Navigator.pushNamed(context, '/history'),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark ? null : const LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(onPressed: pickFromCamera, icon: const Icon(Icons.camera_alt), label: const Text("Camera")),
                  ElevatedButton.icon(onPressed: pickFromGallery, icon: const Icon(Icons.photo), label: const Text("Gallery")),
                ],
              ),
            ),
            const SizedBox(height: 15),
            if (imageFile != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(20)),
                child: ClipRRect(borderRadius: BorderRadius.circular(20), child: Image.file(imageFile!, fit: BoxFit.cover)),
              ),
            if (isLoading) const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator()),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF26C6DA), width: 1.5),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Scanned Text", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        IconButton(icon: const Icon(Icons.save, color: Color(0xFF26C6DA)), onPressed: saveResult),
                      ],
                    ),
                    const Divider(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(extractedText.isEmpty ? "No text detected yet..." : extractedText, style: TextStyle(fontSize: 15, color: textColor)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
