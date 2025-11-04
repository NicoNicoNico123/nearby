import 'package:flutter/material.dart';
import '../screens/discover_page/discover_screen.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/user_profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/welcome/welcome_screen.dart';
import '../utils/logger.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  bool _showWelcomeScreen = true;

  final List<Widget> _screens = [
    const DiscoverScreen(),
    const FeedScreen(),
    const ProfileScreen(),
    const SettingsScreen(),
  ];

  final List<BottomNavigationBarItem> _bottomNavItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.explore),
      label: 'Discover',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Feed',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Logger.info('Navigated to ${_bottomNavItems[index].label}');
  }

  void _completeOnboarding() {
    setState(() {
      _showWelcomeScreen = false;
    });
    Logger.info('Completed onboarding');
  }

  @override
  Widget build(BuildContext context) {
    if (_showWelcomeScreen) {
      return WelcomeScreen(
        onGetStarted: _completeOnboarding,
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        items: _bottomNavItems,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}