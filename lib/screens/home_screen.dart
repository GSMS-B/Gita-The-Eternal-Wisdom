import 'package:flutter/material.dart';
import '../widgets/bottom_nav_bar.dart';
import 'chapters_screen.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';
import 'dashboard_view.dart'; // The actual home content
import 'meditation_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardView(),
    const ChaptersScreen(),
    const BookmarksScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const MeditationScreen()),
          );
        },
        backgroundColor: const Color(0xFFF9F5EE), // ivory background for FAB
        elevation: 4,
        shape: const CircleBorder(
          side: BorderSide(color: Color(0xFFCD9A5B), width: 1.5),
        ),
        child: Image.asset(
          'assets/icons/ic_lotus.png',
          color: const Color(0xFFCD9A5B),
          width: 32,
          height: 32,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
