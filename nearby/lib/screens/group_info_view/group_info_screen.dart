import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../../theme/app_theme.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/member_profile_popup.dart';
import '../../services/mock/mock_data_service.dart';
import '../../services/map_service.dart';
import '../../utils/logger.dart';

class GroupInfoScreen extends StatefulWidget {
  final Group? group;

  const GroupInfoScreen({super.key, this.group});

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final MockDataService _dataService = MockDataService();
  late Group _group;
  bool _isCreatingNew = false;
  bool _isEditMode = false;
  bool _isLoading = false;

  // Form controllers for creating/editing
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _venueController = TextEditingController();
  final _locationController = TextEditingController();
  final DateTime _mealTime = DateTime.now().add(const Duration(hours: 3));
  final List<String> _selectedInterests = [];
    int _maxMembers = 10;

  // Current user ID (in real app, this would come from auth service)
  static const String _currentUserId = 'current_user';

  // Helper method to get actual member count including creator, current user, and all members
  int get _actualMemberCount {
    final Set<String> allMembers = <String>{};

    // Always include the creator
    allMembers.add(_group.creatorId);

    // Include all member IDs from the list
    allMembers.addAll(_group.memberIds);

    // Ensure current user is counted if they're different from creator and not already in memberIds
    if (_currentUserId != _group.creatorId && !allMembers.contains(_currentUserId)) {
      allMembers.add(_currentUserId);
    }

    return allMembers.length;
  }

  // Helper method to get actual available spots
  int get _actualAvailableSpots => _group.maxMembers - _actualMemberCount;

  @override
  void initState() {
    super.initState();
    if (widget.group != null) {
      _group = widget.group!;
      _isCreatingNew = false;
    } else {
      _isCreatingNew = true;
      _initializeNewGroup();
    }
  }

