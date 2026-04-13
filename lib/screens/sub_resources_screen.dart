import 'package:flutter/material.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final resources = [
      "PDF Notes",
      "PYQ Papers",
      "Lecture Videos",
      "Mini Projects",
      "Viva Questions",
      "Interview Questions",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Study Resources")),
      body: ListView.builder(
        itemCount: resources.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(resources[index]),
            trailing: const Icon(Icons.open_in_new),
            onTap: () {
              // Open PDF / Video / Page
            },
          );
        },
      ),
    );
  }
}