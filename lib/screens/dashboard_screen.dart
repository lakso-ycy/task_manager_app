import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/models/task.dart';
import 'add_edit_task_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  DateTime _selectedDate = DateTime.now();
  bool _showAllTasks = true;
  String _selectedCategory = 'Study'; // Default category to 'Study'

  // Function to filter tasks by category and date
  List<Task> getFilteredTasks(List<Task> tasks) {
    if (_showAllTasks) {
      return tasks; // Show all tasks if "Show All" is selected
    }

    // Filter tasks by category if a specific category is selected
    if (_selectedCategory.isNotEmpty) {
      return tasks.where((task) => task.category == _selectedCategory).toList();
    }

    // If filtering by date (and not category)
    return tasks.where((task) {
      return task.date.year == _selectedDate.year &&
          task.date.month == _selectedDate.month &&
          task.date.day == _selectedDate.day;
    }).toList();
  }

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
        _selectedCategory = ''; // Reset category when filtering by date
      });
    }
  }

  void _showAll() {
    setState(() {
      _showAllTasks = true;
      _selectedCategory = ''; // Reset category when showing all tasks
    });
  }

  void _sortByDeadline() {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);
    taskProvider.sortTasksByDeadline();
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.redAccent;
      case 'Medium':
        return Colors.orangeAccent;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final tasks = getFilteredTasks(taskProvider.tasks);

    return Scaffold(
appBar: AppBar(
  automaticallyImplyLeading: false, // Hilangkan ruang untuk leading
  title: const Text(
    'Task Manager',
    style: TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Poppins',
    ),
  ),
  centerTitle: false, // Pastikan judul ada di kiri
  backgroundColor: Colors.transparent,
  flexibleSpace: Container(
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0x99F3C4FB), Color(0x99F3C4FB)], // Warna dengan opacity 60%
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  ),
  actions: [
    IconButton(
      icon: const Icon(Icons.sort, color: Colors.black),
      onPressed: _sortByDeadline,
    ),
  ],
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
                    backgroundColor: const Color(0x99F3C4FB),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Show All',
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Color(0x99F3C4FB)),
                  onPressed: () => _selectDate(context),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedCategory.isNotEmpty ? _selectedCategory : 'Study',
                  focusColor: Colors.transparent,
                  onChanged: (String? newCategory) {
                    setState(() {
                      _selectedCategory = newCategory ?? 'Study';
                      _showAllTasks = false; // Ensure it filters by category
                      _selectedDate = DateTime.now(); // Reset date filtering
                    });
                  },
                  items: <String>['Study', 'Personal', 'Work']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontFamily: 'Poppins', color: Colors.black)),
                    );
                  }).toList(),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                  underline: Container(),
                  iconEnabledColor: const Color(0x99F3C4FB),
                ),
              ],
            ),
          ),
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks available!',
                      style: TextStyle(fontSize: 18, color: Colors.black, fontFamily: 'Poppins'),
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
                              fontFamily: 'Poppins',
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Due: ${DateFormat('dd MMM yyyy').format(task.date)}',
                                style: const TextStyle(fontFamily: 'Poppins', color: Colors.black),
                              ),
                              Row(
                                children: [
                                  const Text(
                                    'Priority: ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  Text(
                                    task.priority,
                                    style: TextStyle(
                                      color: _getPriorityColor(task.priority),
                                      fontWeight: FontWeight.w500,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ],
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
                                    task.isCompleted = !task.isCompleted;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Task "${task.title}" marked as ${task.isCompleted ? 'completed' : 'in progress'}!'),
                                    ),
                                  );

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
        backgroundColor: const Color(0x99F3C4FB),
        child: const Icon(Icons.add),
      ),
    );
  }
}