  void _initializeNewGroup() {
    _group = Group(
      id: 'new_group_${DateTime.now().millisecondsSinceEpoch}',
      name: '',
      description: '',
      subtitle: 'Creating new dining group',
      imageUrl: 'https://picsum.photos/400/300?random=new',
      interests: [],
      memberCount: 1,
      creatorId: _currentUserId,
      creatorName: 'You',
      venue: '',
      mealTime: _mealTime,
      maxMembers: _maxMembers,
      memberIds: [_currentUserId],
      createdAt: DateTime.now(),
      location: '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _venueController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
        title: Text(
          _isCreatingNew ? 'Create Group' : _isEditMode ? 'Edit Group' : 'Group Details',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
        ),
        actions: [
          if (!_isCreatingNew && _group.isCreator(_currentUserId))
            IconButton(
              onPressed: _editGroup,
              icon: const Icon(Icons.edit, color: AppTheme.textPrimary),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacingMD),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_isCreatingNew) ...[
                    _buildCreateGroupForm(),
                    const SizedBox(height: AppTheme.spacingXL),
                  ] else if (_isEditMode) ...[
                    _buildEditGroupForm(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildMembershipStatus(),
                    const SizedBox(height: AppTheme.spacingLG),
                    _buildMembersSection(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildEditActions(),
                  ] else ...[
                    _buildGroupHeader(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildGroupInfo(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildMembershipStatus(),
                    const SizedBox(height: AppTheme.spacingLG),
                    _buildMembersSection(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildGroupActions(),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildCreateGroupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create New Dining Group',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMD),
        _buildFormField('Group Name', _nameController, 'Enter group name'),
        const SizedBox(height: AppTheme.spacingMD),
        _buildFormField(
          'Description',
          _descriptionController,
          'Describe your group',
          maxLines: 3,
        ),
        const SizedBox(height: AppTheme.spacingMD),
        _buildFormField('Venue', _venueController, 'Restaurant or location'),
        const SizedBox(height: AppTheme.spacingMD),
        _buildFormField('Location', _locationController, 'Address or area'),
        const SizedBox(height: AppTheme.spacingMD),
        _buildDateTimePicker(),
        const SizedBox(height: AppTheme.spacingMD),
        _buildMaxMembersSelector(),
        const SizedBox(height: AppTheme.spacingMD),
        _buildInterestsSelector(),
        const SizedBox(height: AppTheme.spacingXL),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _createGroup,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spacingMD),
            ),
            child: const Text('Create Group'),
          ),
        ),
      ],
    );
  }

  Widget _buildEditGroupForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Edit Group',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppTheme.spacingMD),
        _buildFormField('Group Name', _nameController, 'Enter group name'),
        const SizedBox(height: AppTheme.spacingMD),
        _buildFormField(
          'Description',
          _descriptionController,
          'Describe your group',
          maxLines: 3,
        ),
        const SizedBox(height: AppTheme.spacingMD),
        _buildFormField('Venue', _venueController, 'Restaurant or location (50 pts)'),
        const SizedBox(height: AppTheme.spacingMD),
        _buildFormField('Location', _locationController, 'Address or area'),
        const SizedBox(height: AppTheme.spacingMD),
        _buildDateTimePicker(),
        const SizedBox(height: AppTheme.spacingMD),
        _buildMaxMembersSelector(),
        const SizedBox(height: AppTheme.spacingMD),
        _buildInterestsSelector(),
        const SizedBox(height: AppTheme.spacingXL),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _cancelEdit,
                child: const Text('Cancel'),
              ),
            ),
            const SizedBox(width: AppTheme.spacingMD),
            Expanded(
              child: ElevatedButton(
                onPressed: _saveEdit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                ),
                child: const Text('Save Changes'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEditActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _cancelEdit,
            child: const Text('Cancel Edit'),
          ),
        ),
        const SizedBox(width: AppTheme.spacingMD),
        Expanded(
          child: OutlinedButton(
            onPressed: _cancelGroup,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.errorColor,
              side: const BorderSide(color: AppTheme.errorColor),
            ),
            child: const Text('Cancel Group'),
          ),
        ),
      ],
    );
  }

  Widget _buildFormField(
    String label,
    TextEditingController controller,
    String hint, {
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSM),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppTheme.radiusSM),
            ),
            filled: true,
            fillColor: AppTheme.surfaceColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDateTimePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Meal Time',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSM),
        ListTile(
          onTap: _selectDateTime,
          leading: const Icon(Icons.schedule, color: AppTheme.primaryColor),
          title: Text(
            _formatDateTime(_mealTime),
            style: const TextStyle(color: AppTheme.textPrimary),
          ),
          trailing: const Icon(
            Icons.chevron_right,
            color: AppTheme.textTertiary,
          ),
          tileColor: AppTheme.surfaceColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
        ),
      ],
    );
  }

  
  Widget _buildMaxMembersSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Maximum Members',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: AppTheme.spacingSM),
        Row(
          children: [
            Expanded(
              child: Slider(
                value: _maxMembers.toDouble(),
                min: 2,
                max: 20,
                divisions: 18,
                label: '$_maxMembers members',
                onChanged: (value) {
                  setState(() {
                    _maxMembers = value.round();
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
            ),
            Container(
              width: 60,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(AppTheme.radiusSM),
              ),
              child: Center(
                child: Text(
                  '$_maxMembers',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInterestsSelector() {
    final availableInterests = [
      'Italian',
      'Japanese',
      'Mexican',
      'Thai',
      'Indian',
      'French',
      'Coffee',
      'Wine',
      'Cocktails',
      'Brunch',
      'Desserts',
      'BBQ',
      'Vegan',
      'GlutenFree',
      'SpicyFood',
      'Seafood',
      'Sushi',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Interests (up to 5)',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppTheme.spacingSM),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacingSM,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '${_selectedInterests.length}/5',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingSM),
        Wrap(
          spacing: AppTheme.spacingSM,
          runSpacing: AppTheme.spacingSM,
          children: availableInterests.map((interest) {
            final isSelected = _selectedInterests.contains(interest);
            return FilterChip(
              label: Text(interest),
              selected: isSelected,
              onSelected: _selectedInterests.length >= 5 && !isSelected
                  ? null
                  : (selected) {
                      setState(() {
                        if (selected) {
                          _selectedInterests.add(interest);
                        } else {
                          _selectedInterests.remove(interest);
                        }
                      });
                    },
              backgroundColor: AppTheme.surfaceColor,
              selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
              labelStyle: TextStyle(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.textPrimary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildGroupHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            color: AppTheme.surfaceColor,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            child: Image.network(
              _group.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppTheme.surfaceColor,
                  child: const Icon(
                    Icons.group,
                    size: 64,
                    color: AppTheme.textTertiary,
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.radiusLG),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacingMD),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _group.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingSM),
                Text(
                  _group.description,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGroupInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Group Information',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.spacingMD),
            _buildInfoRow(
              Icons.schedule,
              'Meal Time',
              _formatDateTime(_group.mealTime),
            ),
            _buildVenueInfoRow(),
            _buildInfoRow(Icons.person, 'Created by', _group.creatorName),
            _buildInfoRow(
              Icons.people,
              'Members',
              '$_actualMemberCount/${_group.maxMembers}',
            ),
                        const SizedBox(height: AppTheme.spacingMD),
            if (_group.interests.isNotEmpty) ...[
              const Text(
                'Interests',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppTheme.spacingSM),
              Wrap(
                spacing: AppTheme.spacingSM,
                runSpacing: AppTheme.spacingSM,
                children: _group.interests.map((interest) {
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
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMembershipStatus() {
    if (_group.isCreator(_currentUserId)) {
      return Card(
        color: AppTheme.primaryColor.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.admin_panel_settings,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You are the Host',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'You can edit this group and manage members',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_group.isMember(_currentUserId)) {
      return Card(
        color: Colors.green.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You are a Member',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'You can participate in group chat and activities',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_group.isInWaitingList(_currentUserId)) {
      return Card(
        color: Colors.orange.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'You are on the Waiting List',
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Position ${_group.waitingList.indexOf(_currentUserId) + 1} of ${_group.waitingList.length}',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Not a member - show join prompt
    return Card(
      color: Colors.grey.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_add,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: AppTheme.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Not a Member Yet',
                    style: TextStyle(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _actualAvailableSpots > 0
                        ? '$_actualAvailableSpots spots available'
                        : 'Group is full - join waiting list',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMD),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 20),
          const SizedBox(width: AppTheme.spacingMD),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenueInfoRow() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spacingMD),
      child: InkWell(
        onTap: _showVenueLocationMap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          children: [
            Icon(Icons.location_on, color: AppTheme.primaryColor, size: 20),
            const SizedBox(width: AppTheme.spacingMD),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Venue',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _group.venue,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppTheme.spacingSM),
                      Icon(
                        Icons.open_in_new,
                        size: 16,
                        color: AppTheme.primaryColor,
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

  Widget _buildMembersSection() {
    final currentUser = _dataService.getCurrentUser();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Members ($_actualMemberCount)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (_group.memberIds.length > 5)
                  TextButton(
                    onPressed: _showAllMembers,
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),
            // Show creator first
            GestureDetector(
              onTap: () {
                final creatorUser = _generateCreatorUser();
                _showMemberProfile(creatorUser);
              },
              behavior: HitTestBehavior.opaque,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    UserAvatar(
                      name: _group.creatorName,
                      imageUrl: 'https://picsum.photos/100/100?random=creator',
                      size: 40,
                    ),
                    const SizedBox(width: AppTheme.spacingMD),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                _group.creatorName,
                                style: const TextStyle(
                                  color: AppTheme.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: AppTheme.spacingXS),
                              _buildGenderIcon(['Male', 'Female', 'LGBTQ+'][_group.creatorId.hashCode % 3]),
                            ],
                          ),
                          const Text(
                            'Group Creator',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSM,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Host',
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Add current user if not creator and not a member
            if (!_group.isCreator(_currentUserId) &&
                !_group.isMember(_currentUserId)) ...[
              const SizedBox(height: AppTheme.spacingMD),
              const Divider(),
              const SizedBox(height: AppTheme.spacingMD),
              GestureDetector(
                onTap: () {
                  _showMemberProfile(currentUser);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      UserAvatar(
                        name: currentUser.name,
                        imageUrl: currentUser.imageUrl,
                        size: 40,
                      ),
                      const SizedBox(width: AppTheme.spacingMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  currentUser.name,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingXS),
                                _buildGenderIcon(currentUser.gender),
                              ],
                            ),
                            const Text(
                              'You',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // Add current user if they are a member (but not creator)
            if (!_group.isCreator(_currentUserId) && _group.isMember(_currentUserId)) ...[
              const SizedBox(height: AppTheme.spacingMD),
              const Divider(),
              const SizedBox(height: AppTheme.spacingMD),
              GestureDetector(
                onTap: () {
                  _showMemberProfile(currentUser);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      UserAvatar(
                        name: currentUser.name,
                        imageUrl: currentUser.imageUrl,
                        size: 40,
                      ),
                      const SizedBox(width: AppTheme.spacingMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  currentUser.name,
                                  style: const TextStyle(
                                    color: AppTheme.textPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: AppTheme.spacingXS),
                                _buildGenderIcon(currentUser.gender),
                              ],
                            ),
                            const Text(
                              'You • Group Member',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            // Show other members (excluding creator and current user)
            if (_group.memberIds.length > 2 ||
                (_group.memberIds.length > 1 && !_group.isMember(_currentUserId))) ...[
              const SizedBox(height: AppTheme.spacingMD),
              const Divider(),
              const SizedBox(height: AppTheme.spacingSM),
              ..._buildOtherMembersList(),
            ],
            // Waiting list info
            if (_group.waitingList.isNotEmpty) ...[
              const SizedBox(height: AppTheme.spacingMD),
              const Divider(),
              const SizedBox(height: AppTheme.spacingSM),
              Text(
                'Waiting List (${_group.waitingList.length})',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGroupActions() {
    if (_group.isCreator(_currentUserId)) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _editGroup,
                  child: const Text('Edit Group'),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: OutlinedButton(
                  onPressed: _cancelGroup,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    side: const BorderSide(color: AppTheme.errorColor),
                  ),
                  child: const Text('Cancel Group'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Column(
      children: [
        if (_group.isMember(_currentUserId)) ...[
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _leaveGroup,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppTheme.errorColor,
                    side: const BorderSide(color: AppTheme.errorColor),
                  ),
                  child: const Text('Leave Group'),
                ),
              ),
              const SizedBox(width: AppTheme.spacingMD),
              Expanded(
                child: ElevatedButton(
                  onPressed: _viewChat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('View Chat'),
                ),
              ),
            ],
          ),
        ] else if (_group.isInWaitingList(_currentUserId)) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _leaveWaitingList,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.withValues(alpha: 0.2),
                foregroundColor: Colors.orange,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Leave Waiting List'),
            ),
          ),
        ] else ...[
          // Action buttons - Different based on availability
          if (_actualAvailableSpots > 0) ...[
            // Groups with availability - Show Join and Superlike buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _joinGroup,
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(28),
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
                      size: 26,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                InkWell(
                  onTap: _showJoinConfirmation,
                  borderRadius: BorderRadius.circular(28),
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF4AC7F0), Color(0xFF2196F3)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF4AC7F0).withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
            // Full groups - Show Waiting List button only
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _joinWaitingList,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.withValues(alpha: 0.2),
                  foregroundColor: Colors.orange,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    const SizedBox(width: AppTheme.spacingXS),
                    Text('$_actualMemberCount/${_group.maxMembers}'),
                    const SizedBox(width: AppTheme.spacingXS),
                    const Text('Waiting List'),
                  ],
                ),
              ),
            ),
          ],
        ],
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final groupDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (groupDate.isAtSameMomentAs(today)) {
      return 'Today at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else if (groupDate.isAtSameMomentAs(today.add(const Duration(days: 1)))) {
      return 'Tomorrow at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.day}/${dateTime.month} at ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }

  
  void _selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _mealTime,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );

    if (date != null) {
      if (!mounted) return;
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_mealTime),
      );

      if (time != null && mounted) {
        setState(() {
          final newDateTime = DateTime(
            date.year,
            date.month,
            date.day,
            time.hour,
            time.minute,
          );
          // Update mealTime for new group
          _group = _group.copyWith(mealTime: newDateTime);
        });
      }
    }
  }

  void _createGroup() async {
    if (_nameController.text.trim().isEmpty ||
        _venueController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate group creation
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _group = _group.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        venue: _venueController.text.trim(),
        location: _locationController.text.trim(),
        interests: List.from(_selectedInterests),
        maxMembers: _maxMembers,
      );
      _isLoading = false;
      _isCreatingNew = false;
    });

    Logger.info('Created group: ${_group.name}');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group created successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _editGroup() {
    setState(() {
      _isEditMode = true;
      _nameController.text = _group.name;
      _descriptionController.text = _group.description;
      _venueController.text = _group.venue;
      _locationController.text = _group.location ?? '';
      _maxMembers = _group.maxMembers;
      _selectedInterests.clear();
      _selectedInterests.addAll(_group.interests);
    });
  }

  void _saveEdit() {
    // Check what fields have changed and calculate costs
    final changedFields = <String, String>{};
    int totalCost = 0;

    // Check free fields (no cost)
    if (_nameController.text.trim() != _group.name) {
      changedFields['name'] = _nameController.text.trim();
    }
    if (_descriptionController.text.trim() != _group.description) {
      changedFields['description'] = _descriptionController.text.trim();
    }
    if (!const ListEquality().equals(_selectedInterests, _group.interests)) {
      changedFields['interests'] = _selectedInterests.join(', ');
    }

    // Check paid fields (50 points each)
    if (_venueController.text.trim() != _group.venue) {
      changedFields['venue'] = _venueController.text.trim();
      totalCost += 50;
    }
    // Note: In a real app, we'd compare DateTime objects for meal time
    // For now, we'll handle meal time changes in the cost popup

    if (totalCost > 0) {
      // Show cost confirmation popup
      _showEditCostPopup(changedFields, totalCost);
    } else if (changedFields.isNotEmpty) {
      // Free changes only, save directly
      _applyFreeEdits(changedFields);
    } else {
      // No changes made
      _cancelEdit();
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditMode = false;
      // Clear controllers
      _nameController.clear();
      _descriptionController.clear();
      _venueController.clear();
      _locationController.clear();
      _selectedInterests.clear();
    });
  }

  void _applyFreeEdits(Map<String, String> changedFields) {
    setState(() {
      // Apply free changes
      if (changedFields.containsKey('name')) {
        _group = _group.copyWith(name: changedFields['name']!);
      }
      if (changedFields.containsKey('description')) {
        _group = _group.copyWith(description: changedFields['description']!);
      }
      if (changedFields.containsKey('interests')) {
        _group = _group.copyWith(interests: _selectedInterests);
      }

      _isEditMode = false;
    });

    Logger.info('Applied free edits to group: ${_group.name}');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group updated successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _showEditCostPopup(Map<String, String> changedFields, int totalCost) async {
    // Mock user points balance (in real app, this would come from user service)
    const int userPointsBalance = 250;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.monetization_on,
                color: Colors.orange,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Confirm Edit Costs',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Making these changes will cost:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$totalCost points',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.account_balance_wallet,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Your balance: $userPointsBalance points',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            if (changedFields.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Changes:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ...changedFields.entries.map((entry) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Text(
                      '${entry.key}:',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(color: AppTheme.primaryColor),
                      ),
                    ),
                  ],
                ),
              )),
            ],
            const SizedBox(height: 16),
            const Text(
              '⚠️ This cost is charged because changing the venue or meal time affects all members.',
              style: TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          if (userPointsBalance >= totalCost)
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor,
              ),
              child: const Text('Confirm Edit'),
            )
          else
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, false);
                _showInsufficientPointsDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text('Insufficient Points'),
            ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _applyPaidEdits(changedFields, totalCost);
    }
  }

  void _showInsufficientPointsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.error_outline, color: Colors.red),
            SizedBox(width: 8),
            Text('Insufficient Points'),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'You don\'t have enough points to make these changes.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 12),
            Text(
              'Get more points by:\n• Creating new groups\n• Joining groups regularly\n• Upgrading to Premium',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In a real app, navigate to upgrade or points purchase screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Upgrade feature coming soon!'),
                  backgroundColor: AppTheme.primaryColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Get Points'),
          ),
        ],
      ),
    );
  }

  void _applyPaidEdits(Map<String, String> changedFields, int cost) {
    setState(() {
      // Apply all changes including paid ones
      if (changedFields.containsKey('name')) {
        _group = _group.copyWith(name: changedFields['name']!);
      }
      if (changedFields.containsKey('description')) {
        _group = _group.copyWith(description: changedFields['description']!);
      }
      if (changedFields.containsKey('interests')) {
        _group = _group.copyWith(interests: _selectedInterests);
      }
      if (changedFields.containsKey('venue')) {
        _group = _group.copyWith(venue: changedFields['venue']!);
      }

      _isEditMode = false;
    });

    Logger.info('Applied paid edits to group: ${_group.name} (cost: $cost points)');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Group updated successfully! ($cost points deducted)'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _viewChat() {
    // Navigate to chat screen for this group
    Navigator.pushNamed(
      context,
      '/chat',
      arguments: {
        'groupId': _group.id,
        'groupName': _group.name,
      },
    );
  }

  void _joinGroup() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _group = _group.copyWith(
        memberCount: _group.memberCount + 1,
        memberIds: [..._group.memberIds, _currentUserId],
      );
      _isLoading = false;
    });

    Logger.info('Joined group: ${_group.name}');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully joined the group!'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    }
  }

  void _showJoinConfirmation() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          'Join ${_group.name}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Joining this group will use:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.attach_money,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_group.joinCost} points',
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Group pot: ${_group.groupPot} points',
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Host approval: ${_group.creatorId == _currentUserId ? "Not required (you are the host)" : "Required"}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
            ),
            child: const Text('Join'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      _joinGroup();
    }
  }

  void _leaveGroup() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _group = _group.copyWith(
        memberCount: _group.memberCount - 1,
        memberIds: _group.memberIds
            .where((id) => id != _currentUserId)
            .toList(),
      );
      _isLoading = false;
    });

    Logger.info('Left group: ${_group.name}');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You have left the group'),
          backgroundColor: AppTheme.textSecondary,
        ),
      );
    }
  }

  void _joinWaitingList() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _group = _group.copyWith(
        waitingList: [..._group.waitingList, _currentUserId],
      );
      _isLoading = false;
    });

    Logger.info('Joined waiting list for: ${_group.name}');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Added to waiting list. You\'ll be notified when a spot opens!',
          ),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
    }
  }

  void _leaveWaitingList() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _group = _group.copyWith(
        waitingList: _group.waitingList
            .where((id) => id != _currentUserId)
            .toList(),
      );
      _isLoading = false;
    });

    Logger.info('Left waiting list for: ${_group.name}');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from waiting list'),
          backgroundColor: AppTheme.textSecondary,
        ),
      );
    }
  }

  void _cancelGroup() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Group'),
        content: const Text(
          'Are you sure you want to cancel this group? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Delete Group'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
      });

      Logger.info('Cancelled group: ${_group.name}');
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group has been cancelled'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  void _showMemberProfile(User user) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => MemberProfilePopup(
        user: user,
        onClose: () {
          Logger.info('Member profile popup closed for: ${user.name}');
        },
      ),
    );
  }

  void _showVenueLocationMap() async {
    // Use mock coordinates for demo if not available
    final lat = _group.latitude ?? 40.7128; // Default to NYC
    final lng = _group.longitude ?? -74.0060; // Default to NYC

    Logger.info('Opening map for venue: ${_group.venue} at ($lat, $lng)');

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
                'Open Venue Location',
                style: TextStyle(
                  color: AppTheme.textPrimary,
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
                'Open ${_group.venue} in your map application?',
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
          venueName: _group.venue,
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

  void _showAllMembers() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingLG),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppTheme.dividerColor)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${_group.name} Members',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: AppTheme.textSecondary),
                    ),
                  ],
                ),
              ),

              // Members list
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppTheme.spacingMD),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Creator
                      _buildFullMemberItem(
                        user: _generateCreatorUser(),
                        role: 'Group Creator',
                        roleColor: AppTheme.primaryColor,
                      ),

                      const SizedBox(height: AppTheme.spacingMD),
                      const Divider(),
                      const SizedBox(height: AppTheme.spacingMD),

                      // Other members
                      ..._generateAllMembers().asMap().entries.map((entry) {
                        final index = entry.key;
                        final member = entry.value;

                        return Column(
                          children: [
                            if (index > 0) ...[
                              const SizedBox(height: AppTheme.spacingMD),
                              const Divider(),
                              const SizedBox(height: AppTheme.spacingMD),
                            ],
                            _buildFullMemberItem(
                              user: member,
                              role: member.id == _currentUserId ? 'You' : 'Group Member',
                              roleColor: member.id == _currentUserId
                                  ? AppTheme.textTertiary
                                  : AppTheme.textSecondary,
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Generate creator user using mock data service
  User _generateCreatorUser() {
    // Try to get creator from mock data service first
    final existingCreator = _dataService.getUserById(_group.creatorId);

    if (existingCreator != null) {
      // Use existing user data from mock service with group-specific adjustments
      return existingCreator.copyWith(
        name: _group.creatorName, // Use the group's creator name
        bio: existingCreator.bio, // Use real bio from mock service
        intents: ['dining', 'friendship'], // Ensure consistent intents for this screen
      );
    } else {
      // Create a fallback creator user if not found in mock service
      Logger.warning('Creator with ID ${_group.creatorId} not found in mock data service, creating fallback user');
      return User(
        id: _group.creatorId,
        name: _group.creatorName,
        username: _group.creatorId,
        bio: 'Group creator passionate about dining and social experiences',
        age: 25 + (_group.creatorId.hashCode.abs() % 20), // Random age 25-45
        gender: ['Male', 'Female', 'LGBTQ+'][(_group.creatorId.hashCode % 3)],
        interests: ['Dining', 'Social', 'Food Exploration'],
        intents: ['dining', 'friendship'],
        imageUrl: 'https://picsum.photos/200/200?random=${_group.creatorId}',
        isPremium: false,
        isVerified: true,
        points: 500,
        userType: 'creator',
        lastSeen: DateTime.now(),
      );
    }
  }

  // Helper method to generate user data with fallback
  User _generateUserData(String memberId, {bool isCurrentUser = false}) {
    // Get user from mock data service
    final existingUser = _dataService.getUserById(memberId);
    if (existingUser != null) {
      // Use existing user data from mock service with optional current user adjustments
      return existingUser.copyWith(
        name: isCurrentUser ? 'You' : existingUser.name,
        username: isCurrentUser ? 'current_user' : existingUser.username,
        bio: isCurrentUser ? 'Your bio here' : existingUser.bio,
        intents: ['dining', 'friendship'], // Ensure consistent intents for this screen
      );
    } else {
      // Create a fallback user if not found in mock service
      Logger.warning('User with ID $memberId not found in mock data service, creating fallback user');
      return User(
        id: memberId,
        name: isCurrentUser ? 'You' : 'User $memberId',
        username: memberId,
        bio: isCurrentUser ? 'Your bio here' : 'Dining enthusiast and social explorer',
        age: 22 + (memberId.hashCode.abs() % 25), // Random age 22-47
        gender: ['Male', 'Female', 'LGBTQ+'][memberId.hashCode.abs() % 3],
        interests: ['Dining', 'Social', 'Food'],
        intents: ['dining', 'friendship'],
        imageUrl: 'https://picsum.photos/200/200?random=$memberId',
        isPremium: isCurrentUser ? false : (memberId.hashCode.abs() % 3 == 0),
        isVerified: isCurrentUser ? true : (memberId.hashCode.abs() % 2 == 0),
        points: 100 + (memberId.hashCode.abs() % 400),
        userType: 'normal',
        lastSeen: DateTime.now(),
      );
    }
  }

  // Generate all other members using mock data service
  List<User> _generateAllMembers() {
    final memberIds = _group.memberIds.where((id) => id != _group.creatorId).toList();

    return memberIds.map((memberId) {
      return _generateUserData(memberId, isCurrentUser: memberId == _currentUserId);
    }).toList();
  }

  // Build full member item for the dialog
  Widget _buildFullMemberItem({
    required User user,
    required String role,
    required Color roleColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Row(
        children: [
          // Avatar
          UserAvatar(
            name: user.name,
            imageUrl: user.imageUrl,
            size: 50,
          ),
          const SizedBox(width: AppTheme.spacingMD),

          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and gender icon
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        user.name,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: AppTheme.spacingXS),
                    _buildGenderIcon(user.gender),
                  ],
                ),
                const SizedBox(height: AppTheme.spacingXS),

                // Role and age
                Text(
                  '$role • ${_getAgeRange(user.age ?? 25)}',
                  style: TextStyle(
                    color: roleColor,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),

                // Interests
                const SizedBox(height: AppTheme.spacingSM),
                Wrap(
                  spacing: AppTheme.spacingXS,
                  runSpacing: AppTheme.spacingXS,
                  children: user.interests.take(3).map((interest) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingSM,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        interest,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),

          // View profile button
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              _showMemberProfile(user);
            },
            icon: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // Convert age to age range
  String _getAgeRange(int age) {
    if (age <= 20) return '20-';
    if (age <= 30) return '21-30';
    if (age <= 40) return '31-40';
    if (age <= 50) return '41-50';
    return '50+';
  }

  List<Widget> _buildOtherMembersList() {
    final otherMemberIds = _group.memberIds
        .where((id) => id != _group.creatorId && id != _currentUserId)
        .toList(); // Show all other members (no limit)

    return otherMemberIds.asMap().entries.map((entry) {
      final memberIndex = entry.key;
      final memberId = entry.value;

      // Use the shared helper method to generate user data
      final user = _generateUserData(memberId, isCurrentUser: false);

      return Column(
        children: [
          if (memberIndex > 0) const SizedBox(height: AppTheme.spacingMD),
          GestureDetector(
            onTap: () => _showMemberProfile(user),
            behavior: HitTestBehavior.opaque,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  UserAvatar(
                    name: user.name,
                    imageUrl: user.imageUrl,
                    size: 40,
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              user.name,
                              style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingXS),
                            _buildGenderIcon(user.gender),
                          ],
                        ),
                        Text(
                          'Group Member',
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    }).toList();
  }

  
// Helper method to build gender icon
  Widget _buildGenderIcon(String gender) {
    switch (gender.toLowerCase()) {
      case 'male':
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.male,
            size: 16,
            color: Colors.blue,
          ),
        );
      case 'female':
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.pink.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.female,
            size: 16,
            color: Colors.pink,
          ),
        );
      case 'lgbtq+':
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
          ),
          child: CustomPaint(
            size: const Size(16, 12),
            painter: RainbowFlagPainter(),
          ),
        );
      default:
        return Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.grey.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Icon(
            Icons.person,
            size: 16,
            color: Colors.grey,
          ),
        );
    }
  }
}

// Custom painter for rainbow flag
class RainbowFlagPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final stripeHeight = size.height / 6;

    // Rainbow flag colors (top to bottom)
    final colors = [
      const Color(0xFFE40303), // Red
      const Color(0xFFFF8C00), // Orange
      const Color(0xFFFFED00), // Yellow
      const Color(0xFF008026), // Green
      const Color(0xFF004CFF), // Blue
      const Color(0xFF750787), // Purple
    ];

    // Draw each stripe
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
