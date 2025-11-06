import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/group_model.dart';
import '../../widgets/user_avatar.dart';
import '../../services/mock_data_service.dart';
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
          _isCreatingNew ? 'Create Group' : 'Group Details',
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
                  ] else ...[
                    _buildGroupHeader(),
                    const SizedBox(height: AppTheme.spacingXL),
                    _buildGroupInfo(),
                    const SizedBox(height: AppTheme.spacingXL),
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
            _buildInfoRow(Icons.location_on, 'Venue', _group.venue),
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
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _leaveGroup,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.errorColor,
                side: const BorderSide(color: AppTheme.errorColor),
              ),
              child: const Text('Leave Group'),
            ),
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
      _isCreatingNew = true;
      _nameController.text = _group.name;
      _descriptionController.text = _group.description;
      _venueController.text = _group.venue;
      _locationController.text = _group.location ?? '';
      _maxMembers = _group.maxMembers;
      _selectedInterests.clear();
      _selectedInterests.addAll(_group.interests);
    });
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
