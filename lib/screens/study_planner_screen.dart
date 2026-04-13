import 'package:flutter/material.dart';

class StudyPlannerScreen extends StatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  State<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTasks = [];

  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  String selectedPriority = "Medium";

  // 📅 Pick Date
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        filterTasks();
      });
    }
  }

  // ➕ Add Task
  void addTask() {
    if (controller.text.isEmpty) return;

    setState(() {
      tasks.add({
        "title": controller.text,
        "date": selectedDate,
        "done": false,
        "priority": selectedPriority
      });
      controller.clear();
      filterTasks();
    });
  }

  // 🔍 Filter by Date
  void filterTasks() {
    filteredTasks = tasks.where((task) {
      return task["date"].toString().split(' ')[0] ==
          selectedDate.toString().split(' ')[0];
    }).toList();
    setState(() {});
  }

  // 🔎 Search
  void searchTasks(String query) {
    filteredTasks = tasks.where((task) {
      return task["title"]
          .toLowerCase()
          .contains(query.toLowerCase());
    }).toList();
    setState(() {});
  }

  // ❌ Delete
  void deleteTask(int index) {
    tasks.remove(filteredTasks[index]);
    filterTasks();
  }

  // ✔ Toggle
  void toggleTask(int index) {
    setState(() {
      filteredTasks[index]["done"] =
      !filteredTasks[index]["done"];
    });
  }

  // ✏️ Edit
  void editTask(int index) {
    controller.text = filteredTasks[index]["title"];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                filteredTasks[index]["title"] =
                    controller.text;
                controller.clear();
              });
              Navigator.pop(context);
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  // 📊 Progress
  double getProgress() {
    if (filteredTasks.isEmpty) return 0;
    int done = filteredTasks.where((t) => t["done"]).length;
    return done / filteredTasks.length;
  }

  Color getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;
      case "Medium":
        return Colors.orange;
      default:
        return Colors.green;
    }
  }

  @override
  void initState() {
    super.initState();
    filterTasks();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark ? Colors.white : Colors.black87;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Study Planner"),
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

            // 🔍 SEARCH
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: searchController,
                onChanged: searchTasks,
                decoration: const InputDecoration(
                  hintText: "Search task...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 📅 DATE + PROGRESS
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          color: Color(0xFF26C6DA)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          selectedDate.toString().split(' ')[0],
                          style: TextStyle(color: textColor),
                        ),
                      ),
                      TextButton(
                          onPressed: pickDate,
                          child: const Text("Change")),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: getProgress(),
                    minHeight: 8,
                    color: const Color(0xFF26C6DA),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ➕ ADD TASK
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Enter task...",
                      prefixIcon: Icon(Icons.edit),
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Text("Priority: "),
                      DropdownButton<String>(
                        value: selectedPriority,
                        underline: const SizedBox(),
                        items: ["High", "Medium", "Low"]
                            .map((p) => DropdownMenuItem(
                            value: p, child: Text(p)))
                            .toList(),
                        onChanged: (val) {
                          setState(() {
                            selectedPriority = val!;
                          });
                        },
                      ),
                      const Spacer(),
                      ElevatedButton.icon(
                        onPressed: addTask,
                        icon: const Icon(Icons.add),
                        label: const Text("Add"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          const Color(0xFF26C6DA),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 10),

            // 📋 TASK LIST
            Expanded(
              child: filteredTasks.isEmpty
                  ? const Center(child: Text("No tasks"))
                  : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];

                  return Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius:
                      BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withOpacity(0.05),
                          blurRadius: 6,
                        )
                      ],
                    ),
                    child: Row(
                      children: [
                        Checkbox(
                          value: task["done"],
                          onChanged: (_) =>
                              toggleTask(index),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              Text(task["title"],
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.bold,
                                      color: textColor)),
                              Text(task["priority"],
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey)),
                            ],
                          ),
                        ),
                        Icon(Icons.circle,
                            color: getPriorityColor(
                                task["priority"]),
                            size: 12),
                        IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () =>
                                editTask(index)),
                        IconButton(
                            icon: const Icon(Icons.delete,
                                color: Colors.red),
                            onPressed: () =>
                                deleteTask(index)),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}