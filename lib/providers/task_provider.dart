import 'package:flutter/material.dart';
import 'package:task_manager_app/models/task.dart';

class TaskProvider extends ChangeNotifier {
  final List<Task> _tasks = []; // Daftar tugas

  List<Task> get tasks => List.unmodifiable(_tasks); // Mengembalikan salinan daftar tugas

  void addTask(Task task) {
    _tasks.add(task);
    notifyListeners(); // Beritahu widget terkait bahwa data telah berubah
  }

  void updateTask(int index, Task task) {
    _tasks[index] = task;
    notifyListeners();
  }

  void deleteTask(int index) {
    _tasks.removeAt(index);
    notifyListeners();
  }
}