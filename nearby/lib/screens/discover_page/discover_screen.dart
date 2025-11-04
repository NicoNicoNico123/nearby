import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/group_model.dart';
import '../../widgets/group_card.dart';
import '../../widgets/loading_states.dart';
import '../../utils/logger.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with AutomaticKeepAliveClientMixin {
  bool _isLoading = true;
  List<Group> _recommendedGroups = [];
  List<Group> _allGroups = [];

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Mock data for groups with reliable placeholder images
      final mockGroups = [
        Group(
          id: '1',
          name: 'Weekend Warriors',
          description: 'Looking for people to join our weekend adventures! We love hiking, trying new cafes, and exploring the city.',
          subtitle: 'Outdoor adventures',
          imageUrl: 'https://picsum.photos/400/300?random=1&blur=2',
          interests: ['Indie', 'Tennis'],
          memberCount: 127,
          category: 'adventure',
          creatorId: 'user_1',
          creatorName: 'Alex Johnson',
          venue: 'City Center Park',
          mealTime: DateTime.now().add(const Duration(hours: 24)),
          intent: 'friendship',
          createdAt: DateTime.now().subtract(const Duration(days: 7)),
        ),
        Group(
          id: '2',
          name: 'Concert Crew',
          description: 'Always looking for fellow music lovers to go to concerts and festivals with. Let\'s vibe together!',
          subtitle: 'Live music events',
          imageUrl: 'https://picsum.photos/400/300?random=2&blur=2',
          interests: ['Music', 'Concerts'],
          memberCount: 89,
          category: 'music',
          creatorId: 'user_2',
          creatorName: 'Sarah Chen',
          venue: 'Live Music Hall',
          mealTime: DateTime.now().add(const Duration(hours: 48)),
          intent: 'friendship',
          createdAt: DateTime.now().subtract(const Duration(days: 3)),
        ),
        Group(
          id: '3',
          name: 'Art & Coffee Lovers',
          description: 'Join us for gallery hopping, museum visits, and discovering the best coffee spots in town.',
          subtitle: 'Cultural exploration',
          imageUrl: 'https://picsum.photos/400/300?random=3&blur=2',
          interests: ['Art', 'Coffee'],
          memberCount: 64,
          category: 'culture',
          creatorId: 'user_3',
          creatorName: 'Mike Williams',
          venue: 'Modern Art Museum',
          mealTime: DateTime.now().add(const Duration(hours: 72)),
          intent: 'networking',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Group(
          id: '4',
          name: 'Book Club',
          description: 'Monthly meetings to discuss literature and share our favorite reads.',
          subtitle: 'Monthly meetings',
          imageUrl: 'https://picsum.photos/400/300?random=4&blur=2',
          interests: ['Reading', 'Discussion'],
          memberCount: 45,
          category: 'literature',
          creatorId: 'user_4',
          creatorName: 'Emma Davis',
          venue: 'Cozy Bookstore Café',
          mealTime: DateTime.now().add(const Duration(hours: 120)),
          intent: 'friendship',
          createdAt: DateTime.now().subtract(const Duration(days: 14)),
        ),
        Group(
          id: '5',
          name: 'Gamers Unite',
          description: 'Casual and competitive gaming sessions for all skill levels.',
          subtitle: 'Casual & Competitive',
          imageUrl: 'https://picsum.photos/400/300?random=5&blur=2',
          interests: ['Gaming', 'Tournaments'],
          memberCount: 156,
          category: 'gaming',
          creatorId: 'user_5',
          creatorName: 'David Kim',
          venue: 'Gaming Lounge',
          mealTime: DateTime.now().add(const Duration(hours: 96)),
          intent: 'friendship',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        Group(
          id: '6',
          name: 'Foodies',
          description: 'Exploring new restaurants and culinary experiences weekly.',
          subtitle: 'New restaurants weekly',
          imageUrl: 'https://picsum.photos/400/300?random=6&blur=2',
          interests: ['Food', 'Restaurants'],
          memberCount: 203,
          category: 'food',
          creatorId: 'user_6',
          creatorName: 'Lisa Martinez',
          venue: 'Downtown Bistro',
          mealTime: DateTime.now().add(const Duration(hours: 168)),
          intent: 'dining',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        Group(
          id: '7',
          name: 'Travel Buddies',
          description: 'Let\'s explore the world together and create amazing memories.',
          subtitle: 'Let\'s explore the world',
          imageUrl: 'https://picsum.photos/400/300?random=7&blur=2',
          interests: ['Travel', 'Adventure'],
          memberCount: 178,
          category: 'travel',
          creatorId: 'user_7',
          creatorName: 'James Wilson',
          venue: 'Travel Café',
          mealTime: DateTime.now().add(const Duration(hours: 144)),
          intent: 'networking',
          createdAt: DateTime.now().subtract(const Duration(days: 10)),
        ),
      ];

      setState(() {
        _recommendedGroups = mockGroups.take(3).toList();
        _allGroups = mockGroups.skip(3).toList();
        _isLoading = false;
      });
      Logger.info('Loaded ${mockGroups.length} groups');
    } catch (e) {
      Logger.error('Failed to load groups', error: e);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header matching HTML reference
            _buildHeader(),
            // Main content
            Expanded(
              child: _isLoading
                  ? const Center(child: LoadingSpinner())
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildRecommendedSection(),
                          _buildGroupsSection(),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Header matching HTML reference
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      child: Row(
        children: [
          // Logo placeholder
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.diversity_3,
              color: AppTheme.primaryColor,
              size: 24,
            ),
          ),
          // Title
          Expanded(
            child: Center(
              child: Text(
                'DISCOVER',
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Spacer for balance
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // "Recommended for you" section with horizontal scroll
  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMD,
            AppTheme.spacingLG,
            AppTheme.spacingMD,
            AppTheme.spacingMD,
          ),
          child: const Text(
            'Recommended for you',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(
          height: 530, // Slightly increased height
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
            itemCount: _recommendedGroups.length,
            itemBuilder: (context, index) {
              final group = _recommendedGroups[index];
              return GroupCard(
                group: group,
                isHorizontal: true,
                onTap: () => _showGroupDetails(group),
                onLike: () => _likeGroup(group),
                onSuperlike: () => _superlikeGroup(group),
              );
            },
          ),
        ),
      ],
    );
  }

  // "Groups for you" section with 2-column grid
  Widget _buildGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMD,
            AppTheme.spacingLG,
            AppTheme.spacingMD,
            AppTheme.spacingMD,
          ),
          child: const Text(
            'Groups for you',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.spacingMD,
              mainAxisSpacing: AppTheme.spacingMD,
              childAspectRatio: 0.75, // Adjusted for grid layout
            ),
            itemCount: _allGroups.length,
            itemBuilder: (context, index) {
              final group = _allGroups[index];
              return InkWell(
                onTap: () => _showGroupDetails(group),
                borderRadius: BorderRadius.circular(8),
                child: GroupCard(
                  group: group,
                  isHorizontal: false,
                  onTap: () => _showGroupDetails(group),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 100), // Bottom padding for navigation
      ],
    );
  }

  void _showGroupDetails(Group group) {
    Logger.info('Showing details for group: ${group.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Viewing ${group.name} - coming soon!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _likeGroup(Group group) {
    Logger.info('Liked group: ${group.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Liked ${group.name}! ❤️'),
        backgroundColor: AppTheme.primaryColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _superlikeGroup(Group group) {
    Logger.info('Superliked group: ${group.name}');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Superliked ${group.name}! ⭐'),
        backgroundColor: const Color(0xFF4AC7F0),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}