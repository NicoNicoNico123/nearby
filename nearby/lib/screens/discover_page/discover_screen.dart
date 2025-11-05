import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/group_model.dart';
import '../../widgets/group_card.dart';
import '../../widgets/loading_states.dart';
import '../../services/mock_data_service.dart';
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
        Container(
          height: 540, // Adjusted height for proper card display
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
              childAspectRatio: 0.65, // Adjusted for better card fit
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
        const SizedBox(height: 80), // Bottom padding for navigation
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