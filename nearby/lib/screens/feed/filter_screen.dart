import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/mock/mock_data_service.dart';
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
    double _maxDistance = 25.0; // Default 25 miles/km
  double _minAge = 18.0; // Default minimum age
  double _maxAge = 40.0; // Default maximum age
  Set<String> _selectedGenders = {}; // Changed to Set for multi-select
  Set<String> _selectedLanguages = {};

  // Available options

  final List<String> _genderOptions = [
    'Male',
    'Female',
    'LGBTQ+'
  ];

  @override
  void initState() {
    super.initState();
    _loadAvailableOptions();
    _loadSavedFilters();
  }

  void _loadAvailableOptions() {
    // Intent functionality removed
  }

  void _loadSavedFilters() {
    // Load saved filters from preferences (for demo, use defaults)
    // In a real app, this would load from SharedPreferences
    setState(() {
      _selectedInterests = {};
      _maxDistance = 25.0;
      _minAge = 18.0;
      _maxAge = 40.0;
      _selectedGenders = {}; // Start with empty set for multi-select
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
    return InkWell(
      onTap: _openInterestSearch,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Interests',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSM),
            if (_selectedInterests.isEmpty)
              Text(
                'Select up to 3 interests',
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 14,
                ),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: AppTheme.spacingXS,
                    runSpacing: AppTheme.spacingXS,
                    children: _selectedInterests.map((interest) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacingSM,
                          vertical: AppTheme.spacingXS,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          interest,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  Text(
                    '${_selectedInterests.length}/3 selected',
                    style: TextStyle(
                      color: _selectedInterests.length >= 3
                          ? AppTheme.textSecondary
                          : AppTheme.textTertiary,
                      fontSize: 12,
                      fontWeight: _selectedInterests.length >= 3
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                  ),
                ],
              ),
          ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Age range display
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppTheme.spacingMD),
          decoration: BoxDecoration(
            color: AppTheme.surfaceColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Age Range',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              Text(
                '${_minAge.round()} - ${_maxAge.round()} years',
                style: const TextStyle(
                  color: AppTheme.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppTheme.spacingMD),

        // Range Slider
        RangeSlider(
          values: RangeValues(_minAge, _maxAge),
          min: 18.0,
          max: 50.0,
          divisions: 32,
          activeColor: AppTheme.primaryColor,
          inactiveColor: AppTheme.primaryColor.withValues(alpha: 0.3),
          labels: RangeLabels(
            '${_minAge.round()}',
            '${_maxAge.round()}',
          ),
          onChanged: (RangeValues values) {
            setState(() {
              _minAge = values.start;
              _maxAge = values.end;
            });
          },
        ),

        const SizedBox(height: AppTheme.spacingMD),

        // Age labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '18',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              '35',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
            Text(
              '50+',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),

        const SizedBox(height: AppTheme.spacingSM),

        Text(
          'Select minimum and maximum age range',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageChips() {
    return InkWell(
      onTap: _openLanguageSearch,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppTheme.spacingMD),
        decoration: BoxDecoration(
          color: AppTheme.surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.dividerColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Languages',
                  style: const TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: AppTheme.textTertiary,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingSM),
            if (_selectedLanguages.isEmpty)
              Text(
                'Select up to 3 languages',
                style: const TextStyle(
                  color: AppTheme.textTertiary,
                  fontSize: 14,
                ),
              )
            else
              Wrap(
                spacing: AppTheme.spacingXS,
                runSpacing: AppTheme.spacingXS,
                children: _selectedLanguages.map((language) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacingSM,
                      vertical: AppTheme.spacingXS,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      language,
                      style: const TextStyle(
                        color: AppTheme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppTheme.spacingMD),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Select All option
          Row(
            children: [
              Text(
                'Gender',
                style: const TextStyle(
                  color: AppTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  setState(() {
                    if (_selectedGenders.length == _genderOptions.length) {
                      // If all are selected, clear all
                      _selectedGenders.clear();
                    } else {
                      // Select all genders
                      _selectedGenders = Set.from(_genderOptions);
                    }
                  });
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  _selectedGenders.length == _genderOptions.length ? 'Clear All' : 'Select All',
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingSM),

          // Selected genders display
          if (_selectedGenders.isEmpty)
            Text(
              'Select genders to filter',
              style: const TextStyle(
                color: AppTheme.textTertiary,
                fontSize: 14,
              ),
            )
          else
            Wrap(
              spacing: AppTheme.spacingXS,
              runSpacing: AppTheme.spacingXS,
              children: _selectedGenders.map((gender) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingSM,
                    vertical: AppTheme.spacingXS,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    gender,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),

          const SizedBox(height: AppTheme.spacingMD),

          // Gender checkboxes
          ..._genderOptions.map((gender) => _buildGenderCheckbox(gender)),
        ],
      ),
    );
  }

  Widget _buildGenderCheckbox(String gender) {
    final bool isSelected = _selectedGenders.contains(gender);

    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedGenders.remove(gender);
          } else {
            _selectedGenders.add(gender);
          }
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
                  width: 2,
                ),
                color: isSelected ? AppTheme.primaryColor : Colors.transparent,
              ),
              child: isSelected
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    )
                  : null,
            ),
            const SizedBox(width: AppTheme.spacingSM),
            Text(
              gender,
              style: TextStyle(
                color: isSelected ? AppTheme.primaryColor : AppTheme.textPrimary,
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearAllFilters() {
    setState(() {
      _selectedInterests.clear();
            _maxDistance = 25.0;
      _minAge = 18.0;
      _maxAge = 40.0;
      _selectedGenders.clear();
      _selectedLanguages.clear();
    });
  }

  void _openInterestSearch() async {
    final result = await Navigator.pushNamed(
      context,
      '/interest_search',
      arguments: {'selectedInterests': _selectedInterests},
    );

    if (result != null && result is Set<String>) {
      setState(() {
        _selectedInterests = result;
      });
    }
  }

  void _openLanguageSearch() async {
    final result = await Navigator.pushNamed(
      context,
      '/language_search',
      arguments: {'selectedLanguages': _selectedLanguages},
    );

    if (result != null && result is Set<String>) {
      setState(() {
        _selectedLanguages = result;
      });
    }
  }

  void _applyFilters() {
    final filters = {
      'interests': _selectedInterests.toList(),
            'maxDistance': _maxDistance,
      'minAge': _minAge,
      'maxAge': _maxAge,
      'genders': _selectedGenders.toList(), // Changed to list for multi-select
      'languages': _selectedLanguages.toList(),
    };

    Logger.info('Applying filters: $filters');

    // Return filters to the previous screen
    Navigator.pop(context, filters);
  }
}