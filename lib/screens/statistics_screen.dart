import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/task_provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);

    // Menentukan waktu sekarang untuk mengecek overdue
    final now = DateTime.now();

    // Menghitung task berdasarkan kategori
    final completedTasks = taskProvider.tasks.where((task) => task.isCompleted).toList();
    final inProgressTasks = taskProvider.tasks.where((task) => !task.isCompleted && task.date.isAfter(now)).toList();
    final overdueTasks = taskProvider.tasks.where((task) => !task.isCompleted && task.date.isBefore(now)).toList();

    // Menghitung total task
    final totalTasks = taskProvider.tasks.length;

    // Menghitung persentase
    final completedPercentage = totalTasks > 0 ? (completedTasks.length / totalTasks) * 100 : 0.0;
    final inProgressPercentage = totalTasks > 0 ? (inProgressTasks.length / totalTasks) * 100 : 0.0;
    final overduePercentage = totalTasks > 0 ? (overdueTasks.length / totalTasks) * 100 : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Color(0xFF00C4B4), // Warna teal modern
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Card untuk Completed Tasks
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: const Text('Completed Tasks'),
                subtitle: Text(
                    '${completedTasks.length} tasks completed (${completedPercentage.toStringAsFixed(2)}%)'),
                tileColor: Colors.greenAccent.withOpacity(0.2),
                trailing: Icon(Icons.check_circle, color: Colors.green),
              ),
            ),
            // Card untuk In Progress Tasks
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: const Text('In Progress Tasks'),
                subtitle: Text(
                    '${inProgressTasks.length} tasks in progress (${inProgressPercentage.toStringAsFixed(2)}%)'),
                tileColor: Colors.orangeAccent.withOpacity(0.2),
                trailing: Icon(Icons.timelapse, color: Colors.orange),
              ),
            ),
            // Card untuk Overdue Tasks
            Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: const Text('Overdue Tasks'),
                subtitle: Text(
                    '${overdueTasks.length} tasks overdue (${overduePercentage.toStringAsFixed(2)}%)'),
                tileColor: Colors.redAccent.withOpacity(0.2),
                trailing: Icon(Icons.warning, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            // Pie chart for task distribution (Completed, In Progress, Overdue)
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildPieChartSection('Completed', completedPercentage, Colors.green),
                  _buildPieChartSection('In Progress', inProgressPercentage, Colors.orange),
                  _buildPieChartSection('Overdue', overduePercentage, Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Membuat section pie chart
  Widget _buildPieChartSection(String label, double percentage, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircleAvatar(
          backgroundColor: color.withOpacity(0.4),
          radius: 40,
          child: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
