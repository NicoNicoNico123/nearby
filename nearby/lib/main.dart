import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'main_navigation.dart';
import 'utils/navigation_service.dart';
import 'utils/logger.dart';

void main() {
  Logger.info('Starting Nearby app');
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
      onGenerateRoute: (settings) {
        Logger.info('Navigating to route: ${settings.name}');
        return null; // Use default navigation
      },
    );
  }
}
