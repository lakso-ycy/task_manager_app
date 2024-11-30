// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/dashboard_screen.dart';  // Halaman Dashboard
import 'package:task_manager_app/screens/statistics_screen.dart';  // Halaman Statistik

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0; // Index halaman yang aktif

  // Daftar halaman yang ditampilkan sesuai tab
  final List<Widget> _screens = [
    const DashboardScreen(),
    const StatisticsScreen(),
  ];

  bool _isHoveredDashboard = false;  // Untuk mendeteksi hover pada Dashboard
  bool _isHoveredStatistics = false; // Untuk mendeteksi hover pada Statistics

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Ubah halaman berdasarkan tab yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex], // Tampilkan halaman sesuai tab yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Tab yang sedang aktif
        onTap: _onTabTapped, // Fungsi untuk menangani perubahan tab
        items: [
          BottomNavigationBarItem(
            icon: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHoveredDashboard = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHoveredDashboard = false;
                });
              },
              child: Icon(
                Icons.dashboard,
                color: _isHoveredDashboard ? Colors.white : Colors.teal,
              ),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHoveredStatistics = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHoveredStatistics = false;
                });
              },
              child: Icon(
                Icons.bar_chart,
                color: _isHoveredStatistics ? Colors.white : Colors.teal,
              ),
            ),
            label: 'Statistics',
          ),
        ],
      ),
    );
  }
}
