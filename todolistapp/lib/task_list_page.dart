import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:intl/intl.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  List<Map<String, dynamic>> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
  }

  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    final data = await _dbHelper.queryAllTasks();
    setState(() {
      _tasks = data;
      _isLoading = false;
    });
  }

  void _toggleTaskStatus(Map<String, dynamic> task) async {
    int newStatus = task['is_completed'] == 1 ? 0 : 1;
    await _dbHelper.updateTask({
      'id': task['id'],
      'is_completed': newStatus,
    });
    _fetchTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text(
          'Daftar Tugas',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(child: Text('Belum ada tugas.'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    bool isCompleted = task['is_completed'] == 1;
                    bool isImportant = task['category'] == 'Penting';
                    
                    // Format date for display
                    String formattedDate = '';
                    if (task['due_date'] != null) {
                      DateTime dt = DateTime.parse(task['due_date']);
                      formattedDate = DateFormat('dd MMM yyyy', 'id_ID').format(dt);
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Transform.scale(
                          scale: 1.2,
                          child: Checkbox(
                            value: isCompleted,
                            activeColor: const Color(0xFF4A8B7A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            onChanged: (_) => _toggleTaskStatus(task),
                          ),
                        ),
                        title: Text(
                          task['title'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isCompleted ? Colors.grey : Colors.black87,
                            decoration: isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                        subtitle: Text(
                          '$formattedDate · ${task['category']}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        trailing: Icon(
                          Icons.play_arrow_rounded,
                          color: isImportant ? Colors.red : Colors.green,
                          size: 24,
                        ),
                        onTap: () => _toggleTaskStatus(task),
                      ),
                    );
                  },
                ),
    );
  }
}
