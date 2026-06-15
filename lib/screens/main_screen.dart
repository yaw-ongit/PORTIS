import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'notification_screen.dart';
import 'activity_screen.dart';
import 'chat_screen.dart';
import 'profile_screen.dart';

// Screen utama
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // State: index halaman aktif
  int _currentIndex = 0;

  // Daftar 5 halaman
  final List<Widget> _pages = const [
    HomeScreen(), // Halaman 1: Home
    NotificationScreen(), // Halaman 2: Notifikasi
    ActivityScreen(), // Halaman 3: Aktivitas
    ChatScreen(), // Halaman 4: Chat
    ProfileScreen(), // Halaman 5: Profil
  ];

  void _onNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home),
              _buildNavItem(
                  1, Icons.notifications_outlined, Icons.notifications),
              _buildNavItem(
                  2, Icons.calendar_today_outlined, Icons.calendar_today),
              _buildNavItem(3, Icons.chat_bubble_outline, Icons.chat_bubble),
              _buildNavItem(4, Icons.person_outline, Icons.person),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon) {
    final bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => _onNavTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isActive
              ? const Color(0xFF6CC2E8).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isActive ? activeIcon : icon,
          color: isActive ? const Color(0xFF6CC2E8) : Colors.grey[400],
          size: 26,
        ),
      ),
    );
  }
}
