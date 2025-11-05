import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/group_model.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onSuperlike;
  final bool isHorizontal;

  const GroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.onLike,
    this.onSuperlike,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontal) {
      return _buildHorizontalCard(context);
    } else {
      return _buildVerticalCard(context);
    }
  }

  Widget _buildHorizontalCard(BuildContext context) {
    return Container(
      width: 288,
      height: 530, // Explicit height to match container
      margin: const EdgeInsets.only(right: AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 0),
          ),
        ],
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Prevent overflow
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with overlay tags
            Container(
              width: double.infinity,
              height: 280, // Further reduced to fix overflow
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                color: AppTheme.surfaceColor,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Stack(
                  children: [
                    // Image with error handling
                    Image.network(
                      group.imageUrl,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppTheme.surfaceColor,
                          child: const Icon(
                            Icons.group,
                            size: 64,
                            color: AppTheme.textTertiary,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          height: double.infinity,
                          color: AppTheme.surfaceColor,
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                                  : null,
                              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                            ),
                          ),
                        );
                      },
                    ),
                    // Overlay tags
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingSM),
                        child: Wrap(
                          spacing: AppTheme.spacingXS,
                          runSpacing: AppTheme.spacingXS,
                          children: group.interests.take(2).map((interest) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingSM,
                                vertical: AppTheme.spacingXS,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                interest,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingSM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    group.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    group.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  // Pot and cost info
                  Container(
                    padding: const EdgeInsets.all(AppTheme.spacingXS),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.monetization_on,
                              size: 14,
                              color: AppTheme.primaryColor,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${group.groupPot} pts',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              size: 14,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${group.joinCost} pts',
                              style: const TextStyle(
                                color: Colors.orange,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  // Location info
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        group.venue,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  // Event time and availability info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _formatEventTime(group.mealTime),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: group.availableSpots > 0
                            ? Colors.green.withValues(alpha: 0.2)
                            : Colors.red.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${group.availableSpots} left',
                          style: TextStyle(
                            color: group.availableSpots > 0
                              ? Colors.green
                              : Colors.red,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onLike,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
                            foregroundColor: AppTheme.primaryColor,
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: const Icon(Icons.favorite, size: 20),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSM),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onSuperlike,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4AC7F0).withValues(alpha: 0.2),
                            foregroundColor: const Color(0xFF4AC7F0),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                          child: const Icon(Icons.star, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalCard(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image section
        Container(
          width: double.infinity,
          height: 164, // Adjusted for grid layout
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppTheme.surfaceColor,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              group.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: AppTheme.surfaceColor,
                  child: const Icon(
                    Icons.group,
                    size: 40,
                    color: AppTheme.textTertiary,
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                        : null,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Text content
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                group.subtitle,
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Format event date and time
  String _formatEventTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final eventDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    final difference = eventDate.difference(today);

    if (difference.inDays == 0) {
      // Today - show time
      return 'Today ${_formatTime(dateTime)}';
    } else if (difference.inDays == 1) {
      // Tomorrow
      return 'Tomorrow ${_formatTime(dateTime)}';
    } else if (difference.inDays > 1 && difference.inDays <= 7) {
      // This week
      return '${_getWeekday(dateTime.weekday)} ${_formatTime(dateTime)}';
    } else {
      // Future date
      return '${_formatDate(dateTime)} ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;

    if (hour == 0) {
      return '12:${minute.toString().padLeft(2, '0')} AM';
    } else if (hour < 12) {
      return '$hour:${minute.toString().padLeft(2, '0')} AM';
    } else if (hour == 12) {
      return '12:${minute.toString().padLeft(2, '0')} PM';
    } else {
      return '${hour - 12}:${minute.toString().padLeft(2, '0')} PM';
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _getWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }
}