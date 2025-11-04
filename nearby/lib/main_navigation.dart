import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/discover_page/discover_screen.dart';
import '../screens/messaging/messaging_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/welcome/welcome_screen.dart';
import '../widgets/custom_bottom_nav.dart';
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
    const FeedScreen(),
    const DiscoverScreen(),
    const MessagingScreen(),
    const SettingsScreen(),
  ];

  final List<String> _navLabels = ['Feed', 'Discover', 'Chat', 'Settings'];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Logger.info('Navigated to ${_navLabels[index]}');
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
      backgroundColor: AppTheme.backgroundColor, // Dark background
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}