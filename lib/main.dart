import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Tambahkan provider untuk state management
import 'package:task_manager_app/screens/login.dart';
import 'package:task_manager_app/screens/home_screen.dart';
import 'package:task_manager_app/screens/forgot_password.dart';
import 'package:task_manager_app/providers/task_provider.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(), // Inisialisasi TaskProvider
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => const LoginPage(),
          '/forgot-password': (context) => const ForgotPasswordPage(),
          '/home': (context) => const HomeScreen(),
        },
      ),
    );
  }
}
