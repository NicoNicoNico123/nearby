import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/mock_data_service.dart';

class InterestSearchScreen extends StatefulWidget {
  final Set<String> initiallySelectedInterests;

  const InterestSearchScreen({
    super.key,
    required this.initiallySelectedInterests,
  });

  @override
  State<InterestSearchScreen> createState() => _InterestSearchScreenState();
}

class _InterestSearchScreenState extends State<InterestSearchScreen> {
  final MockDataService _dataService = MockDataService();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  Set<String> _selectedInterests = {};
  List<String> _availableInterests = [];
  List<String> _filteredInterests = [];
  List<String> _recommendedInterests = [];

  static const List<String> _popularInterests = [
    'Coffee', 'Travel', 'Photography', 'Music', 'Movies',
    'Reading', 'Cooking', 'Hiking', 'Art', 'Gaming',
    'Fitness', 'Food', 'Wine', 'Beer', 'Dancing',
    'Technology', 'Business', 'Fashion', 'Sports', 'Yoga'
  ];

  @override
  void initState() {
    super.initState();
    _selectedInterests = Set.from(widget.initiallySelectedInterests);
    _loadAvailableInterests();
    _searchFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _loadAvailableInterests() {
    final groups = _dataService.getGroups();
    final interestsSet = <String>{};

    for (final group in groups) {
      interestsSet.addAll(group.interests);
    }

    setState(() {
      _availableInterests = interestsSet.toList()..sort();
      _recommendedInterests = _getRecommendedInterests();
      _filteredInterests = _availableInterests;
    });
  }

  List<String> _getRecommendedInterests() {
    // Get recommended interests based on popularity and user selection
    final allInterests = _availableInterests;

    // Prioritize popular interests that are available
    final recommended = _popularInterests
        .where((interest) => allInterests.contains(interest))
        .take(8)
        .toList();

    // Add some available interests if not enough popular ones
    if (recommended.length < 8) {
      final additional = allInterests
          .where((interest) => !recommended.contains(interest))
          .take(8 - recommended.length)
          .toList();
      recommended.addAll(additional);
    }

    return recommended;
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredInterests = _recommendedInterests;
      } else {
        _filteredInterests = _availableInterests
            .where((interest) => interest.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else if (_selectedInterests.length < 2) {
        _selectedInterests.add(interest);
      } else {
        // Show message that maximum 2 interests can be selected
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Maximum 2 interests can be selected'),
            backgroundColor: AppTheme.primaryColor,
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  void _applySelection() {
    Navigator.pop(context, _selectedInterests);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        title: const Text(
          'Select Interests',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.close, color: AppTheme.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: _selectedInterests.isNotEmpty
                ? () => setState(() => _selectedInterests.clear())
                : null,
            child: Text(
              'Clear',
              style: TextStyle(
                color: _selectedInterests.isNotEmpty
                    ? AppTheme.primaryColor
                    : AppTheme.textTertiary,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            margin: const EdgeInsets.all(AppTheme.spacingMD),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.dividerColor),
            ),
            child: TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Search interests...',
                prefixIcon: const Icon(Icons.search, color: AppTheme.textSecondary),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          _onSearchChanged('');
                        },
                        icon: const Icon(Icons.clear, color: AppTheme.textSecondary),
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppTheme.spacingMD),
              ),
              style: const TextStyle(color: AppTheme.textPrimary),
            ),
          ),

          // Selection status
          Container(
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppTheme.primaryColor,
                  size: 20,
                ),
                const SizedBox(width: AppTheme.spacingSM),
                Expanded(
                  child: Text(
                    '${_selectedInterests.length}/2 interests selected',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppTheme.spacingMD),

          // Interest list
          Expanded(
            child: _filteredInterests.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: AppTheme.textTertiary,
                        ),
                        const SizedBox(height: AppTheme.spacingMD),
                        Text(
                          _searchController.text.isEmpty
                              ? 'No interests available'
                              : 'No interests found',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
                    itemCount: _filteredInterests.length,
                    itemBuilder: (context, index) {
                      final interest = _filteredInterests[index];
                      final isSelected = _selectedInterests.contains(interest);

                      return Container(
                        margin: const EdgeInsets.only(bottom: AppTheme.spacingXS),
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : AppTheme.dividerColor,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            interest,
                            style: TextStyle(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.textPrimary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          trailing: isSelected
                              ? Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                )
                              : null,
                          onTap: () => _toggleInterest(interest),
                        ),
                      );
                    },
                  ),
          ),

          // Apply button
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedInterests.isNotEmpty ? _applySelection : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  disabledBackgroundColor: AppTheme.textTertiary,
                ),
                child: Text(
                  'Apply Selection (${_selectedInterests.length})',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}