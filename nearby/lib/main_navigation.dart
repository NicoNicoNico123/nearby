import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../screens/feed/feed_screen.dart';
import '../screens/discover_page/discover_screen.dart';
import '../screens/messaging/chat_room_list_screen.dart';
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
    const ChatRoomListScreen(),
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

  void _navigateToCreateGroup() {
    // Navigate to create group screen
    Navigator.pushNamed(
      context,
      '/create_group',
    );
    Logger.info('Navigated to create group screen');
  }

  Widget _buildCreateGroupFAB() {
    return Container(
      height: 65,
      width: 65,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _navigateToCreateGroup,
          borderRadius: BorderRadius.circular(32.5),
          splashColor: Colors.white.withValues(alpha: 0.3),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 28,
          ),
        ),
      ),
    );
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
      floatingActionButton: _currentIndex != 1 ? _buildCreateGroupFAB() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}