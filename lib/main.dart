import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Provider untuk state management
import 'package:task_manager_app/screens/login.dart';
import 'package:task_manager_app/screens/register.dart';
import 'package:task_manager_app/screens/welcome_page.dart';
import 'package:task_manager_app/screens/landing_page.dart';
import 'package:task_manager_app/screens/profile_screen.dart'; // Import ProfileScreen
import 'package:task_manager_app/screens/navbar.dart';
import 'package:task_manager_app/screens/dashboard_screen.dart';
import 'package:task_manager_app/screens/forgot_password.dart';
import 'package:task_manager_app/providers/task_provider.dart';
import 'package:task_manager_app/providers/auth_provider.dart';

void main() {
  runApp(const TaskManagerApp());
}

class TaskManagerApp extends StatelessWidget {
  const TaskManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
            create: (_) => TaskProvider()), // Tambahkan provider untuk tugas
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.teal,
          scaffoldBackgroundColor: const Color(0xFFF5F7FB),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const WelcomePage(),
          '/login': (context) => const LoginPage(),
          '/register': (context) => const RegisterPage(),
          '/landing': (context) => const HomeScreen(),
          '/home': (context) => const Navbar(),
          '/dashboard': (context) =>
              const DashboardScreen(), // Tambahkan rute untuk DashboardScreen
          '/forgot_password': (context) => const ForgotPasswordPage(), // Halaman lupa kata sandi
          '/profile': (context) => const ProfileScreen(), // Rute untuk ProfileScreen
        },
      ),
    );
  }
}
