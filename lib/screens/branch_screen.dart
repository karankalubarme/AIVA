import 'package:flutter/material.dart';

class BranchScreen extends StatelessWidget {
  const BranchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final branches = [
      "Computer Engineering",
      "Information Technology",
      "Mechanical Engineering",
      "Civil Engineering",
      "ENTC Engineering",
      "Electrical Engineering",
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("Select Branch")),
      body: ListView.builder(
        itemCount: branches.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(branches[index]),
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