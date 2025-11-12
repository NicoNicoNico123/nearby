import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/group_model.dart';
import '../../widgets/group_card.dart';
import '../../widgets/loading_states.dart';
import '../../services/mock/mock_data_service.dart';
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
  final MockDataService _dataService = MockDataService();

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
      // Get groups from MockDataService
      final allGroups = _dataService.getGroups();

      // Split into recommended and all groups
      setState(() {
        _allGroups = allGroups;
        _recommendedGroups = allGroups.take(5).toList(); // First 5 as recommended
        _isLoading = false;
      });

      Logger.info('Loaded ${allGroups.length} groups for discover screen');
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
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        title: const Text(
          'Discover',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilterOptions(),
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
        ],
      ),
      body: _isLoading
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
    );
  }

  
  // Enhanced "Recommended for you" section
  Widget _buildRecommendedSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMD,
            AppTheme.spacingLG,
            AppTheme.spacingMD,
            AppTheme.spacingMD,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.recommend,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingXS),
              const Text(
                'Recommended for you',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: _refreshRecommendations,
                child: const Text(
                  'See All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          height: 560, // Increased height to accommodate flexible GroupCard
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppTheme.borderColor,
                width: 1,
              ),
            ),
          ),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
            itemCount: _recommendedGroups.length,
            itemBuilder: (context, index) {
              final group = _recommendedGroups[index];
              return Padding(
                padding: const EdgeInsets.only(right: AppTheme.spacingMD),
                child: GroupCard(
                  group: group,
                  isHorizontal: true,
                  onTap: () => _showGroupDetails(group),
                  onLike: () => _likeGroup(group),
                  onSuperlike: () => _superlikeGroup(group),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Enhanced "Groups for you" section
  Widget _buildGroupsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(
            AppTheme.spacingMD,
            AppTheme.spacingLG,
            AppTheme.spacingMD,
            AppTheme.spacingMD,
          ),
          decoration: const BoxDecoration(
            border: Border(
              top: BorderSide(
                color: AppTheme.borderColor,
                width: 1,
              ),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.groups,
                color: AppTheme.primaryColor,
                size: 20,
              ),
              const SizedBox(width: AppTheme.spacingXS),
              const Text(
                'Groups for you',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacingSM,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    width: 1,
                  ),
                ),
                child: Text(
                  '${_allGroups.length} groups',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: AppTheme.spacingMD,
              mainAxisSpacing: AppTheme.spacingMD,
              childAspectRatio: 0.65, // Slightly adjust for better fit
              mainAxisExtent: 280, // Fixed height to prevent overflow
            ),
            itemCount: _allGroups.length,
            itemBuilder: (context, index) {
              final group = _allGroups[index];
              return InkWell(
                onTap: () => _showGroupDetails(group),
                borderRadius: BorderRadius.circular(12),
                child: GroupCard(
                  group: group,
                  isHorizontal: false,
                  onTap: () => _showGroupDetails(group),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 100), // Enhanced bottom padding for navigation
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

  void _refreshRecommendations() {
    Logger.info('Refreshing recommendations');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Refreshing recommendations...'),
        backgroundColor: AppTheme.primaryColor,
        duration: Duration(seconds: 1),
      ),
    );
    // Reload groups with animation
    _loadGroups();
  }

  void _showFilterOptions() {
    Logger.info('Opening filter options');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Filter options coming soon!'),
        backgroundColor: AppTheme.textSecondary,
        duration: Duration(seconds: 2),
      ),
    );
  }
}