import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/group_model.dart';
import '../../utils/logger.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({super.key});

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  // Form controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _joinCostController = TextEditingController();
  final TextEditingController _hostAdditionalPointsController = TextEditingController();

  // Form state
  int _peopleLimit = 4;
  bool _approvedByCreator = false;
  bool _allowWaitingList = true;
  Set<String> _selectedGenders = {'Male', 'Female', 'LGBTQ+'}; // Multi-select genders
  Map<String, int> _genderLimits = {}; // Gender-based seat limits
  List<String> _selectedLanguages = []; // Language requirements
  int _ageRangeMin = 18;
  int _ageRangeMax = 35;
  List<String> _interests = ['Travel', 'Movie', 'Food']; // Will be validated to 3-8
  String? _uploadedImagePath;

  // UI state
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _joinCostController.dispose();
    _hostAdditionalPointsController.dispose();
    super.dispose();
  }

  void _closeScreen() {
    Navigator.of(context).pop();
  }

  bool _isFormValid() {
    return _titleController.text.trim().isNotEmpty &&
           _descriptionController.text.trim().isNotEmpty &&
           _locationController.text.trim().isNotEmpty &&
           _dateController.text.trim().isNotEmpty &&
           _timeController.text.trim().isNotEmpty &&
           _peopleLimit >= 2 &&
           _interests.length >= 3 && // Minimum 3 interests
           _interests.length <= 8; // Maximum 8 interests
  }

  void _showPostConfirmation() {
    if (!_isFormValid()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Create Group',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Creating this group will cost 100 points from your balance.',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 16),
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
                  Icon(
                    Icons.info_outline,
                    color: AppTheme.primaryColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Your current balance: 250 points',
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
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _submitGroup();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  Future<void> _submitGroup() async {
    if (!_isFormValid() || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Create new group with form data
      final titleText = _titleController.text.trim();
      final descriptionText = _descriptionController.text.trim();

      // Parse date and time
      final dateParts = _dateController.text.trim().split('/');
      final timeParts = _timeController.text.trim().split(RegExp('[: ]'));

      DateTime mealTime;
      try {
        if (dateParts.length >= 3) {
          final day = int.parse(dateParts[0]);
          final month = int.parse(dateParts[1]);
          final year = int.parse(dateParts[2]);

          int hour = 19; // default
          int minute = 0; // default
          if (timeParts.isNotEmpty) {
            final timeStr = timeParts[0];
            final timeMatch = RegExp(r'(\d+):(\d+)\s*(AM|PM)?').firstMatch(timeStr.toUpperCase());
            if (timeMatch != null) {
              hour = int.parse(timeMatch.group(1)!);
              minute = int.parse(timeMatch.group(2)!);
              final period = timeMatch.group(3);
              if (period == 'PM' && hour != 12) hour += 12;
              if (period == 'AM' && hour == 12) hour = 0;
            }
          }

          mealTime = DateTime(year, month, day, hour, minute);
        } else {
          mealTime = DateTime.now().add(const Duration(days: 1));
        }
      } catch (e) {
        mealTime = DateTime.now().add(const Duration(days: 1));
      }

      // Parse numeric values
      final joinCostFees = int.tryParse(_joinCostController.text.trim()) ?? 0;
      final hostAdditionalPoints = int.tryParse(_hostAdditionalPointsController.text.trim()) ?? 0;

      final newGroup = Group(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: titleText,
        description: descriptionText,
        subtitle: 'Join us for a great dining experience!',
        imageUrl: _uploadedImagePath ?? 'https://picsum.photos/400/300?random=${DateTime.now().millisecondsSinceEpoch}',
        interests: List.from(_interests),
        memberCount: 1, // Creator counts as first member
        creatorId: 'current_user', // Mock current user ID
        creatorName: 'You', // Mock current user name
        venue: _locationController.text.trim(),
        mealTime: mealTime,
        maxMembers: _peopleLimit,
        memberIds: ['current_user'], // Creator is first member
        waitingList: const [],
        createdAt: DateTime.now(),
        location: _locationController.text.trim(),
        latitude: 37.7749, // Mock coordinates
        longitude: -122.4194,
        groupPot: 0,
        joinCost: 0, // Mock groups are free
        // New enhanced fields
        title: titleText,
        allowedGenders: _selectedGenders.toList(),
        genderLimits: _genderLimits,
        allowedLanguages: _selectedLanguages,
        ageRangeMin: _ageRangeMin,
        ageRangeMax: _ageRangeMax,
        joinCostFees: joinCostFees,
        hostAdditionalPoints: hostAdditionalPoints,
      );

      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Group created successfully!'),
            backgroundColor: AppTheme.successColor,
          ),
        );

        // Navigate back or to the new group
        Navigator.of(context).pop(newGroup);
      }
    } catch (e) {
      Logger.error('Error creating group: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create group. Please try again.'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              onPressed: _closeScreen,
              icon: const Icon(
                Icons.close,
                color: AppTheme.textPrimary,
                size: 28,
              ),
            ),
            Expanded(
              child: const Text(
                'Create Group',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 48), // Balance the close button
          ],
        ),
        actions: const [],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Required Settings Section
            _buildSectionTitle('Required Settings'),
            _buildRequiredSettingsSection(),
            const SizedBox(height: 24),

            // Optional Settings Section
            _buildSectionTitle('Optional Settings'),
            _buildOptionalSettingsSection(),
            const SizedBox(height: 120), // Extra padding for FAB
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isSubmitting ? null : _showPostConfirmation,
        backgroundColor: _isFormValid() && !_isSubmitting
            ? AppTheme.primaryColor
            : AppTheme.textSecondary,
        icon: _isSubmitting
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.launch),
        label: Text(
          _isSubmitting ? 'Creating...' : 'Create Group',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildRequiredSettingsSection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title
          _buildTitleField(),
          _buildDivider(),
          // Description
          _buildDescriptionField(),
          _buildDivider(),
          // Location
          _buildInputField(
            icon: Icons.restaurant,
            controller: _locationController,
            placeholder: 'Restaurant Location',
            onTap: _selectLocation,
          ),
          _buildDivider(),
          // Date
          _buildInputField(
            icon: Icons.calendar_today,
            controller: _dateController,
            placeholder: 'Date',
            onTap: _selectDate,
          ),
          _buildDivider(),
          // Time
          _buildInputField(
            icon: Icons.schedule,
            controller: _timeController,
            placeholder: 'Time',
            onTap: _selectTime,
          ),
          _buildDivider(),
          // People Limit
          _buildPeopleLimitField(),
        ],
      ),
    );
  }

  Widget _buildTitleField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.title,
          color: AppTheme.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _titleController,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            decoration: const InputDecoration(
              hintText: 'Group Title',
              hintStyle: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.description,
          color: AppTheme.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: TextField(
            controller: _descriptionController,
            maxLines: 3,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 16,
            ),
            decoration: const InputDecoration(
              hintText: 'Write an engaging description to attract participants...',
              hintStyle: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onChanged: (value) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _buildInputField({
    required IconData icon,
    required TextEditingController controller,
    required String placeholder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppTheme.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              enabled: false, // Disabled since we use onTap for selection
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                disabledBorder: InputBorder.none,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppTheme.textTertiary,
            size: 20,
          ),
        ],
      ),
    );
  }

  Widget _buildPeopleLimitField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.group,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            const SizedBox(width: 12),
            const Text(
              'People Limit',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
              ),
            ),
          ],
        ),
        Row(
          children: [
            // Minus button
            InkWell(
              onTap: _peopleLimit > 2 ? () => setState(() => _peopleLimit--) : null,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _peopleLimit > 2
                      ? AppTheme.backgroundColor
                      : AppTheme.backgroundColor.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.remove,
                  color: _peopleLimit > 2
                      ? AppTheme.textSecondary
                      : AppTheme.textTertiary,
                  size: 18,
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Number display
            SizedBox(
              width: 32,
              child: Text(
                '$_peopleLimit',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(width: 24),
            // Plus button
            InkWell(
              onTap: _peopleLimit < 8 ? () => setState(() => _peopleLimit++) : null,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOptionalSettingsSection() {
    return Column(
      children: [
        // Image Upload
        _buildImageUploadField(),
        const SizedBox(height: 16),
        // Toggle Settings
        _buildToggleSettings(),
        const SizedBox(height: 16),
        // Gender Selection with Limits
        _buildGenderLimitSelection(),
        const SizedBox(height: 16),
        // Language Selection
        _buildLanguageSelectionField(),
        const SizedBox(height: 16),
        // Age Range
        _buildAgeRangeField(),
        const SizedBox(height: 16),
        // Interests
        _buildInterestsField(),
        const SizedBox(height: 16),
        // Join Cost Fees
        _buildJoinCostField(),
        const SizedBox(height: 16),
        // Host Additional Points
        _buildHostAdditionalPointsField(),
      ],
    );
  }

  Widget _buildGenderLimitSelection() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Allowed Genders',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              TextButton(
                onPressed: () => setState(() {
                  _selectedGenders.contains('Male') &&
                  _selectedGenders.contains('Female') &&
                  _selectedGenders.contains('LGBTQ+')
                      ? _selectedGenders.clear()
                      : _selectedGenders = {'Male', 'Female', 'LGBTQ+'};
                }),
                child: Text(
                  _selectedGenders.length == 3 ? 'Clear All' : 'Select All',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Gender selection checkboxes
          ...['Male', 'Female', 'LGBTQ+'].map((gender) {
            final isSelected = _selectedGenders.contains(gender);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => setState(() {
                  isSelected
                      ? _selectedGenders.remove(gender)
                      : _selectedGenders.add(gender);
                }),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      gender,
                      style: TextStyle(
                        color: isSelected ? AppTheme.textPrimary : AppTheme.textSecondary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          // Gender limits section
          if (_selectedGenders.length < 3 && _selectedGenders.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Gender-based Seat Limits',
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ..._selectedGenders.map((gender) {
              final currentLimit = _genderLimits[gender] ?? 0;
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$gender seats',
                      style: const TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: currentLimit > 0 ? () => setState(() {
                            final newLimits = Map<String, int>.from(_genderLimits);
                            newLimits[gender] = (newLimits[gender] ?? 0) - 1;
                            _genderLimits = newLimits;
                          }) : null,
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: currentLimit > 0
                                  ? AppTheme.backgroundColor
                                  : AppTheme.backgroundColor.withValues(alpha: 0.5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.remove,
                              color: currentLimit > 0
                                  ? AppTheme.textSecondary
                                  : AppTheme.textTertiary,
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 24,
                          child: Text(
                            '$currentLimit',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        InkWell(
                          onTap: () => setState(() {
                            final newLimits = Map<String, int>.from(_genderLimits);
                            newLimits[gender] = (newLimits[gender] ?? 0) + 1;
                            _genderLimits = newLimits;
                          }),
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 8),
            Text(
              'Total gender limits: ${_genderLimits.values.fold(0, (sum, count) => sum + count)} / $_peopleLimit',
              style: TextStyle(
                color: _genderLimits.values.fold(0, (sum, count) => sum + count) <= _peopleLimit
                    ? AppTheme.textSecondary
                    : AppTheme.errorColor,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLanguageSelectionField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Language Requirements',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_selectedLanguages.length} selected',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedLanguages.isEmpty)
            InkWell(
              onTap: _openLanguageSelection,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.borderColor),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Add Languages',
                      style: TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _selectedLanguages.map((language) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        language,
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () => setState(() => _selectedLanguages.remove(language)),
                        borderRadius: BorderRadius.circular(8),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          if (_selectedLanguages.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _openLanguageSelection,
              child: const Text(
                'Add More Languages',
                style: TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildImageUploadField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (_uploadedImagePath != null) ...[
            // Image preview
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: AppTheme.backgroundColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  children: [
                    // Mock image display
                    Container(
                      color: AppTheme.cardColor,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image,
                              size: 48,
                              color: AppTheme.textSecondary,
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Image Preview',
                              style: TextStyle(
                                color: AppTheme.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Remove button
                    Positioned(
                      top: 8,
                      right: 8,
                      child: InkWell(
                        onTap: () => setState(() => _uploadedImagePath = null),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ] else ...[
            // Upload area
            InkWell(
              onTap: _selectImage,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                height: 128,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppTheme.borderColor,
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: AppTheme.backgroundColor,
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate,
                      size: 48,
                      color: AppTheme.textSecondary,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Upload an image',
                      style: TextStyle(
                        color: AppTheme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'PNG, JPG (MAX. 5MB)',
                      style: TextStyle(
                        color: AppTheme.textTertiary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildToggleSettings() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Approved by Creator
          _buildToggleItem(
            title: 'Approved by Creator',
            value: _approvedByCreator,
            onChanged: (value) => setState(() => _approvedByCreator = value),
          ),
          const SizedBox(height: 16),
          // Allow Waiting List
          _buildToggleItem(
            title: 'Allow Waiting List',
            value: _allowWaitingList,
            onChanged: (value) => setState(() => _allowWaitingList = value),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
          ),
        ),
        // Custom toggle switch
        InkWell(
          onTap: () => onChanged(!value),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 44,
            height: 24,
            decoration: BoxDecoration(
              color: value ? AppTheme.primaryColor : AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAgeRangeField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Age Range',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$_ageRangeMin - $_ageRangeMax',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Custom dual-handle slider
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(2),
            ),
            child: Stack(
              children: [
                // Track between handles
                Positioned(
                  left: ((_ageRangeMin - 18) / (65 - 18)) * MediaQuery.of(context).size.width - 32,
                  right: ((65 - _ageRangeMax) / (65 - 18)) * MediaQuery.of(context).size.width - 32,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Min handle
                Positioned(
                  left: ((_ageRangeMin - 18) / (65 - 18)) * (MediaQuery.of(context).size.width - 64) - 6,
                  top: -4,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      final newMin = (18 + (details.globalPosition.dx - 16) / (MediaQuery.of(context).size.width - 32) * (65 - 18)).round();
                      setState(() {
                        _ageRangeMin = newMin.clamp(18, _ageRangeMax - 1);
                      });
                    },
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                // Max handle
                Positioned(
                  left: ((_ageRangeMax - 18) / (65 - 18)) * (MediaQuery.of(context).size.width - 64) - 6,
                  top: -4,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      final newMax = (18 + (details.globalPosition.dx - 16) / (MediaQuery.of(context).size.width - 32) * (65 - 18)).round();
                      setState(() {
                        _ageRangeMax = newMax.clamp(_ageRangeMin + 1, 65);
                      });
                    },
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: AppTheme.primaryColor,
                          width: 2,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Interests',
                style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '${_interests.length}/8',
                style: TextStyle(
                  color: _interests.length >= 3 && _interests.length <= 8
                      ? AppTheme.textSecondary
                      : AppTheme.errorColor,
                  fontSize: 14,
                ),
              ),
              if (_interests.length < 8)
                TextButton(
                  onPressed: _addInterest,
                  child: const Text(
                    'Add Interest',
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _interests.map((interest) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      interest,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: () => setState(() => _interests.remove(interest)),
                      borderRadius: BorderRadius.circular(8),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      margin: const EdgeInsets.symmetric(vertical: 16),
      color: AppTheme.borderColor,
    );
  }

  // Input selection methods (mock implementations)
  void _selectLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location selection coming soon')),
    );
  }

  void _selectDate() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    ).then((date) {
      if (date != null) {
        setState(() {
          _dateController.text = '${date.day}/${date.month}/${date.year}';
        });
      }
    });
  }

  void _selectTime() {
    showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 19, minute: 00),
    ).then((time) {
      if (time != null) {
        setState(() {
          _timeController.text = time.format(context);
        });
      }
    });
  }

  void _selectImage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Image upload coming soon')),
    );
  }

  Widget _buildJoinCostField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.attach_money,
            color: AppTheme.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _joinCostController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: 'Join cost fees (0-999)',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const Text(
            'points',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHostAdditionalPointsField() {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: AppTheme.textSecondary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _hostAdditionalPointsController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                hintText: 'Additional points to add (0-999)',
                hintStyle: TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const Text(
            'points',
            style: TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _addInterest() {
    if (_interests.length >= 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maximum 8 interests allowed'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: Text(
          'Add Interest (${_interests.length}/8)',
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 16,
          ),
          decoration: const InputDecoration(
            hintText: 'Enter interest',
            hintStyle: TextStyle(
              color: AppTheme.textSecondary,
            ),
            border: OutlineInputBorder(),
          ),
          onSubmitted: (value) {
            if (value.trim().isNotEmpty &&
                !_interests.contains(value.trim()) &&
                _interests.length < 8) {
              setState(() {
                _interests.add(value.trim());
              });
            }
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppTheme.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // In a real implementation, you'd get the text from the controller
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _openLanguageSelection() {
    final availableLanguages = [
      'English', 'Spanish', 'French', 'German', 'Italian', 'Portuguese',
      'Chinese', 'Japanese', 'Korean', 'Arabic', 'Hindi', 'Russian'
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceColor,
        title: const Text(
          'Select Languages',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: availableLanguages.length,
            itemBuilder: (context, index) {
              final language = availableLanguages[index];
              final isSelected = _selectedLanguages.contains(language);

              return CheckboxListTile(
                title: Text(
                  language,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                  ),
                ),
                value: isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    if (value == true) {
                      _selectedLanguages.add(language);
                    } else {
                      _selectedLanguages.remove(language);
                    }
                  });
                },
                activeColor: AppTheme.primaryColor,
                checkColor: Colors.white,
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Done',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}