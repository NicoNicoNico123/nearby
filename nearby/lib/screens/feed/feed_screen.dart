import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/user_model.dart';
import '../../widgets/user_card.dart';
import '../../widgets/loading_states.dart';
import '../../widgets/user_avatar.dart';
import '../../services/mock_data_service.dart';
import '../../utils/logger.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> with AutomaticKeepAliveClientMixin {
  final MockDataService _dataService = MockDataService();
  final ScrollController _scrollController = ScrollController();

  List<User> _users = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _currentPage = 0;
  final int _pageSize = 10;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadMoreUsers();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreUsers();
    }
  }

  Future<void> _loadMoreUsers() async {
    if (_isLoading || !_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate network
      final allUsers = _dataService.getNearbyUsers();
      final startIndex = _currentPage * _pageSize;
      final endIndex = (startIndex + _pageSize).clamp(0, allUsers.length);

      if (startIndex >= allUsers.length) {
        setState(() {
          _hasMore = false;
          _isLoading = false;
        });
        return;
      }

      final newUsers = allUsers.sublist(startIndex, endIndex);

      setState(() {
        _users.addAll(newUsers);
        _currentPage++;
        _isLoading = false;
        _hasMore = endIndex < allUsers.length;
      });

      Logger.info('Loaded ${newUsers.length} users (page $_currentPage)');
    } catch (e) {
      Logger.error('Failed to load more users', error: e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _users.clear();
      _currentPage = 0;
      _hasMore = true;
    });
    await _loadMoreUsers();
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
            onPressed: () => _showSortOptions(),
            icon: const Icon(Icons.sort, color: AppTheme.textPrimary),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: _buildFeed(),
      ),
    );
  }

  Widget _buildFeed() {
    if (_users.isEmpty && _isLoading) {
      return _buildLoadingFeed();
    }

    if (_users.isEmpty) {
      return EmptyState(
        icon: Icons.people_outline,
        title: 'No one nearby',
        subtitle: 'Check back later for new people in your area',
        action: TextButton(
          onPressed: _refresh,
          child: const Text('Refresh'),
        ),
      );
    }

    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        // Header with stats
        SliverToBoxAdapter(
          child: _buildFeedHeader(),
        ),

        // User feed
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              if (index >= _users.length) {
                return null;
              }

              final user = _users[index];
              return Column(
                children: [
                  if (index == 0) const SizedBox(height: AppTheme.spacingSM),
                  UserCard(
                    user: user,
                    onTap: () => _showUserProfile(user),
                    showDistance: true,
                    showAvailability: true,
                  ),
                  if (index < _users.length - 1)
                    const Divider(height: 1, indent: 88, color: AppTheme.dividerColor),
                ],
              );
            },
            childCount: _users.length,
          ),
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
        if (!_hasMore && _users.isNotEmpty)
          SliverToBoxAdapter(
            child: _buildEndOfFeed(),
          ),
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
                'Today\'s Recommendations',
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
            '${_users.length} people available nearby',
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingSM),
          Text(
            'Check back later for more people',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: AppTheme.spacingLG),
          TextButton(
            onPressed: _refresh,
            child: const Text('Refresh Feed'),
          ),
        ],
      ),
    );
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
                Text(
                  'Sort by',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
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

  void _showUserProfile(User user) {
    Logger.info('Showing profile for ${user.name}');
    // Navigate to user profile detail view
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLG)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppTheme.spacingLG),
                  decoration: BoxDecoration(
                    color: AppTheme.textTertiary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  UserAvatar(
                    name: user.name,
                    imageUrl: user.imageUrl,
                    size: 80,
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (user.age != null)
                          Text(
                            'Age ${user.age}',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        if (user.distance != null)
                          Text(
                            '${user.distance?.round()} miles away',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textSecondary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingLG),
              if (user.bio.isNotEmpty) ...[
                Text(
                  'About',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Text(user.bio),
                const SizedBox(height: AppTheme.spacingLG),
              ],
              if (user.interests.isNotEmpty) ...[
                Text(
                  'Interests',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Wrap(
                  spacing: AppTheme.spacingXS,
                  runSpacing: AppTheme.spacingXS,
                  children: user.interests.map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSM,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
                      ),
                      child: Text(
                        interest,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: AppTheme.spacingXL),
              ],
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Connected with ${user.name}!')),
                        );
                      },
                      child: const Text('Connect'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Message sent to ${user.name}!')),
                        );
                      },
                      child: const Text('Message'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}