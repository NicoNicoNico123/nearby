import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'main_navigation.dart';
import 'screens/messaging/chat_screen.dart';
import 'screens/group_info_view/group_info_screen.dart';
import 'services/mock_data_service.dart';
import 'utils/navigation_service.dart';
import 'utils/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Logger.info('Starting Nearby app');

  // Initialize mock data service and simulate user activity
  await MockDataService().simulateUserActivity();

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
              conversationId: args['conversationId'],
              conversationName: args['conversationName'],
              isGroup: args['isGroup'] ?? false,
            ),
          );
        }
        return null;

      case '/group_info':
        final args = settings.arguments as Map<String, dynamic>?;
        if (args != null) {
          final groupId = args['groupId'] as String?;
          if (groupId != null) {
            final group = MockDataService().getGroupById(groupId);
            return MaterialPageRoute(
              builder: (context) => GroupInfoScreen(group: group),
            );
          }
        }
        return null;

      default:
        return null;
    }
  }
}
