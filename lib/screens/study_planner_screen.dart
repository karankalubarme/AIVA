import 'package:flutter/material.dart';
import '../services/appwrite_data_service.dart';
import 'package:intl/intl.dart';

class StudyPlannerScreen extends StatefulWidget {
  const StudyPlannerScreen({super.key});

  @override
  State<StudyPlannerScreen> createState() => _StudyPlannerScreenState();
}

class _StudyPlannerScreenState extends State<StudyPlannerScreen> {
  final AppwriteDataService _dataService = AppwriteDataService();
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> filteredTasks = [];
  bool isLoading = false;

  final TextEditingController controller = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    if (!mounted) return;
    setState(() => isLoading = true);
    try {
      // Fetch tasks for the selected date
      final docs = await _dataService.getTasks(date: selectedDate);
      if (mounted) {
        setState(() {
          tasks = docs.map((doc) {
            final data = Map<String, dynamic>.from(doc.data);
            data['id'] = doc.$id;
            return data;
          }).toList();
          isLoading = false;
          filterTasks();
        });
      }
    } catch (e) {
      print("Error loading tasks: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> addTask() async {
    if (controller.text.isEmpty) return;

    final newTaskData = {
      "title": controller.text,
      "IsComplited": false,
      "date": selectedDate.toString().split(' ')[0], // yyyy-MM-dd
    };

    final doc = await _dataService.addTask(newTaskData);
    if (doc != null) {
      controller.clear();
      _loadTasks();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: Ensure 'date' attribute exists & 'userId' is Indexed in Appwrite Console"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void filterTasks() {
    setState(() {
      // Sort tasks: Incomplete first, then by title
      filteredTasks = List.from(tasks);
      filteredTasks.sort((a, b) {
        bool aDone = a["IsComplited"] ?? false;
        bool bDone = b["IsComplited"] ?? false;
        if (aDone && !bDone) return 1;
        if (!aDone && bDone) return -1;
        return (a["title"] ?? "").toString().compareTo((b["title"] ?? "").toString());
      });
    });
  }

  void searchTasks(String query) {
    if (query.isEmpty) {
      filterTasks();
      return;
    }
    setState(() {
      filteredTasks = tasks.where((task) {
        return (task["title"] ?? "")
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      }).toList();
    });
  }

  Future<void> deleteTask(String id) async {
    await _dataService.deleteTask(id);
    _loadTasks();
  }

  Future<void> toggleTask(Map<String, dynamic> task) async {
    final bool currentStatus = task["IsComplited"] ?? false;
    await _dataService.updateTask(task["id"], {"IsComplited": !currentStatus});
    _loadTasks();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      _loadTasks();
    }
  }

  double getProgress() {
    if (tasks.isEmpty) return 0;
    int done = tasks.where((t) => t["IsComplited"] == true).length;
    return done / tasks.length;
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
        backgroundColor: const Color(0xFF00ACC1),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF121212) : Colors.white,
          gradient: isDark ? null : const LinearGradient(
            colors: [Color(0xFFE0F7FA), Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Search
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: TextField(
                controller: searchController,
                onChanged: searchTasks,
                decoration: const InputDecoration(
                  hintText: "Search task...",
                  prefixIcon: Icon(Icons.search, color: Color(0xFF00ACC1)),
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Date Picker & Progress
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, color: Color(0xFF00ACC1)),
                            const SizedBox(width: 10),
                            Text(
                              DateFormat('EEEE, dd MMM').format(selectedDate),
                              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: getProgress(),
                        minHeight: 8,
                        color: const Color(0xFF00ACC1),
                        backgroundColor: Colors.grey[200],
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "${(getProgress() * 100).toInt()}% Completed",
                          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Add Task
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: "What's on your mind?", border: InputBorder.none),
                    ),
                  ),
                  IconButton(
                    onPressed: addTask,
                    icon: const Icon(Icons.add_circle, color: Color(0xFF00ACC1), size: 30),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            // List
            Expanded(
              child: isLoading 
                ? const Center(child: CircularProgressIndicator())
                : filteredTasks.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.assignment_turned_in_outlined, size: 60, color: Colors.grey[300]),
                          const SizedBox(height: 10),
                          Text("No tasks for this day", style: TextStyle(color: Colors.grey[500])),
                        ],
                      ),
                    )
                  : ListView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  final bool isDone = task["IsComplited"] ?? false;
                  return Dismissible(
                    key: Key(task["id"]),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      color: Colors.red,
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => deleteTask(task["id"]),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 5)],
                      ),
                      child: ListTile(
                        leading: Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: isDone,
                            activeColor: const Color(0xFF00ACC1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (_) => toggleTask(task),
                          ),
                        ),
                        title: Text(
                          task["title"] ?? "Untitled",
                          style: TextStyle(
                            color: isDone ? Colors.grey : textColor,
                            fontWeight: FontWeight.bold,
                            decoration: isDone ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        trailing: Icon(Icons.more_vert, color: Colors.grey[400]),
                      ),
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
