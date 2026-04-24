import 'package:flutter/material.dart';

class SubjectsScreen extends StatelessWidget {
  const SubjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get branch and year from arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final String branch = args['branch'];
    final String year = args['year'];

    // Mock data for subjects based on year (In a real app, this would come from a DB)
    final Map<String, List<String>> subjectsData = {
      "First Year (FE)": ["Engineering Mathematics-I", "Engineering Physics", "Engineering Chemistry", "Systems in Mechanical Engineering", "Basic Electrical Engineering"],
      "Second Year (SE)": ["Discrete Mathematics", "Data Structures", "Computer Graphics", "Object Oriented Programming", "Digital Electronics"],
      "Third Year (TE)": ["Database Management Systems", "Computer Networks", "Theory of Computation", "Systems Programming", "Software Engineering"],
      "Final Year (BE)": ["Machine Learning", "Information Security", "Cloud Computing", "Design and Analysis of Algorithms", "Deep Learning"],
    };

    final subjects = subjectsData[year] ?? ["General Engineering"];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Subjects - $year", style: const TextStyle(fontSize: 18)),
            Text(branch, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: const Color(0xFF26C6DA),
              child: Text("${index + 1}", style: const TextStyle(color: Colors.white)),
            ),
            title: Text(subjects[index]),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/resources',
                arguments: {
                  'branch': branch,
                  'year': year,
                  'subject': subjects[index],
                },
              );
            },
          );
        },
      ),
    );
  }
}
