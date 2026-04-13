import 'package:flutter/material.dart';

class YearScreen extends StatelessWidget {
  const YearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final years = [
      "First Year (FE)",
      "Second Year (SE)",
      "Third Year (TE)",
      "Final Year (BE)",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Select Year")),
      body: ListView.builder(
        itemCount: years.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(years[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(context, '/subjects');
            },
          );
        },
      ),
    );
  }
}