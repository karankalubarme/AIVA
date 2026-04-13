import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OCRScreen extends StatefulWidget {
  const OCRScreen({super.key});

  @override
  State<OCRScreen> createState() => _OCRScreenState();
}

class _OCRScreenState extends State<OCRScreen> {
  File? imageFile;
  String extractedText = "";
  bool isLoading = false;

  final ImagePicker picker = ImagePicker();

  // 📸 Camera
  Future<void> pickFromCamera() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      extractText();
    }
  }

  // 🖼️ Gallery
  Future<void> pickFromGallery() async {
    final pickedFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });
      extractText();
    }
  }

  // 🔍 OCR
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      appBar: AppBar(
        title: const Text("OCR Scanner"),
        centerTitle: true,
        backgroundColor: const Color(0xFF26C6DA),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : null,
          gradient: isDark
              ? null
              : const LinearGradient(
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFB2EBF2),
              Color(0xFF80DEEA),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),

            // 🔹 BUTTON CARD
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: pickFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF26C6DA),
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: pickFromGallery,
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      const Color(0xFF26C6DA),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 15),

            // 🔹 IMAGE PREVIEW
            if (imageFile != null)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),

            const SizedBox(height: 10),

            // 🔹 LOADING
            if (isLoading)
              const Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(),
              ),

            // 🔥 MAIN FIX: TAKE FULL REMAINING SPACE
            Expanded(
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.all(15),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: const Color(0xFF26C6DA),
                      width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color:
                      Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.text_snippet,
                            color: Color(0xFF26C6DA)),
                        SizedBox(width: 8),
                        Text(
                          "Scanned Text",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                    const Divider(),

                    // 🔥 Fills space properly
                    Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          extractedText.isEmpty
                              ? "No text detected yet..."
                              : extractedText,
                          style: TextStyle(
                            fontSize: 15,
                            color: textColor,
                          ),
                        ),
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