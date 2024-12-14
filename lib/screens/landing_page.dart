import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager_app/providers/auth_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showAnimation = false;

  @override
  void initState() {
    super.initState();
    // Memulai animasi setelah beberapa saat
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _showAnimation = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animasi gambar kalender
            AnimatedOpacity(
              opacity: _showAnimation ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              child: Image.asset(
                'assets/calendar.png', // Pastikan gambar di folder assets
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 20),
            // Animasi teks selamat datang
            AnimatedOpacity(
              opacity: _showAnimation ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              child: Text(
                "Selamat datang, ${authProvider.currentUsername ?? 'User'}!",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Tombol Next untuk navigasi
            AnimatedOpacity(
              opacity: _showAnimation ? 1.0 : 0.0,
              duration: const Duration(seconds: 2),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                  ),
                ),
                child: const Text("Next"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
