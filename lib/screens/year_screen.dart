import 'package:flutter/material.dart';

class YearScreen extends StatelessWidget {
  const YearScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get branch from arguments
    final Map<String, dynamic> args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String branch = args['branch'];

    final years = [
      "First Year (FE)",
      "Second Year (SE)",
      "Third Year (TE)",
      "Final Year (BE)",
    ];

    return Scaffold(
      appBar: AppBar(title: Text("Select Year - $branch")),
      body: ListView.builder(
        itemCount: years.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(years[index]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/subjects',
                arguments: {
                  'branch': branch,
                  'year': years[index],
                },
              );
            },
          );
        },
      ),
    );
  }
}
