import 'package:flutter/material.dart';
import '../services/appwrite_data_service.dart';
import 'package:appwrite/models.dart' as models;

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
      final docs = await _dataService.getTasks();
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

  // ➕ Add Task
  Future<void> addTask() async {
    if (controller.text.isEmpty) return;

    final newTaskData = {
      "title": controller.text,
      "IsComplited": false, // Exact match to your Console: "IsComplited"
    };

    final doc = await _dataService.addTask(newTaskData);
    if (doc != null) {
      controller.clear();
      _loadTasks();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error: Check Permissions & ensure 'userId' is Indexed in Console"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void filterTasks() {
    setState(() {
      filteredTasks = tasks; 
    });
  }

  void searchTasks(String query) {
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

  void editTask(Map<String, dynamic> task) {
    controller.text = task["title"] ?? "";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit Task"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await _dataService.updateTask(task["id"], {"title": controller.text});
                controller.clear();
                if (mounted) Navigator.pop(context);
                _loadTasks();
              }
            },
            child: const Text("Save"),
          )
        ],
      ),
    );
  }

  double getProgress() {
    if (filteredTasks.isEmpty) return 0;
    int done = filteredTasks.where((t) => t["IsComplited"] == true).length;
    return done / filteredTasks.length;
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
          gradient: isDark ? null : const LinearGradient(
            colors: [Color(0xFFE0F7FA), Color(0xFFB2EBF2), Color(0xFF80DEEA)],
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
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
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
            // Progress
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Color(0xFF26C6DA)),
                      const SizedBox(width: 10),
                      Text(selectedDate.toString().split(' ')[0], style: TextStyle(color: textColor)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: getProgress(), minHeight: 8, color: const Color(0xFF26C6DA)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Add Task
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 15),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller,
                      decoration: const InputDecoration(hintText: "Enter task...", border: InputBorder.none),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: addTask,
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF26C6DA)),
                    child: const Icon(Icons.add, color: Colors.white),
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
                  ? const Center(child: Text("No tasks found"))
                  : ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: cardColor, borderRadius: BorderRadius.circular(15)),
                    child: ListTile(
                      leading: Checkbox(
                        value: task["IsComplited"] ?? false,
                        onChanged: (_) => toggleTask(task),
                      ),
                      title: Text(task["title"] ?? "Untitled", style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit, size: 20), onPressed: () => editTask(task)),
                          IconButton(icon: const Icon(Icons.delete, color: Colors.red, size: 20), onPressed: () => deleteTask(task["id"])),
                        ],
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
