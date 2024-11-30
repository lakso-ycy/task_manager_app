import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'add_edit_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _showAllTasks = true;

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _showAllTasks = false;
      });
    }
  }

  void _showAll() {
    setState(() {
      _showAllTasks = true;
    });
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      case 'Low':
        return Colors.greenAccent;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = _showAllTasks
        ? taskProvider.tasks
        : taskProvider.tasks.where((task) {
            return task.date.year == _selectedDate.year &&
                task.date.month == _selectedDate.month &&
                task.date.day == _selectedDate.day;
          }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
        backgroundColor: Color(0xFF00C4B4), // Warna teal modern
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _showAll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00C4B4), // Warna teal modern
                  ),
                  child: const Text(
                    'Show All',
                    style: TextStyle(color: Colors.white), // Teks putih
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Color(0xFF00C4B4)), // Warna teal modern
                  onPressed: () => _selectDate(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks available!',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: ListTile(
                          leading: Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: _getPriorityColor(task.priority),
                              shape: BoxShape.circle,
                            ),
                          ),
                          title: Text(
                            task.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due: ${DateFormat('dd MMM yyyy').format(task.date)}',
                              ),
                              Text(
                                'Priority: ${task.priority}',
                                style: TextStyle(
                                  color: _getPriorityColor(task.priority),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  task.isCompleted
                                      ? Icons.check_circle
                                      : Icons.check_circle_outline,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  setState(() {
                                    task.isCompleted = !task.isCompleted; // Toggle completion
                                  });

                                  // Menampilkan SnackBar setelah tugas selesai
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Task "${task.title}" marked as ${task.isCompleted ? 'completed' : 'in progress'}!'),
                                    ),
                                  );

                                  // Update task status di TaskProvider
                                  taskProvider.updateTask(index, task);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => taskProvider.deleteTask(index),
                              ),
                            ],
                          ),
                          onTap: () async {
                            final updatedTask = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    AddEditTaskScreen(task: task),
                              ),
                            );
                            if (updatedTask != null) {
                              taskProvider.updateTask(index, updatedTask);
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditTaskScreen()),
          );
          if (newTask != null) {
            taskProvider.addTask(newTask);
          }
        },
        backgroundColor: Color(0xFF00C4B4), // Warna teal modern
        child: const Icon(Icons.add),
      ),
    );
  }
}