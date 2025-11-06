import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:collection/collection.dart';
import '../../theme/app_theme.dart';
import '../../models/group_model.dart';
import '../../models/user_model.dart';
import '../../widgets/user_avatar.dart';
import '../../widgets/member_profile_popup.dart';
import '../../services/mock_data_service.dart';
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
              '${_group.memberCount}/${_group.maxMembers}',
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
                    _group.availableSpots > 0
                        ? '${_group.availableSpots} spots available'
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
                  'Members (${_group.memberCount})',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (_group.memberCount > 5)
                  TextButton(
                    onPressed: _showAllMembers,
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingMD),
            // Show creator first
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    final creatorUser = User(
                      id: _group.creatorId,
                      name: _group.creatorName,
                      username: _group.creatorName.toLowerCase().replaceAll(' ', '_'),
                      age: 25 + (_group.creatorId.hashCode % 20), // Mock age
                      bio: 'Group creator who loves organizing dining experiences and meeting new people.',
                      imageUrl: 'https://picsum.photos/100/100?random=creator',
                      interests: ['Dining', 'Social', 'Food'],
                      isAvailable: true,
                      distance: 5.0,
                      lastSeen: DateTime.now().subtract(const Duration(hours: 2)),
                      intents: ['dining', 'friendship'],
                    );
                    _showMemberProfile(creatorUser);
                  },
                  child: UserAvatar(
                    name: _group.creatorName,
                    imageUrl: 'https://picsum.photos/100/100?random=creator',
                    size: 40,
                  ),
                ),
                const SizedBox(width: AppTheme.spacingMD),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _group.creatorName,
                        style: const TextStyle(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
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
            // Add current user if not creator and not a member
            if (!_group.isCreator(_currentUserId) &&
                !_group.isMember(_currentUserId)) ...[
              const SizedBox(height: AppTheme.spacingMD),
              const Divider(),
              const SizedBox(height: AppTheme.spacingMD),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      _showMemberProfile(currentUser);
                    },
                    child: UserAvatar(
                      name: currentUser.name,
                      imageUrl: currentUser.imageUrl,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingMD),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser.name,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSM,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.textTertiary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Not Joined',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
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
          if (_group.availableSpots > 0) ...[
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
                    Text('${_group.memberCount}/${_group.maxMembers}'),
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
      builder: (context) => AlertDialog(
        title: Text('${_group.name} Members'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show all members here in a real implementation
            const Text('Full member list would be shown here'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
