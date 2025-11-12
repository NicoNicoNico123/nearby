import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/group_model.dart';

class GroupCard extends StatelessWidget {
  final Group group;
  final VoidCallback? onTap;
  final VoidCallback? onLike;
  final VoidCallback? onSuperlike;
  final VoidCallback? onLocationTap;
  final bool isHorizontal;

  const GroupCard({
    super.key,
    required this.group,
    this.onTap,
    this.onLike,
    this.onSuperlike,
    this.onLocationTap,
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
                      group.imageUrl.isNotEmpty ? group.imageUrl : 'https://picsum.photos/400/300?random=fallback',
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
                    // Top overlay with pot, cost, gender, and age info
                    Positioned(
                      top: AppTheme.spacingSM,
                      left: AppTheme.spacingSM,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Group Pot
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSM,
                                  vertical: AppTheme.spacingXS,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.amber,
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Icon(
                                        Icons.savings,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${group.groupPot}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingXS),
                              // Join Cost
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppTheme.spacingSM,
                                  vertical: AppTheme.spacingXS,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.7),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(1),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.attach_money,
                                        color: Colors.white,
                                        size: 12,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${group.joinCost}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppTheme.spacingXS),
                          // Gender and Age Range Icons
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Gender Icons
                              ...group.allowedGenders
                                  .take(3)
                                  .map(
                                    (gender) => Padding(
                                      padding: const EdgeInsets.only(
                                        right: AppTheme.spacingXS,
                                      ),
                                      child: _buildGenderIcon(gender),
                                    ),
                                  ),
                              // Age Range Display
                              if (group.ageRangeMin > 18 ||
                                  group.ageRangeMax < 100) ...[
                                const SizedBox(width: AppTheme.spacingXS),
                                _buildAgeRangeDisplay(
                                  group.ageRangeMin,
                                  group.ageRangeMax,
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text(
                    group.name.isNotEmpty ? group.name : 'Group Name',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    group.description.isNotEmpty ? group.description : 'No description available',
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
                  InkWell(
                    onTap: onLocationTap,
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 14,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            group.venue.isNotEmpty ? group.venue : 'Venue TBD',
                            style: const TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          size: 12,
                          color: AppTheme.textTertiary,
                        ),
                      ],
                    ),
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
                        child: InkWell(
                          onTap: onLike,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            height: 48,
                            decoration: BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSM),
                      Expanded(
                        child: InkWell(
                          onTap: onSuperlike,
                          borderRadius: BorderRadius.circular(999),
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF4AC7F0),
                                  Color(0xFF00D4FF),
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF4AC7F0).withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 6),
                                ),
                                BoxShadow(
                                  color: const Color(0xFF00D4FF).withValues(alpha: 0.3),
                                  blurRadius: 20,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
                ),
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
      mainAxisSize: MainAxisSize.min, // Use minimum size to prevent overflow
      children: [
        // Image section
        Flexible(
          flex: 3, // Give image more space but make it flexible
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: AppTheme.surfaceColor,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  Image.network(
                    group.imageUrl.isNotEmpty ? group.imageUrl : 'https://picsum.photos/400/300?random=fallback',
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
                  // Top overlay with pot, cost, gender, and age info
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Group Pot
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Icon(
                                      Icons.savings,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${group.groupPot}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 4),
                            // Join Cost
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.attach_money,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${group.joinCost}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        // Gender and Age Range Icons
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Gender Icons
                            ...group.allowedGenders
                                .take(2)
                                .map(
                                  (gender) => Padding(
                                    padding: const EdgeInsets.only(right: 2),
                                    child: _buildGenderIcon(gender),
                                  ),
                                ),
                            // Age Range Display
                            if (group.ageRangeMin > 18 ||
                                group.ageRangeMax < 100) ...[
                              const SizedBox(width: 2),
                              _buildAgeRangeDisplay(
                                group.ageRangeMin,
                                group.ageRangeMax,
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Text content
        Flexible(
          flex: 1, // Give text content some flexible space
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXS),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  group.name.isNotEmpty ? group.name : 'Group Name',
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2, // Limit lines to prevent overflow
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Text(
                  group.subtitle.isNotEmpty ? group.subtitle : 'Group Activity',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  maxLines: 2, // Limit lines to prevent overflow
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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

  // Helper method to build gender icon
  Widget _buildGenderIcon(String gender) {
    if (gender.toLowerCase() == 'lgbtq+') {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.9),
                  width: 0.8,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: CustomPaint(painter: _RainbowFlagPainter()),
              ),
            ),
          ],
        ),
      );
    }

    IconData iconData;
    Color iconColor;

    switch (gender.toLowerCase()) {
      case 'male':
        iconData = Icons.male;
        iconColor = Colors.blue;
        break;
      case 'female':
        iconData = Icons.female;
        iconColor = Colors.pink;
        break;
      default:
        iconData = Icons.person;
        iconColor = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(iconData, color: Colors.white, size: 10),
          ),
        ],
      ),
    );
  }

  // Helper method to build age range display
  Widget _buildAgeRangeDisplay(int minAge, int maxAge) {
    String ageText;
    if (maxAge >= 100) {
      ageText = '$minAge+';
    } else {
      ageText = '$minAge-$maxAge';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 4,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.cake, color: Colors.white, size: 10),
          ),
          const SizedBox(width: 3),
          Text(
            ageText,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _RainbowFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final stripeHeight = size.height / 6;

    const colors = [
      Color(0xFFE40303), // Red
      Color(0xFFFF8C00), // Orange
      Color(0xFFFFED00), // Yellow
      Color(0xFF008026), // Green
      Color(0xFF004CFF), // Blue
      Color(0xFF750787), // Purple
    ];

    for (int i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      canvas.drawRect(
        Rect.fromLTWH(0, i * stripeHeight, size.width, stripeHeight),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}