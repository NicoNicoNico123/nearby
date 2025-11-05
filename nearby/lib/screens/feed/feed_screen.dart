import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../theme/app_theme.dart';
import '../../models/group_model.dart';
import '../../widgets/loading_states.dart';
import '../../services/map_service.dart';
import '../../services/mock_data_service.dart';
import '../../utils/logger.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen>
    with AutomaticKeepAliveClientMixin {
  final MockDataService _dataService = MockDataService();
  final ScrollController _scrollController = ScrollController();

  final List<Group> _groups = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 6;
  final TextEditingController _extraPotsController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadMoreGroups();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _extraPotsController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreGroups();
    }
  }

  Future<void> _loadMoreGroups() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(
        const Duration(milliseconds: 500),
      ); // Simulate network
      final allGroups = _dataService.getGroups();
      final startIndex = _currentPage * _pageSize;
      final endIndex = (startIndex + _pageSize).clamp(0, allGroups.length);

      if (startIndex >= allGroups.length) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      final newGroups = allGroups.sublist(startIndex, endIndex);

      setState(() {
        _groups.addAll(newGroups);
        _currentPage++;
        _isLoading = false;
        _hasMore = endIndex < allGroups.length;
      });

      Logger.info('Loaded ${newGroups.length} groups (page $_currentPage)');
    } catch (e) {
      Logger.error('Failed to load more groups', error: e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _groups.clear();
      _currentPage = 0;
      _hasMore = true;
    });
    await _loadMoreGroups();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        title: const Text(
          'Feed',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilterScreen(),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.tune, color: Colors.white, size: 20),
            ),
            tooltip: 'Filter Groups',
          ),
          IconButton(
            onPressed: () => _showSortOptions(),
            icon: const Icon(Icons.sort, color: AppTheme.textPrimary),
          ),
        ],
      ),
      body: RefreshIndicator(onRefresh: _refresh, child: _buildFeed()),
    );
  }

  Widget _buildFeed() {
    if (_groups.isEmpty && _isLoading) {
      return _buildLoadingFeed();
    }

    if (_groups.isEmpty) {
      return EmptyState(
        icon: Icons.group_outlined,
        title: 'No dining events available',
        subtitle: 'Check back later for new dining events in your area',
        action: TextButton(onPressed: _refresh, child: const Text('Refresh')),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Header with stats
        SliverToBoxAdapter(child: _buildFeedHeader()),

        // Group feed
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            if (index >= _groups.length) {
              return null;
            }

            final group = _groups[index];
            return Column(
              children: [
                if (index == 0) const SizedBox(height: AppTheme.spacingSM),
                _buildGroupCard(group),
                if (index < _groups.length - 1)
                  const Divider(
                    height: 1,
                    indent: 88,
                    color: AppTheme.dividerColor,
                  ),
              ],
            );
          }, childCount: _groups.length),
        ),

        // Loading indicator at bottom
        if (_isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacingXL),
              child: Center(child: LoadingSpinner()),
            ),
          ),

        // End of feed indicator
        if (!_hasMore && _groups.isNotEmpty)
          SliverToBoxAdapter(child: _buildEndOfFeed()),
      ],
    );
  }

  Widget _buildLoadingFeed() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShimmer(200, 24),
                const SizedBox(height: AppTheme.spacingSM),
                _buildShimmer(150, 16),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => const LoadingCard(),
            childCount: 5,
          ),
        ),
      ],
    );
  }

  Widget _buildShimmer(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      ),
    );
  }

  Widget _buildFeedHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      margin: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_dining,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingXS),
              const Text(
                'Today\'s Dining Events',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            '${_groups.length} dining events available nearby',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildEndOfFeed() {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 48,
            color: AppTheme.textTertiary,
          ),
          const SizedBox(height: AppTheme.spacingMD),
          Text(
            'You\'re all caught up!',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            'Check back later for more people',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppTheme.textTertiary),
          ),
          const SizedBox(height: AppTheme.spacingLG),
          TextButton(onPressed: _refresh, child: const Text('Refresh Feed')),
        ],
      ),
    );
  }

  void _showFilterScreen() async {
    final result = await Navigator.pushNamed(context, '/filter');
    if (result != null && mounted) {
      // Apply filters returned from filter screen
      setState(() {
        _groups.clear();
        _currentPage = 0;
        _hasMore = true;
      });
      await _loadMoreGroups();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Filters applied!'),
            backgroundColor: AppTheme.primaryColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: AppTheme.spacingMD),
            decoration: BoxDecoration(
              color: AppTheme.textTertiary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sort by', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppTheme.spacingMD),
                _buildSortOption('Distance (Nearest)', Icons.location_on),
                _buildSortOption('Recently Active', Icons.access_time),
                _buildSortOption('Newest Members', Icons.person_add),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortOption(String label, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primaryColor),
      title: Text(label),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sort by $label - coming soon!')),
        );
      },
    );
  }

  Widget _buildGroupCard(Group group) {
    return InkWell(
      onTap: () => _showGroupDetails(group),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacingMD,
          vertical: AppTheme.spacingXS,
        ),
        decoration: BoxDecoration(
          color: AppTheme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section
            Container(
              height: 180,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                color: AppTheme.surfaceColor,
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    // Group image
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
                    ),
                    // Top overlay with pot and cost info
                    Positioned(
                      top: AppTheme.spacingSM,
                      left: AppTheme.spacingSM,
                      child: Row(
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
                    ),
                    // Bottom overlay with interests
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.spacingSM),
                        child: Wrap(
                          spacing: AppTheme.spacingXS,
                          runSpacing: AppTheme.spacingXS,
                          children: group.interests.take(3).map((interest) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppTheme.spacingSM,
                                vertical: AppTheme.spacingXS,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.6),
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
                    // Availability indicator
                    Positioned(
                      top: AppTheme.spacingSM,
                      right: AppTheme.spacingSM,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSM,
                          vertical: AppTheme.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          color: _getAvailabilityColor(group),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _getAvailabilityIcon(group),
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _getAvailabilityText(group),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Group name
                  Text(
                    group.name,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  // Description
                  Text(
                    group.description,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spacingSM),
                  // Location and time info
                  InkWell(
                    onTap: () => _showVenueLocationMap(group),
                    borderRadius: BorderRadius.circular(8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            group.venue,
                            style: const TextStyle(
                              color: AppTheme.primaryColor,
                              fontSize: 14,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.open_in_new,
                          size: 14,
                          color: AppTheme.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatEventTime(group.mealTime),
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.spacingSM),
                  // Action buttons - Different based on availability
                  Row(
                    children: [
                      if (group.availableSpots > 0) ...[
                        // Groups with availability - Show Join and Superlike buttons
                        Expanded(
                          child: InkWell(
                            onTap: () => _joinGroup(group),
                            borderRadius: BorderRadius.circular(24),
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
                            onTap: () => _superlikeJoinGroup(group),
                            borderRadius: BorderRadius.circular(28),
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
                      ] else ...[
                        // Full groups - Show Waiting List button only
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => _joinWaitingList(group),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Waiting List'),
                          ),
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
    );
  }

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

  void _showGroupDetails(Group group) {
    Logger.info('Showing details for group: ${group.name}');
    // Navigate to group details screen
    Navigator.pushNamed(
      context,
      '/group_info',
      arguments: {'groupId': group.id},
    );
  }

  void _showVenueLocationMap(Group group) async {
    // Use mock coordinates for demo if not available
    final lat = group.latitude ?? 40.7128; // Default to NYC
    final lng = group.longitude ?? -74.0060; // Default to NYC

    Logger.info('Opening map for venue: ${group.venue} at ($lat, $lng)');

    // Show simple confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.location_on,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Open Maps',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Open ${group.venue} in your map application?',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.backgroundColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 16,
                          color: AppTheme.primaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          kIsWeb ? 'Will open in your web browser' : 'Will open in your default map app',
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.gps_fixed,
                          size: 16,
                          color: AppTheme.textSecondary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Location: ${lat.toStringAsFixed(4)}, ${lng.toStringAsFixed(4)}',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Open'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && mounted) {
      try {
        await MapService.launchMap(
          latitude: lat,
          longitude: lng,
          venueName: group.venue,
        );
      } catch (e) {
        Logger.error('Failed to launch map', error: e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open map application'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _joinGroup(Group group) {
    _showJoinConfirmationDialog(group);
  }

  void _superlikeJoinGroup(Group group) {
    _showSuperlikeConfirmationDialog(group);
  }

  void _joinWaitingList(Group group) {
    Logger.info('Joining waiting list for group: ${group.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to waiting list for ${group.name}! 📝'),
        backgroundColor: Colors.orange,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showJoinConfirmationDialog(Group group) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Join Group',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                group.name,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Cost Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.attach_money,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Cost',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${group.joinCost} pts',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Group Pot Information
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.amber.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Icon(
                        Icons.savings,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Pots',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${group.groupPot} pts',
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Host Approval Status
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        group.memberCount < group.maxMembers ? Icons.check_circle : Icons.person_outline,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Host Approval',
                          style: TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          group.memberCount < group.maxMembers ? 'Not Required' : 'Required',
                          style: TextStyle(
                            color: group.memberCount < group.maxMembers ? Colors.green : Colors.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.textSecondary,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _processJoinRequest(group);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Request to Join'),
            ),
          ],
        );
      },
    );
  }

  void _processJoinRequest(Group group) {
    // Simulate processing the join request
    Logger.info('Processing join request for ${group.name}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Join request sent to ${group.creatorName}! Awaiting approval...'),
        backgroundColor: Colors.blue,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'View Status',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to requests status page (if implemented)
            Logger.info('Navigating to join requests status');
          },
        ),
      ),
    );
  }

  void _showSuperlikeConfirmationDialog(Group group) {
    // Reset controller and set default value
    _extraPotsController.text = '10';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppTheme.surfaceColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4AC7F0).withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Color(0xFF4AC7F0),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Superlike Join',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: double.maxFinite,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group.name,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Cost Information
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.attach_money,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Cost',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${group.joinCost} pts',
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Group Pot Information
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.amber.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.amber.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Icon(
                                Icons.savings,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Pots',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${group.groupPot} pts',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Host Approval Status
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.orange.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                group.memberCount < group.maxMembers ? Icons.check_circle : Icons.person_outline,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Host approval',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              group.memberCount < group.maxMembers ? 'Not required' : 'Required',
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Extra Pots Contribution (Superlike exclusive)
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4AC7F0).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF4AC7F0).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF4AC7F0),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Extra Pots',
                                  style: TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _extraPotsController,
                              keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                hintText: 'Enter extra pots (minimum 10)',
                                suffixText: 'pts',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF4AC7F0).withValues(alpha: 0.5),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF4AC7F0).withValues(alpha: 0.5),
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF4AC7F0),
                                    width: 2,
                                  ),
                                ),
                                filled: true,
                                fillColor: const Color(0xFF4AC7F0).withValues(alpha: 0.05),
                              ),
                              onChanged: (value) {
                                // Ensure minimum value of 10
                                if (value.isNotEmpty && int.tryParse(value) != null) {
                                  final intValue = int.parse(value);
                                  if (intValue < 10) {
                                    _extraPotsController.text = '10';
                                    _extraPotsController.selection = TextSelection.fromPosition(
                                      TextPosition(offset: _extraPotsController.text.length),
                                    );
                                  }
                                }
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Superlike requires extra pots to increase your visibility and priority (minimum 10 pts)',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Total Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Cost:',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${(group.joinCost) + (int.tryParse(_extraPotsController.text) ?? 10)} pts',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _processSuperlikeJoinRequest(group);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4AC7F0),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Superlike Join'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _processSuperlikeJoinRequest(Group group) {
    final extraPots = int.tryParse(_extraPotsController.text) ?? 10;
    final totalCost = (group.joinCost) + extraPots;

    // Simulate processing the superlike join request
    Logger.info('Processing superlike join request for ${group.name} with $extraPots extra pots');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Superlike request sent! ⭐ ($totalCost pts spent - $extraPots extra pots added)',
        ),
        backgroundColor: const Color(0xFF4AC7F0),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'View Status',
          textColor: Colors.white,
          onPressed: () {
            // Navigate to requests status page (if implemented)
            Logger.info('Navigating to superlike join requests status');
          },
        ),
      ),
    );
  }

  // Helper methods for availability indicator
  Color _getAvailabilityColor(Group group) {
    final availabilityPercentage = group.availableSpots / group.maxMembers;

    if (availabilityPercentage == 0) {
      return Colors.red.withValues(alpha: 0.9);
    } else if (availabilityPercentage >= 0.5) {
      return Colors.green.withValues(alpha: 0.9);
    } else {
      return Colors.orange.withValues(alpha: 0.9); // Orange/yellow for below 50%
    }
  }

  IconData _getAvailabilityIcon(Group group) {
    if (group.availableSpots == 0) {
      return Icons.person_off; // No seats available
    } else if (group.availableSpots >= group.maxMembers * 0.5) {
      return Icons.people; // Good availability
    } else {
      return Icons.person; // Limited availability
    }
  }

  String _getAvailabilityText(Group group) {
    return '${group.memberCount}/${group.maxMembers}';
  }
}
