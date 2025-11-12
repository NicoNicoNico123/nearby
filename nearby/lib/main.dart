import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'main_navigation.dart';
import 'screens/messaging/chat_screen.dart';
import 'screens/group_info_view/group_info_screen.dart';
import 'screens/create_group/create_group_screen.dart';
import 'screens/feed/filter_screen.dart';
import 'screens/feed/interest_search_screen.dart';
import 'screens/feed/language_search_screen.dart';
import 'models/group_model.dart';
import 'services/mock/mock_data_service.dart';
import 'utils/navigation_service.dart';
import 'utils/logger.dart';
// Uncomment for development validation
// import 'services/test/mock_data_validation.dart';

// Global instance for easy access
final mockDataService = MockDataService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.info('Starting Nearby app');

  // Initialize the modular mock data service first
  try {
    await mockDataService.initialize();
    Logger.info('MockDataService initialized successfully');

    // Verify data was loaded
    final groups = mockDataService.getGroups();
    final users = mockDataService.getUsers();
    Logger.info('Loaded ${groups.length} groups and ${users.length} users');
  } catch (e) {
    Logger.error('Failed to initialize MockDataService', error: e);
    // Continue with fallback data
  }

  // Set up preview mode (comment this out for production)
  // 4 Distinct Scenarios - Uncomment any of these lines to test different user types:

  // Scenario 1: Normal User (created 1 group)
  // mockDataService.setPreviewNormalUserWithGroup();

  // Scenario 2: Premium User (created 2 groups)
  mockDataService.setPreviewPremiumUserWithGroups();

  // Scenario 3: Guest User (no groups, 0 points)
  // mockDataService.setPreviewGuestUser();

  // Scenario 4: Godmode User (unlimited everything)
  // mockDataService.setPreviewGodmodeUser();

  runApp(const NearbyApp());
}

class NearbyApp extends StatelessWidget {
  const NearbyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby - Social Dining',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const MainNavigation(),
      navigatorKey: NavigationService.navigatorKey,
      onGenerateRoute: _generateRoute,
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings settings) {
    Logger.info('Navigating to route: ${settings.name}');

    switch (settings.name) {
      case '/chat':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          return MaterialPageRoute(
            builder: (context) => ChatScreen(
              conversationId: args['conversationId']?.toString() ?? '',
              conversationName: args['conversationName']?.toString() ?? 'Chat',
              isGroup: args['isGroup'] ?? false,
            ),
          );
        }
        return null;

      case '/group_info':
        final args = settings.arguments as Map<String, dynamic>?;
        Group? group;

        if (args != null) {
          // First try to get the group object directly (new approach)
          group = args['group'] as Group?;

          // Fallback to old approach with groupId
          if (group == null) {
            final groupId = args['groupId'] as String?;
            if (groupId != null) {
              group = mockDataService.getGroupById(groupId);
            }
          }
        }

        return MaterialPageRoute(
          builder: (context) => GroupInfoScreen(group: group),
        );

      case '/filter':
        return MaterialPageRoute(builder: (context) => const FilterScreen());

      case '/interest_search':
        final args = settings.arguments as Map<String, dynamic>?;
        final initiallySelected =
            args?['selectedInterests'] as Set<String>? ?? <String>{};
        return MaterialPageRoute(
          builder: (context) => InterestSearchScreen(
            initiallySelectedInterests: initiallySelected,
          ),
        );

      case '/language_search':
        final args = settings.arguments as Map<String, dynamic>?;
        final initiallySelected =
            args?['selectedLanguages'] as Set<String>? ?? <String>{};
        return MaterialPageRoute(
          builder: (context) => LanguageSearchScreen(
            initiallySelectedLanguages: initiallySelected,
          ),
        );

      case '/create_group':
        return MaterialPageRoute(
          builder: (context) => const CreateGroupScreen(),
        );

      default:
        return null;
    }
  }
}
