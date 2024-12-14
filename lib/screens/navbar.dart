import 'package:flutter/material.dart';
import 'package:task_manager_app/screens/dashboard_screen.dart'; // Halaman Dashboard
import 'package:task_manager_app/screens/statistics_screen.dart'; // Halaman Statistik
import 'package:task_manager_app/screens/catatan.dart'; // Halaman Catatan
import 'package:task_manager_app/screens/profile_screen.dart'; // Halaman Profil

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0; // Index halaman yang aktif

  // Daftar halaman yang ditampilkan sesuai tab
  final List<Widget> _screens = [
    const DashboardScreen(),
    const NotesPage(), // Halaman Catatan
    const StatisticsScreen(),
    const ProfileScreen(), // Halaman Profil
  ];

  // Hover states untuk navigasi
  bool _isHoveredDashboard = false;
  bool _isHoveredNotes = false;
  bool _isHoveredStatistics = false;
  bool _isHoveredProfile = false;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index; // Ubah halaman berdasarkan tab yang dipilih
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _screens[_currentIndex], // Tampilkan halaman sesuai tab yang dipilih
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // Tab yang sedang aktif
        onTap: _onTabTapped, // Fungsi untuk menangani perubahan tab
        selectedItemColor: Colors.black, // Warna untuk item yang dipilih (black)
        unselectedItemColor: Colors.black, // Warna untuk item yang tidak dipilih (black)
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
                color: _isHoveredDashboard ? Colors.black : Colors.black, // Change color to black
              ),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHoveredNotes = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHoveredNotes = false;
                });
              },
              child: Icon(
                Icons.note,
                color: _isHoveredNotes ? Colors.black : Colors.black, // Change color to black
              ),
            ),
            label: 'Notes',
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
                color: _isHoveredStatistics ? Colors.black : Colors.black, // Change color to black
              ),
            ),
            label: 'Statistics',
          ),
          BottomNavigationBarItem(
            icon: MouseRegion(
              onEnter: (_) {
                setState(() {
                  _isHoveredProfile = true;
                });
              },
              onExit: (_) {
                setState(() {
                  _isHoveredProfile = false;
                });
              },
              child: Icon(
                Icons.person,
                color: _isHoveredProfile ? Colors.black : Colors.black, // Change color to black
              ),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
