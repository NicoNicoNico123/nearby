import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import 'user_avatar.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onSuperlike;
  final bool showDistance;
  final bool showAvailability;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onSuperlike,
    this.showDistance = true,
    this.showAvailability = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingMD,
        vertical: AppTheme.spacingSM,
      ),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  UserAvatar(
                    name: user.name,
                    imageUrl: user.imageUrl,
                    size: 56,
                    showOnlineStatus: showAvailability,
                    isOnline: user.isAvailable,
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                user.name,
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            if (user.age != null)
                              Text(
                                '${user.age}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                          ],
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        if (user.bio.isNotEmpty)
                          Text(
                            user.bio,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        const SizedBox(height: AppTheme.spacingSM),
                        _buildInterests(context),
                      ],
                    ),
                  ),
                ],
              ),
              if (showDistance && user.distance != null) ...[
                const SizedBox(height: AppTheme.spacingSM),
                _buildMetadata(context),
              ],
              if (onSuperlike != null) ...[
                const SizedBox(height: AppTheme.spacingSM),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onSuperlike,
                    icon: const Icon(Icons.star),
                    label: const Text('Superlike'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.warningColor,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInterests(BuildContext context) {
    if (user.interests.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppTheme.spacingXS,
      runSpacing: AppTheme.spacingXS,
      children: user.interests.take(5).map((interest) {
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingSM,
            vertical: AppTheme.spacingXS,
          ),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            interest,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildMetadata(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.location_on,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: AppTheme.spacingXS),
        Text(
          '${user.distance} miles away',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
        const Spacer(),
        if (user.lastSeen != null)
          Text(
            'Active ${_formatLastSeen(user.lastSeen!)}',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  String _formatLastSeen(DateTime lastSeen) {
    final now = DateTime.now();
    final difference = now.difference(lastSeen);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}