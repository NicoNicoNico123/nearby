import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/loading_states.dart';

class MessagingScreen extends StatelessWidget {
  const MessagingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        title: const Text(
          'Chat',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
      ),
      body: const EmptyState(
        icon: Icons.chat_outlined,
        title: 'No conversations yet',
        subtitle: 'Start chatting with people you connect with',
      ),
    );
  }
}