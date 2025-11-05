import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/mock_data_service.dart';
import '../../utils/logger.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final MockDataService _dataService = MockDataService();

  // Filter state
  Set<String> _selectedInterests = {};
  String? _selectedIntent;
  double _maxDistance = 25.0; // Default 25 miles/km
  String _selectedAgeRange = 'All';
  String _selectedGender = 'All';
  Set<String> _selectedLanguages = {};

  // Available options
  List<String> _availableInterests = [];
  List<String> _availableIntents = [];
  List<String> _availableLanguages = [];

  final List<String> _ageRanges = [
    'All',
    '18-25',
    '26-35',
    '36-45',
    '46+'
  ];

  final List<String> _genderOptions = [
    'All',
    'Male',
    'Female',
    'Other'
  ];

  @override
  void initState() {
    super.initState();
    _loadAvailableOptions();
    _loadSavedFilters();
  }

  void _loadAvailableOptions() {
    final groups = _dataService.getGroups();

    // Extract unique interests
    final interestsSet = <String>{};
    final intentsSet = <String>{};

    for (final group in groups) {
      interestsSet.addAll(group.interests);
      if (group.intent.isNotEmpty) {
        intentsSet.add(group.intent);
      }
    }

    setState(() {
      _availableInterests = interestsSet.toList()..sort();
      _availableIntents = intentsSet.toList()..sort();
      _availableLanguages = [
        'English', 'Spanish', 'French', 'German', 'Italian',
        'Portuguese', 'Chinese', 'Japanese', 'Korean', 'Arabic',
        'Hindi', 'Russian', 'Dutch', 'Swedish', 'Norwegian'
      ];
    });
  }

  void _loadSavedFilters() {
    // Load saved filters from preferences (for demo, use defaults)
    // In a real app, this would load from SharedPreferences
    setState(() {
      _selectedInterests = {};
      _selectedIntent = null;
      _maxDistance = 25.0;
      _selectedAgeRange = 'All';
      _selectedGender = 'All';
      _selectedLanguages = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        title: const Text(
          'Filter Groups',
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
            onPressed: _clearAllFilters,
            child: const Text(
              'Clear All',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Interest Filter
            _buildSectionTitle('Interests'),
            const SizedBox(height: AppTheme.spacingSM),
            _buildInterestChips(),
            const SizedBox(height: AppTheme.spacingLG),

            // Intent Filter
            _buildSectionTitle('Intent'),
            const SizedBox(height: AppTheme.spacingSM),
            _buildIntentSelector(),
            const SizedBox(height: AppTheme.spacingLG),

            // Distance Filter
            _buildSectionTitle('Maximum Distance'),
            const SizedBox(height: AppTheme.spacingSM),
            _buildDistanceSlider(),
            const SizedBox(height: AppTheme.spacingLG),

            // Age Range Filter
            _buildSectionTitle('Age Range'),
            const SizedBox(height: AppTheme.spacingSM),
            _buildAgeRangeSelector(),
            const SizedBox(height: AppTheme.spacingLG),

            // Language Filter
            _buildSectionTitle('Languages'),
            const SizedBox(height: AppTheme.spacingSM),
            _buildLanguageChips(),
            const SizedBox(height: AppTheme.spacingLG),

            // Gender Filter
            _buildSectionTitle('Gender'),
            const SizedBox(height: AppTheme.spacingSM),
            _buildGenderSelector(),
            const SizedBox(height: AppTheme.spacingXL),

            // Apply Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Apply Filters',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: AppTheme.textPrimary,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInterestChips() {
    return Wrap(
      spacing: AppTheme.spacingXS,
      runSpacing: AppTheme.spacingXS,
      children: _availableInterests.map((interest) {
        final isSelected = _selectedInterests.contains(interest);
        return FilterChip(
          label: Text(interest),
          selected: isSelected,
          onSelected: (selected) {
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
          checkmarkColor: AppTheme.primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildIntentSelector() {
    if (_availableIntents.isEmpty) {
      return const Text(
        'No intents available',
        style: TextStyle(color: AppTheme.textSecondary),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedIntent,
          hint: const Text('Select intent'),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('All Intents'),
            ),
            ..._availableIntents.map((intent) => DropdownMenuItem<String>(
              value: intent,
              child: Text(intent),
            )),
          ],
          onChanged: (value) {
            setState(() {
              _selectedIntent = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildDistanceSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${_maxDistance.round()} ${_maxDistance == 1 ? 'mile' : 'miles'}',
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        Slider(
          value: _maxDistance,
          min: 1.0,
          max: 100.0,
          divisions: 99,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.primaryColor.withValues(alpha: 0.3),
          onChanged: (value) {
            setState(() {
              _maxDistance = value;
            });
          },
        ),
        const Text(
          'Distance from your location',
          style: TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAgeRangeSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedAgeRange,
          items: _ageRanges.map((range) => DropdownMenuItem<String>(
            value: range,
            child: Text(range),
          )).toList(),
          onChanged: (value) {
            setState(() {
              _selectedAgeRange = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildLanguageChips() {
    return Wrap(
      spacing: AppTheme.spacingXS,
      runSpacing: AppTheme.spacingXS,
      children: _availableLanguages.map((language) {
        final isSelected = _selectedLanguages.contains(language);
        return FilterChip(
          label: Text(language),
          selected: isSelected,
          onSelected: (selected) {
            setState(() {
              if (selected) {
                _selectedLanguages.add(language);
              } else {
                _selectedLanguages.remove(language);
              }
            });
          },
          backgroundColor: AppTheme.surfaceColor,
          selectedColor: AppTheme.primaryColor.withValues(alpha: 0.2),
          checkmarkColor: AppTheme.primaryColor,
          labelStyle: TextStyle(
            color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingMD),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedGender,
          items: _genderOptions.map((gender) => DropdownMenuItem<String>(
            value: gender,
            child: Text(gender),
          )).toList(),
          onChanged: (value) {
            setState(() {
              _selectedGender = value!;
            });
          },
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedInterests.clear();
      _selectedIntent = null;
      _maxDistance = 25.0;
      _selectedAgeRange = 'All';
      _selectedGender = 'All';
      _selectedLanguages.clear();
    });
  }

  void _applyFilters() {
    final filters = {
      'interests': _selectedInterests.toList(),
      'intent': _selectedIntent,
      'maxDistance': _maxDistance,
      'ageRange': _selectedAgeRange,
      'gender': _selectedGender,
      'languages': _selectedLanguages.toList(),
    };

    Logger.info('Applying filters: $filters');

    // Return filters to the previous screen
    Navigator.pop(context, filters);
  }
}