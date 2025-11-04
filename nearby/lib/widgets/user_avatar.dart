import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final String name;
  final double size;
  final bool showOnlineStatus;
  final bool isOnline;

  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl = '',
    this.size = 48.0,
    this.showOnlineStatus = false,
    this.isOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          CircleAvatar(
            radius: size / 2,
            backgroundColor: AppTheme.surfaceColor,
            backgroundImage: imageUrl.isNotEmpty ? NetworkImage(imageUrl) : null,
            child: imageUrl.isEmpty
                ? Text(
                    _getInitials(name),
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: size * 0.4,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
          if (showOnlineStatus)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                  color: isOnline ? AppTheme.successColor : AppTheme.textTertiary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppTheme.surfaceColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }
}